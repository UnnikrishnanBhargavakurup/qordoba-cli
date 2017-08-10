package com.qordoba.cli

import com.typesafe.scalalogging.slf4j.LazyLogging
import java.io.File
import java.net.URL

import org.scalatest.{FeatureSpec, ShouldMatchers}

import scala.io.Source

/**
  * Tests expected functionality of the StringExtractorApp
  */
class StringExtractorAppTest extends FeatureSpec with ShouldMatchers with LazyLogging {
  val infileName: String = "/python/merge_spark_pr.py"
  val infilePath = getClass.getResource(infileName).getPath
  val inDirPath: String = getClass.getResource("/python").getPath
  val outfileName: String = "string_literals.csv"

  feature(s"File generation") {

    scenario(s"Full application single file") {
      val knownGoodFileName: String = "/string_literals/merge_spark_pr_string_literals.csv"
      val args: Array[String] = Array("-i", infilePath,
        "-o", outfileName)
      StringExtractorApp.main(args)
      compareFiles(outfileName, knownGoodFileName) shouldBe true
    }

    scenario(s"Full application directory") {
      val knownGoodFileName: String = "/string_literals/python_string_literals.csv"
      val args = Array("-d", inDirPath,
        "-o", outfileName)
      StringExtractorApp.main(args)
      compareFiles(outfileName, knownGoodFileName) shouldBe true
    }

    scenario(s"Write to CSV single file") {
      val knownGoodFileName: String = "/string_literals/merge_spark_pr_string_literals.csv"

      val app = new StringExtractorApp(infilePath, outfileName)
      val tokens = app.getTokens(infilePath)
      val stringLiterals = app.findStringLiterals(infilePath, tokens)
      app.generateCsv(stringLiterals, outfileName)

      compareFiles(outfileName, knownGoodFileName) shouldBe true
    }

    def compareFiles(fileName: String, knownGoodFileName: String): Boolean = {
      val knownGoodFileUrl: URL = getClass.getResource(knownGoodFileName)

      new File(fileName).exists() shouldBe true

      val outfileContents: List[String] = Source.fromFile(fileName).getLines.toList
      val knownGoodContents: List[String] = Source.fromURL(knownGoodFileUrl).getLines.toList

      outfileContents.length shouldBe knownGoodContents.length

      logger.debug(s"Removing temp file ${fileName}")
      new File(fileName).delete

      true
    }
  }

  feature(s"Lexer") {
    scenario(s"Tokenization single file") {
      val app = new StringExtractorApp(infilePath, outfileName)
      val tokens = app.getTokens(infilePath)

      tokens.size shouldBe 10807
    }
  }

  feature(s"Token filter") {
    scenario(s"Find string literals single file") {
      val app = new StringExtractorApp(infilePath, outfileName)
      val tokens = app.getTokens(infilePath)
      val stringLiterals = app.findStringLiterals(infilePath, tokens)

      stringLiterals.length shouldBe 189
      stringLiterals.head.filename shouldBe infilePath
      stringLiterals.head.text shouldBe "\"SPARK_HOME\""
    }
  }

}
