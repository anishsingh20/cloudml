% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/jobs.R
\name{job_collect_async}
\alias{job_collect_async}
\title{Collect Job Output Asynchronously}
\usage{
job_collect_async(job, gcloud = NULL, destination = "runs",
  polling_interval = getOption("cloudml.collect.polling", 2),
  view = interactive())
}
\arguments{
\item{job}{Job name or job object.}

\item{gcloud}{Optional gcloud configuration.}

\item{destination}{The destination directory in which model outputs should
be downloaded. Defaults to \code{runs}.}

\item{polling_interval}{Number of seconds to wait between efforts to fetch the
latest log messages.}

\item{view}{View the job after collecting it.}
}
\description{
Collect the job outputs (e.g. fitted model) from a job asynchronously
using the RStudio terminal, if available.
}
\seealso{
Other job management: \code{\link{job_cancel}},
  \code{\link{job_collect}}, \code{\link{job_describe}},
  \code{\link{job_list}}, \code{\link{job_status}},
  \code{\link{job_stream}}
}
\concept{job management}
