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
class StringExtractorAppTest extends FeatureSpec with ShouldMatchers with LazyLogging {

  val infileNamePython: String = "/python/merge_spark_pr.py"
  val infilePathPython = getClass.getResource(infileNamePython).getPath
  val inDirPathPython: String = getClass.getResource("/python").getPath
  val outfileNamePython: String = "string_literals_python.csv"
  val knownGoodFileNamePython: String = "/string_literals/merge_spark_pr_string_literals.csv"

  val infileNameScala: String = "/scala/scala-ide-scalariform.scala"
  val infilePathScala = getClass.getResource(infileNameScala).getPath
  val inDirPathScala: String = getClass.getResource("/scala").getPath
  val outfileNameScala: String = "string_literals_scala.csv"
  val knownGoodFileNameScala: String = "/string_literals/scala-ide-scalariform_string_literals.csv"
  val outfileName: String = "/string_literals_test.csv"
  val outDirPath: String = getClass.getResource("/string_literals").getPath
  val outfilePath: String = new File(outDirPath, outfileName).getPath
  val knownGoodFileName: String = "/string_literals/merge_spark_pr_string_literals.csv"
  val inDirPathKnownGoodFileName: String = getClass.getResource("/string_literals").getPath
  val inFilePathknownGoodFileName: String = inDirPathKnownGoodFileName + "/merge_spark_pr_string_literals.csv"

  feature(s"File generation") {
    scenario(s"Full application single file") {
      val args_python: Array[String] = Array("-i", infilePathPython,
        "-o", outfileNamePython)
      StringExtractorApp.main(args_python)
      compareFiles(outfileNamePython, knownGoodFileNamePython) shouldBe true

      val args_scala: Array[String] = Array("-i", infilePathScala,
        "-o", outfileNameScala)
      StringExtractorApp.main(args_scala)
      compareFiles(outfileNameScala, knownGoodFileNameScala) shouldBe true

    }

    scenario(s"Full application directory") {
      val args_python = Array("-d", inDirPathPython,
        "-o", outfileNamePython)
      StringExtractorApp.main(args_python)
      compareFiles(outfileNamePython, knownGoodFileNamePython) shouldBe true

      val args_scala = Array("-d", inDirPathScala,
        "-o", outfileNameScala)
      StringExtractorApp.main(args_scala)
      compareFiles(outfileNameScala, knownGoodFileNameScala) shouldBe true
    }


    scenario(s"Write to CSV single file") {
      val appPython = new StringExtractorApp(infilePathPython, outfileNamePython)
      val tokensPython = appPython.getTokens(infilePathPython)
      val stringLiteralsPython = appPython.findStringLiterals(infilePathPython, tokensPython)
      appPython.generateCsv(stringLiteralsPython, outfileNamePython)

      compareFiles(outfileNamePython, knownGoodFileNamePython) shouldBe true

      val appScala = new StringExtractorApp(infilePathScala, outfileNameScala)
      val tokensScala = appScala.getTokens(infilePathScala)
      val stringLiteralsScala = appScala.findStringLiterals(infilePathScala, tokensScala)
      appScala.generateCsv(stringLiteralsScala, outfileNameScala)

      compareFiles(outfileNameScala, knownGoodFileNameScala) shouldBe true
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
      val appPython = new StringExtractorApp(infilePathPython, outfileNamePython)
      val tokensPython = appPython.getTokens(infilePathPython)
      val appScala = new StringExtractorApp(infilePathScala, outfileNameScala)
      val tokensScala = appScala.getTokens(infilePathScala)


      tokensPython.size shouldBe 10807
      tokensScala.size shouldBe 10015
    }
  }

  feature(s"Token filter") {
    scenario(s"Find string literals single file") {
      val appPython = new StringExtractorApp(infilePathPython, outfileNamePython)
      val tokensPython = appPython.getTokens(infilePathPython)
      val stringLiteralsPython = appPython.findStringLiterals(infilePathPython, tokensPython)

      stringLiteralsPython.length shouldBe 189
      stringLiteralsPython.head.filename shouldBe infilePathPython
      stringLiteralsPython.head.text shouldBe "\"SPARK_HOME\""

      val appScala = new StringExtractorApp(infilePathScala, outfileNameScala)
      val tokensScala = appScala.getTokens(infilePathScala)
      val stringLiteralsScala = appScala.findStringLiterals(infilePathScala, tokensScala)

      stringLiteralsScala.length shouldBe 67
      stringLiteralsScala.head.filename shouldBe infilePathScala
      stringLiteralsScala.head.text shouldBe "\"Scalariform \""
    }
  }

}