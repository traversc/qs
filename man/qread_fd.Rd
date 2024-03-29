% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/zz_help_files.R
\name{qread_fd}
\alias{qread_fd}
\title{qread_fd}
\usage{
qread_fd(fd, use_alt_rep=FALSE, strict=FALSE)
}
\arguments{
\item{fd}{A file descriptor.}

\item{use_alt_rep}{Use ALTREP when reading in string data (default \code{FALSE}). On R versions prior to 3.5.0, this parameter does nothing.}

\item{strict}{Whether to throw an error or just report a warning (default: \code{FALSE}, i.e. report warning).}
}
\value{
The de-serialized object.
}
\description{
Reads an object from a file descriptor.
}
\details{
See \code{\link[=qsave_fd]{qsave_fd()}} for additional details and examples.
}
