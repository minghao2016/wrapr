% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/as_named_list.R
\name{as_named_list}
\alias{as_named_list}
\title{Capture named objects as a named list.}
\usage{
as_named_list(...)
}
\arguments{
\item{...}{argument names (must be names, not strings or values) plus possible assigned values.}
}
\value{
a named list mapping argument names to argument values
}
\description{
Build a named list from a sequence of named arguments of the form NAME, or NAME = VALUE.
This is intended to shorten forms such as \code{list(a = a, b = b)} to \code{as_named_list(a, b)}.
}
\examples{

a <- data.frame(x = 1)
b <- 2

str(as_named_list(a, b))

as_named_list(a, x = b, c = 1 + 1)

# an example application for this function is managing saving and
# loading values into the workspace.
if(FALSE) {
  # remotes::install_github("WinVector/wrapr")
  library(wrapr)

  a <- 5
  b <- 7
  do_not_want <- 13

  # save the elements of our workspace we want
  saveRDS(as_named_list(a, b), 'example_data.RDS')

  # clear values out of our workspace for the example
  rm(list = ls())
  ls()
  # notice workspace environemnt now empty

  # read back while documenting what we expect to
  # read in
  unpack[a, b] <- readRDS('example_data.RDS')

  # confirm what we have, the extra unpack is a side
  # effect of the []<- notation. To avoid this instead
  # use one of:
  #   unpack(readRDS('example_data.RDS'), a, b)
  #   readRDS('example_data.RDS') \%.>\% unpack(., a, b)
  #   readRDS('example_data.RDS') \%.>\% unpack[a, b]
  ls()
  # notice do_not_want is not present

  print(a)

  print(b)
}

}
