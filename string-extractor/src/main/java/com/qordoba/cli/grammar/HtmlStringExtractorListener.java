// Generated from HtmlStringExtractor.g4 by ANTLR 4.7
import org.antlr.v4.runtime.tree.ParseTreeListener;

/**
 * This interface defines a complete listener for a parse tree produced by
 * {@link HtmlStringExtractorParser}.
 */
public interface HtmlStringExtractorListener extends ParseTreeListener {
	/**
	 * Enter a parse tree produced by {@link HtmlStringExtractorParser#textfile}.
	 * @param ctx the parse tree
	 */
	void enterTextfile(HtmlStringExtractorParser.TextfileContext ctx);
	/**
	 * Exit a parse tree produced by {@link HtmlStringExtractorParser#textfile}.
	 * @param ctx the parse tree
	 */
	void exitTextfile(HtmlStringExtractorParser.TextfileContext ctx);
	/**
	 * Enter a parse tree produced by {@link HtmlStringExtractorParser#line}.
	 * @param ctx the parse tree
	 */
	void enterLine(HtmlStringExtractorParser.LineContext ctx);
	/**
	 * Exit a parse tree produced by {@link HtmlStringExtractorParser#line}.
	 * @param ctx the parse tree
	 */
	void exitLine(HtmlStringExtractorParser.LineContext ctx);
	/**
	 * Enter a parse tree produced by {@link HtmlStringExtractorParser#htmltext}.
	 * @param ctx the parse tree
	 */
	void enterHtmltext(HtmlStringExtractorParser.HtmltextContext ctx);
	/**
	 * Exit a parse tree produced by {@link HtmlStringExtractorParser#htmltext}.
	 * @param ctx the parse tree
	 */
	void exitHtmltext(HtmlStringExtractorParser.HtmltextContext ctx);
}