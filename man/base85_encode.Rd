% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ascii_encoding.R
\name{base85_encode}
\alias{base85_encode}
\title{Z85 Encoding}
\usage{
base85_encode(rawdata)
}
\arguments{
\item{rawdata}{A raw vector.}
}
\value{
A string representation of the raw vector.
}
\description{
Encodes binary data (a raw vector) as ASCII text using \href{https://rfc.zeromq.org/spec/32/}{Z85 encoding format}.
}
\details{
Z85 is a binary to ASCII encoding format created by Pieter Hintjens in 2010 and is part of the ZeroMQ RFC.
The encoding has a dictionary using 85 out of 94 printable ASCII characters.
There are other base 85 encoding schemes, including Ascii85, which is popularized and used by Adobe.
Z85 is distinguished by its choice of dictionary, which is suitable for easier inclusion into source code for many programming languages.
The dictionary excludes all quote marks and other control characters, and requires no special treatment in R and most other languages.
Note: although the official specification restricts input length to multiples of four bytes, the implementation here works with any input length.
The overhead (extra bytes used relative to binary) is 25\%. In comparison, base 64 encoding has an overhead of 33.33\%.
}
\references{
https://rfc.zeromq.org/spec/32/
}
