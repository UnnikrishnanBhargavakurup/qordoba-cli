package com.qordoba.cli

import java.io._

import com.opencsv.CSVWriter
import com.qordoba.cli.grammar.StringExtractorLexer
import com.typesafe.scalalogging.slf4j.LazyLogging
import org.antlr.v4.runtime.{ANTLRInputStream, CommonTokenStream, Token}

import scala.collection.JavaConversions._
import scala.collection.mutable.ListBuffer

/**
  * Application that uses a precompiled ANTLR grammar to extract string literals from a given file
  */
object StringExtractorApp extends App with LazyLogging {

  override def main(args: Array[String]) {

    val argMissingText = "Infile and outfile arguments required"
    val usageText = "Usage: StringExtractorApp <infile> <outfile>"

    // TODO: Add support for -f, -d, -o
    val infileName = if (args.size > 0) {
      args.head
    } else {
      println(argMissingText)
      println(usageText)
      return
    }

    val outfileName = if (args.size > 1) {
      args(1)
    } else {
      println(argMissingText)
      println(usageText)
      return
    }

    // A place to store everything that should go in the output file
    val allStringLiterals: ListBuffer[StringLiteral] = scala.collection.mutable.ListBuffer.empty[StringLiteral]

    try {
      val infile: File = new File(infileName)
      val fis = new FileInputStream(infile)
      val input: ANTLRInputStream = new ANTLRInputStream(fis)
      val lexer: StringExtractorLexer = new StringExtractorLexer(input)
      val tokenStream: CommonTokenStream = new CommonTokenStream(lexer)

      // Activate the lexer
      tokenStream.fill()

      // Inspect each token for something interesting
      val tokens = tokenStream.getTokens().iterator()
      while (tokens.hasNext()) {
        val token: Token = tokens.next()

        // Look for StringLiteral (value of 1 in StringExtractorLexer.tokens)
        if (token.getType() == 1) {
          val stringLiteral: StringLiteral = new StringLiteral(
            filename = infileName,
            text = token.getText(),
            startLineNumber = token.getLine(),
            startCharIdx = token.getCharPositionInLine(),
            endLineNumber = token.getLine(),
            endCharIdx = token.getCharPositionInLine() + token.getText().size - 1  // 0-based index, inclusive
          )
          allStringLiterals += stringLiteral
        }
      }

      // Send our treasures to a file
      writeToCsv(allStringLiterals.toList, outfileName)
    } catch {
      case e: Exception => println(s"Unable to parse ${infileName}: ${e}")
    }
  }

  private def writeToCsv(allStringLiterals: List[StringLiteral], outfileName: String) = {
    val writer = new StringWriter()
    val csvWriter = new CSVWriter(writer)

    // Convert to a format the OpenCVS can do something with
    val toWrite: List[Array[String]] = allStringLiterals.map(stringLiteral => stringLiteral.toStringArray())

    csvWriter.writeAll(toWrite, false)
    csvWriter.close()

    logger.debug(writer.toString())

    val outfile = new File(outfileName)
    val bw = new BufferedWriter(new FileWriter(outfile))
    bw.write(writer.toString())
    bw.close()

    logger.debug(s"String literals written to ${outfileName}")
  }
}
