package com.qordoba.cli.grammar;// Generated from StringExtractor.g4 by ANTLR 4.7
import org.antlr.v4.runtime.tree.ParseTreeListener;

/**
 * This interface defines a complete listener for a parse tree produced by
 * {@link StringExtractorParser}.
 */
public interface StringExtractorListener extends ParseTreeListener {
	/**
	 * Enter a parse tree produced by {@link StringExtractorParser#textfile}.
	 * @param ctx the parse tree
	 */
	void enterTextfile(StringExtractorParser.TextfileContext ctx);
	/**
	 * Exit a parse tree produced by {@link StringExtractorParser#textfile}.
	 * @param ctx the parse tree
	 */
	void exitTextfile(StringExtractorParser.TextfileContext ctx);
	/**
	 * Enter a parse tree produced by {@link StringExtractorParser#line}.
	 * @param ctx the parse tree
	 */
	void enterLine(StringExtractorParser.LineContext ctx);
	/**
	 * Exit a parse tree produced by {@link StringExtractorParser#line}.
	 * @param ctx the parse tree
	 */
	void exitLine(StringExtractorParser.LineContext ctx);
	/**
	 * Enter a parse tree produced by {@link StringExtractorParser#stringLiteral}.
	 * @param ctx the parse tree
	 */
	void enterStringLiteral(StringExtractorParser.StringLiteralContext ctx);
	/**
	 * Exit a parse tree produced by {@link StringExtractorParser#stringLiteral}.
	 * @param ctx the parse tree
	 */
	void exitStringLiteral(StringExtractorParser.StringLiteralContext ctx);
}