% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/rpc-eth.R
\name{eth_getBlockTransactionCountByHash}
\alias{eth_getBlockTransactionCountByHash}
\title{Returns the number of transactions in a block matching the given block hash.}
\usage{
eth_getBlockTransactionCountByHash(hash)
}
\arguments{
\item{hash}{Hash of a block.}
}
\value{
Integer.
}
\description{
Returns the number of transactions in a block matching the given block hash.
}
\examples{
\dontrun{
eth_getBlockTransactionCountByHash(
  "0xb6d656ead4c3d4b1aa24d6b4d3d4cde8c090794e597258993512d650f088fcba"
)
}
}
