% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/edit_access.R
\name{edit_access}
\alias{edit_access}
\title{Shiny App for editing the metadata access table}
\usage{
edit_access(filepath = "metadata-tables/access.csv", outdir = getwd(),
  outfilename = "access")
}
\arguments{
\item{filepath}{the filepath leading to the access.csv file}

\item{outdir}{The directory to save the edited access info to}

\item{outfilename}{The filename to save with. Defaults to access.csv.}
}
\description{
Shiny App for editing the metadata access table
}
\examples{
\dontrun{
editTable(DF = access)

}
}
