package com.qordoba.cli

case class Config(infile: String = "",
                  outfile: String = "",
                  verbose: Boolean = false,
                  debug: Boolean = false)
