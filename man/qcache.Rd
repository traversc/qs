% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/qcache.R
\name{qcache}
\alias{qcache}
\title{qcache}
\usage{
qcache(
  expr,
  name,
  envir = parent.frame(),
  cache_dir = ".cache",
  clear = FALSE,
  prompt = TRUE,
  qsave_params = list(),
  qread_params = list()
)
}
\arguments{
\item{expr}{The expression to evaluate.}

\item{name}{The cached expression name (see details).}

\item{envir}{The environment to evaluate \code{expr} in.}

\item{cache_dir}{The directory to store cached files in.}

\item{clear}{Set to \code{TRUE} to clear the cache (see details).}

\item{prompt}{Whether to prompt before clearing.}

\item{qsave_params}{Parameters passed on to \code{qsave}.}

\item{qread_params}{Parameters passed on to \code{qread}.}
}
\description{
Helper function for caching objects for long running tasks
}
\details{
This is a (very) simple helper function to cache results of long running calculations. There are other packages specializing
in caching data that are more feature complete.

The evaluated expression is saved with \code{\link[=qsave]{qsave()}} in \verb{<cache_dir>/<name>.qs}.
If the file already exists instead, the expression is not evaluated and the cached result is read using \code{\link[=qread]{qread()}} and returned.

To clear a cached result, you can manually delete the associated \code{.qs} file, or you can call \code{\link[=qcache]{qcache()}} with \code{clear = TRUE}.
If \code{prompt} is also \code{TRUE} a prompt will be given asking you to confirm deletion.
If \code{name} is not specified, all cached results in \code{cache_dir} will be removed.
}
\examples{
cache_dir <- tempdir()

a <- 1
b <- 5

# not cached
result <- qcache({a + b},
                 name="aplusb",
                 cache_dir = cache_dir,
                 qsave_params = list(preset="fast"))

# cached
result <- qcache({a + b},
                 name="aplusb",
                 cache_dir = cache_dir,
                 qsave_params = list(preset="fast"))

# clear cached result
qcache(name="aplusb", clear=TRUE, prompt=FALSE, cache_dir = cache_dir)
}
