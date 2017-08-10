package com.qordoba.cli

import com.typesafe.scalalogging.slf4j.LazyLogging
import java.io.File
import org.scalatest.{FeatureSpec, ShouldMatchers}
import scala.io.Source

/**
  * Tests expected functionality of the StringExtractorApp
  */
class StringExtractorAppTest extends FeatureSpec with ShouldMatchers with LazyLogging {
  val infile = getClass.getResource("/python/merge_spark_pr.py").getPath
  val outfile = "string_literals.csv"
  val knownGoodFileUrl = getClass.getResource("/merge_spark_pr_string_literals.csv")
  val args = Array("-i", infile,
                   "-o", outfile)

  feature(s"File generation") {

    scenario(s"Full application") {
      StringExtractorApp.main(args)
      compareFiles
    }

    scenario(s"Write to CSV") {
      val app = new StringExtractorApp(infile, outfile)
      val tokens = app.getTokens(infile)
      val stringLiterals = app.findStringLiterals(infile, tokens)
      app.generateCsv(stringLiterals, outfile)

      compareFiles
    }

    def compareFiles = {
      new File(outfile).exists() shouldBe true

      val outfileContents = Source.fromFile(outfile).getLines.toList
      val knownGoodContents = Source.fromURL(knownGoodFileUrl).getLines.toList

      outfileContents.length shouldBe knownGoodContents.length

      logger.debug(s"Removing temp file ${outfile}")
      new File(outfile).delete
    }
  }

  feature(s"Lexer") {
    scenario(s"Tokenization single file") {
      val app = new StringExtractorApp(infile, outfile)
      val tokens = app.getTokens(infile)

      tokens.size shouldBe 10807
    }
  }

  feature(s"Token filter") {
    scenario(s"Find string literals single file") {
      val app = new StringExtractorApp(infile, outfile)
      val tokens = app.getTokens(infile)
      val stringLiterals = app.findStringLiterals(infile, tokens)

      stringLiterals.length shouldBe 189
      stringLiterals.head.filename shouldBe infile
      stringLiterals.head.text shouldBe "\"SPARK_HOME\""
    }
  }

}
