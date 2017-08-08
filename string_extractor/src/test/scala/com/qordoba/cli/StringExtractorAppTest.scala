package com.qordoba.cli

import com.typesafe.scalalogging.slf4j.LazyLogging
import java.io.File
import org.scalatest.{FeatureSpec, ShouldMatchers}
import scala.io.Source

/**
  * Tests expected functionality of the StringExtractorApp
  */
class StringExtractorAppTest extends FeatureSpec with ShouldMatchers with LazyLogging {
  val infile = getClass.getResource("/merge_spark_pr.py").getPath
  val outfile = "string_literals.csv"
  val knownGoodFileUrl = getClass.getResource("/merge_spark_pr_string_literals.csv")
  val args = Array(infile, outfile)

  feature(s"File generation") {

    scenario(s"Full application") {
      StringExtractorApp.main(args)
      compareFiles
    }

    scenario(s"Write to CSV") {
      val app = new StringExtractorApp(infile, outfile)
      val tokens = app.getTokens()
      val stringLiterals = app.findStringLiterals(tokens)
      app.generateCsv(stringLiterals, outfile)

      compareFiles
    }

    def compareFiles = {
      new File(outfile).exists() shouldBe true

      val outfileContents = Source.fromFile(outfile).getLines.toList
      val knownGoodContents = Source.fromURL(knownGoodFileUrl).getLines.toList

      logger.debug(s"outfileContents: ${outfileContents}")
      logger.debug(s"knownGoodContents: ${knownGoodContents}")

      outfileContents.length shouldBe knownGoodContents.length

      logger.debug(s"Removing temp file ${outfile}")
      new File(outfile).delete
    }
  }

  feature(s"Lexer") {
    scenario(s"Tokenization") {
      val app = new StringExtractorApp(infile, outfile)
      val tokens = app.getTokens()

      tokens.size shouldBe 14257
    }
  }

  feature(s"Token filter") {
    scenario(s"Find string literals") {
      val app = new StringExtractorApp(infile, outfile)
      val tokens = app.getTokens()
      val stringLiterals = app.findStringLiterals(tokens)

      stringLiterals.length shouldBe 220
      stringLiterals.head.filename shouldBe infile
      stringLiterals.head.text shouldBe "\"License\""
    }
  }

}
