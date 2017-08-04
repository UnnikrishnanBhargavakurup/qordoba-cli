package com.qordoba.cli

import java.io.{File, FileInputStream}

import com.qordoba.cli.grammar.{StringExtractorLexer, StringExtractorParser}
import org.antlr.v4.runtime.tree.{ParseTree, ParseTreeWalker}
import org.antlr.v4.runtime.{ANTLRInputStream, CommonTokenStream}

/**
  * Application that uses a precompiled ANTLR grammar to extract string literals from a given file
  */
object StringExtractorApp extends App {

  override def main(args: Array[String]) {

    // TODO: Add support for -f & -d
    val filename = if (args.size > 0) {
      args.head
    } else {
      println("Filename argument required")
      return
    }

    try {
      val file = new File(filename)
      val fis = new FileInputStream(file)
      val input: ANTLRInputStream = new ANTLRInputStream(fis)

      val lexer: StringExtractorLexer = new StringExtractorLexer(input)

      val tokens: CommonTokenStream = new CommonTokenStream(lexer)

      val parser: StringExtractorParser = new StringExtractorParser(tokens)

      val tree: ParseTree = parser.textfile()

      println(tree.toStringTree(parser))

      val walker: ParseTreeWalker = new ParseTreeWalker()

      // TODO: Generate an output file
      walker.walk(new StringExtractor(), tree)
    } catch {
      case e: Exception => println(s"Unable to parse ${filename}: ${e}")
    }
  }

  /*
  ANTLRInputStream input = new ANTLRFileStream(args[0]);
  14                 RLexer lexer = new RLexer(input);
  15                 CommonTokenStream tokens = new CommonTokenStream(lexer);
  16                 RParser parser = new RParser(tokens);
  17                 parser.setBuildParseTree(true);
  18                 RuleContext tree = parser.prog();
  19                 tree.inspect(parser); // show in gui
  20                 //tree.save(parser, "/tmp/R.ps"); // Generate postscript
  21                 System.out.println(tree.toStringTree(parser));
  */

}
