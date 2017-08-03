#!/bin/bash

########
#
# This is a script to extract string literals from any given text file.
#
# Requires an installation of ANTLR4
#
########

antlr4 StringExtractor.g4
javac StringExtractor*.java
grun StringExtractor textfile -tokens ../setup.py | grep StringLiteral

