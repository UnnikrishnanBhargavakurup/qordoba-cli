package com.qordoba.cli

import com.typesafe.scalalogging.slf4j.LazyLogging
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

  scenario(s"Full application, generated file") {
    StringExtractorApp.main(args)

    val outfileContents = Source.fromFile(outfile).getLines.toList
    val knownGoodContents = Source.fromURL(knownGoodFileUrl).getLines.toList

    logger.debug(s"outfileContents: ${outfileContents}")
    logger.debug(s"knownGoodContents: ${knownGoodContents}")

    outfileContents.length shouldBe knownGoodContents.length

    // TODO: Cleanup output file
  }

  scenario(s"Tokenization") {
    val app = new StringExtractorApp(infile, outfile)
    val tokens = app.getTokens()

    tokens.size shouldBe 14257
  }

}
