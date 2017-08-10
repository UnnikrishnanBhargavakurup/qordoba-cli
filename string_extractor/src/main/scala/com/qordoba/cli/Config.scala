package com.qordoba.cli

case class Config(directory: String = "",
                  infile: String = "",
                  outfile: String = "",
                  verbose: Boolean = false,
                  debug: Boolean = false)
