#' Copy files to / from Google Storage
#'
#' Use the `gsutil cp` command to copy data between your local file system and
#' the cloud, copy data within the cloud, and copy data between cloud storage
#' providers.
#'
#' @inheritParams gcloud_exec
#'
#' @param source
#'   The file to be copied. This can be either a path on the local
#'   filesystem, or a Google Storage URI (e.g. `gs://[BUCKET_NAME]/[FILENAME.CSV]`).
#'
#' @param destination
#'   The location where the `source` file should be copied to. This can be
#'   either a path on the local filesystem, or a Google Storage URI (e.g.
#'   `gs://[BUCKET_NAME]/[FILENAME.CSV]`).
#'
#' @param recursive
#'   Boolean; perform a recursive copy? This must be specified if you intend on
#'   copying directories.
#'
#' @export
gsutil_copy <- function(source, destination, recursive = FALSE, echo = FALSE) {

  arguments <- c(
    "-m",
    "cp",
    if (recursive) "-r",
    source,
    destination
  )

  gsutil_exec(args = arguments, echo = echo)
}

#' Get local path to data within Google Storage
#'
#' When running on Google Cloud the path is returned unchanged. When running in
#' other contexts the file is copied to the local system and a path to the local
#' file is returned. If a plain filesystem path is passed then it is also
#' returned unchanged.
#'
#' @inheritParams gsutil_copy
#'
#' @param uri Path to Google Storage data
#' @param local_dir Local directory to copy files into
#'
#' @return Path to data file (may be local or remote depending on the execution
#'   context).
#'
#' @export
gsutil_data <- function(uri, local_dir = "gs") {
  if (!is_gs_uri(uri))
    uri
  else {
    # extract [BUCKET_NAME]/[OBJECT_NAME] and build local path
    object_path <- substring(uri, nchar("gs://") + 1)
    local_path <- file.path(local_dir, object_path)

    # download if necessary
    if (!file.exists(local_path)) {

      # create the directory if necessary
      local_dir <- dirname(local_path)
      if (!utils::file_test("-d", local_dir))
        dir.create(local_dir, recursive = TRUE)

      # first attempt download via public api endpoint
      public_url <- paste0("https://storage.googleapis.com/", object_path)
      result <- tryCatch(suppressWarnings(download.file(public_url, local_path)),
                         error = function(e) 1)

      # if that failed then try gsutil_copy (which requires auth)
      if (result != 0)
        gsutil_copy(uri, local_path)
    }

    # return path
    local_path
  }
}

is_gs_uri <- function(file) {
  is.character(file) && grepl("^gs://.+$", file)
}
