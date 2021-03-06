context("train")

expect_train_succeeds <- function(job) {
  expect_gt(nchar(job$id), 0)
  expect_gt(length(job$description), 0)
  expect_gt(nchar(job$description$state), 0)

  collected <- job_collect(job)

  expect_true(dir.exists("runs"))

  saved_model <- dir(
    "runs",
    recursive = TRUE,
    full.names = TRUE,
    pattern = "saved_model")

  expect_gte(length(saved_model), 1)
}

test_that("cloudml_train() can train and collect savedmodel", {
  if (!cloudml_tests_configured()) return()

  with_temp_training_dir(system.file("examples/mnist", package = "cloudml"), {
    config_yml <- "cloudml.yml"
    mnist_config <- yaml::yaml.load(readLines(config_yml))
    cloudml_write_config(mnist_config, config_yml)

    job <- cloudml_train(
      application = system.file(
        "examples/mnist/",
        package = "cloudml"
      ),
      entrypoint = "train.R"
    )

    expect_train_succeeds(job)
  })
})

test_that("cloudml_train() can train keras model", {
  if (!cloudml_tests_configured()) return()

  with_temp_training_dir(system.file("examples/keras", package = "cloudml"), {
    config_yml <- "cloudml.yml"
    mnist_config <- yaml::yaml.load(readLines(config_yml))
    cloudml_write_config(mnist_config, config_yml)

    job <- cloudml_train()

    expect_train_succeeds(job)
  })

})

with_temp_training_dir <- function(training_dir, expr) {

  # create temp directory and copy training_dir to it
  temp_training_dir <- tempfile("training-dir", fileext = ".dir")
  dir.create(temp_training_dir)
  on.exit(unlink(temp_training_dir, recursive = TRUE), add = TRUE)
  file.copy(training_dir, temp_training_dir, recursive = TRUE)
  withr::with_dir(temp_training_dir, expr)
}
