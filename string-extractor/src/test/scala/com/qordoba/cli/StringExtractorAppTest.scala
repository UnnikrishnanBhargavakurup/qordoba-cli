package com.qordoba.cli

import com.typesafe.scalalogging.slf4j.LazyLogging
import java.io.File
import java.net.URL
import scala.collection.mutable.ListBuffer
import com.qordoba.cli.grammar.StringExtractorParser.StringLiteralContext
import org.scalatest.{FeatureSpec, Matchers, ShouldMatchers}
import scala.io.Source

/**
  * Tests expected functionality of the StringExtractorApp
  */
class StringExtractorAppTest extends FeatureSpec with Matchers with ShouldMatchers with LazyLogging {

  val infileName: String = "/python/merge_spark_pr.py"
  val infilePath: String = getClass.getResource(infileName).getPath
  val inDirPath: String = getClass.getResource("/python").getPath

  val outfileName: String = "/string_literals_test.csv"
  val outDirPath: String = getClass.getResource("/string_literals").getPath
  val outfilePath: String = new File(outDirPath, outfileName).getPath
  val knownGoodFileName: String = "/string_literals/merge_spark_pr_string_literals.csv"
  val inDirPathKnownGoodFileName: String = getClass.getResource("/string_literals").getPath
  val inFilePathknownGoodFileName: String = inDirPathKnownGoodFileName + "/merge_spark_pr_string_literals.csv"

  feature(s"File generation") {
    scenario(s"Full application single file") {
      val knownGoodFileName: String = "/string_literals/merge_spark_pr_string_literals.csv"
      val args: Array[String] = Array("-i", infilePath,
        "-o", outfilePath)
      StringExtractorApp.main(args)
      compareFiles(outfilePath, knownGoodFileName, inFilePathknownGoodFileName) shouldBe true
    }

    scenario(s"Full application directory") {
      val knownGoodFileNameUnique: String = "/string_literals/python_string_literals.csv"
      val inDirPathKnownGoodFileName: String = getClass.getResource("/string_literals").getPath
      val inFilePathknownGoodFileName: String = inDirPathKnownGoodFileName + "/python_string_literals.csv"
      val args = Array("-d", inDirPath,
        "-o", outfilePath)
      StringExtractorApp.main(args)
      compareFiles(outfilePath, knownGoodFileNameUnique, inFilePathknownGoodFileName) shouldBe true
    }

    scenario(s"Write to CSV single file") {
      val app = new StringExtractorApp(infilePath, outfilePath)
      val tokens = app.getTokens(infilePath)
      val stringLiterals = app.findStringLiterals(infilePath, tokens)
      app.generateCsv(stringLiterals, outfilePath)
      compareFiles(outfilePath, knownGoodFileName, inFilePathknownGoodFileName) shouldBe true
    }
    
    def compareFiles(outfilePath: String, knownGoodFileName: String, inFilePathknownGoodFileName: String) = {

      val knownGoodFileUrl: URL = getClass.getResource(knownGoodFileName)
      new File(outfilePath).exists() shouldBe true

      val outfileContents: List[String] = Source.fromFile(outfilePath).getLines.toList
      val knownGoodContents: List[String] = Source.fromURL(knownGoodFileUrl).getLines.toList

      // high level check, if file lengths coincide
      outfileContents.length shouldBe knownGoodContents.length

      // prepping List of StringLiterals for comparison
      var stringLiteralsOutfileContents = new ListBuffer[StringLiteral]()
      for (line <- outfileContents) {
        val values = line.split(",").map(_.trim)
        if (values.length == 6) {
          val singleStringLiteral = new StringLiteral(values(0), values(1).toInt, values(2).toInt, values(3).toInt, values(4).toInt, values(5))
          stringLiteralsOutfileContents += singleStringLiteral
        }
      }

      // prepping List of StringLiterals for comparison
      var stringLiteralsKnownGoodContents = new ListBuffer[StringLiteral]()
      for (line <- outfileContents) {
        val values = line.split(",").map(_.trim)
        if (values.length == 6) {
          val singleStringLiteral = new StringLiteral(values(0), values(1).toInt, values(2).toInt, values(3).toInt, values(4).toInt, values(5))
          stringLiteralsKnownGoodContents += singleStringLiteral
        }
      }

      logger.debug(s"comparing line_number_start, character_number_start, line_number_end, character_number_end, string")
      stringLiteralsKnownGoodContents.map(_.startLineNumber) shouldBe stringLiteralsOutfileContents.map(_.startLineNumber)
      stringLiteralsKnownGoodContents.map(_.endLineNumber) shouldBe stringLiteralsOutfileContents.map(_.endLineNumber)
      stringLiteralsKnownGoodContents.map(_.startCharIdx) shouldBe stringLiteralsOutfileContents.map(_.startCharIdx)
      stringLiteralsKnownGoodContents.map(_.endCharIdx) shouldBe stringLiteralsOutfileContents.map(_.endCharIdx)
      stringLiteralsKnownGoodContents.map(_.text) shouldBe stringLiteralsOutfileContents.map(_.text)

      logger.debug(s"Removing temp file ${outfilePath}")
      new File(outfilePath).delete
      true
    }
  }

  feature(s"Lexer") {
    scenario(s"Tokenization single file") {
      val app = new StringExtractorApp(infilePath, outfilePath)

      val tokens = app.getTokens(infilePath)

      tokens.size shouldBe 10807
    }
  }

  feature(s"Token filter") {
    scenario(s"Find string literals single file") {
      val app = new StringExtractorApp(infilePath, outfilePath)

      val tokens = app.getTokens(infilePath)
      val stringLiterals = app.findStringLiterals(infilePath, tokens)

      stringLiterals.length shouldBe 189
      stringLiterals.head.filename shouldBe infilePath
      stringLiterals.head.text shouldBe "\"SPARK_HOME\""
    }
  }
}

