// Generated from HtmlStringExtractor.g4 by ANTLR 4.7
package com.qordoba.cli.grammar;
import org.antlr.v4.runtime.atn.*;
import org.antlr.v4.runtime.dfa.DFA;
import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.misc.*;
import org.antlr.v4.runtime.tree.*;
import java.util.List;
import java.util.Iterator;
import java.util.ArrayList;

@SuppressWarnings({"all", "warnings", "unchecked", "unused", "cast"})
public class HtmlStringExtractorParser extends Parser {
	static { RuntimeMetaData.checkVersion("4.7", RuntimeMetaData.VERSION); }

	protected static final DFA[] _decisionToDFA;
	protected static final PredictionContextCache _sharedContextCache =
		new PredictionContextCache();
	public static final int
		NEWLINE=1, HTML_COMMENT=2, HTML_CONDITIONAL_COMMENT=3, XML_DECLARATION=4, 
		CDATA=5, DTD=6, SCRIPTLET=7, SEA_WS=8, HTML_TEXT=9, TAG_SLASH=10, TAG_NAME=11, 
		TAG_WHITESPACE=12, ATTRIBUTE=13, ANY=14;
	public static final int
		RULE_textfile = 0, RULE_line = 1, RULE_htmltext = 2;
	public static final String[] ruleNames = {
		"textfile", "line", "htmltext"
	};

	private static final String[] _LITERAL_NAMES = {
		null, null, null, null, null, null, null, null, null, null, "'/'"
	};
	private static final String[] _SYMBOLIC_NAMES = {
		null, "NEWLINE", "HTML_COMMENT", "HTML_CONDITIONAL_COMMENT", "XML_DECLARATION", 
		"CDATA", "DTD", "SCRIPTLET", "SEA_WS", "HTML_TEXT", "TAG_SLASH", "TAG_NAME", 
		"TAG_WHITESPACE", "ATTRIBUTE", "ANY"
	};
	public static final Vocabulary VOCABULARY = new VocabularyImpl(_LITERAL_NAMES, _SYMBOLIC_NAMES);

	/**
	 * @deprecated Use {@link #VOCABULARY} instead.
	 */
	@Deprecated
	public static final String[] tokenNames;
	static {
		tokenNames = new String[_SYMBOLIC_NAMES.length];
		for (int i = 0; i < tokenNames.length; i++) {
			tokenNames[i] = VOCABULARY.getLiteralName(i);
			if (tokenNames[i] == null) {
				tokenNames[i] = VOCABULARY.getSymbolicName(i);
			}

			if (tokenNames[i] == null) {
				tokenNames[i] = "<INVALID>";
			}
		}
	}

	@Override
	@Deprecated
	public String[] getTokenNames() {
		return tokenNames;
	}

	@Override

	public Vocabulary getVocabulary() {
		return VOCABULARY;
	}

	@Override
	public String getGrammarFileName() { return "HtmlStringExtractor.g4"; }

	@Override
	public String[] getRuleNames() { return ruleNames; }

	@Override
	public String getSerializedATN() { return _serializedATN; }

	@Override
	public ATN getATN() { return _ATN; }

	public HtmlStringExtractorParser(TokenStream input) {
		super(input);
		_interp = new ParserATNSimulator(this,_ATN,_decisionToDFA,_sharedContextCache);
	}
	public static class TextfileContext extends ParserRuleContext {
		public List<LineContext> line() {
			return getRuleContexts(LineContext.class);
		}
		public LineContext line(int i) {
			return getRuleContext(LineContext.class,i);
		}
		public TextfileContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_textfile; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof HtmlStringExtractorListener ) ((HtmlStringExtractorListener)listener).enterTextfile(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof HtmlStringExtractorListener ) ((HtmlStringExtractorListener)listener).exitTextfile(this);
		}
	}

	public final TextfileContext textfile() throws RecognitionException {
		TextfileContext _localctx = new TextfileContext(_ctx, getState());
		enterRule(_localctx, 0, RULE_textfile);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(7); 
			_errHandler.sync(this);
			_la = _input.LA(1);
			do {
				{
				{
				setState(6);
				line();
				}
				}
				setState(9); 
				_errHandler.sync(this);
				_la = _input.LA(1);
			} while ( _la==HTML_TEXT || _la==ANY );
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class LineContext extends ParserRuleContext {
		public HtmltextContext htmltext() {
			return getRuleContext(HtmltextContext.class,0);
		}
		public TerminalNode NEWLINE() { return getToken(HtmlStringExtractorParser.NEWLINE, 0); }
		public List<TerminalNode> ANY() { return getTokens(HtmlStringExtractorParser.ANY); }
		public TerminalNode ANY(int i) {
			return getToken(HtmlStringExtractorParser.ANY, i);
		}
		public LineContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_line; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof HtmlStringExtractorListener ) ((HtmlStringExtractorListener)listener).enterLine(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof HtmlStringExtractorListener ) ((HtmlStringExtractorListener)listener).exitLine(this);
		}
	}

	public final LineContext line() throws RecognitionException {
		LineContext _localctx = new LineContext(_ctx, getState());
		enterRule(_localctx, 2, RULE_line);
		int _la;
		try {
			setState(20);
			_errHandler.sync(this);
			switch (_input.LA(1)) {
			case HTML_TEXT:
				enterOuterAlt(_localctx, 1);
				{
				setState(11);
				htmltext();
				setState(12);
				match(NEWLINE);
				}
				break;
			case ANY:
				enterOuterAlt(_localctx, 2);
				{
				setState(15); 
				_errHandler.sync(this);
				_la = _input.LA(1);
				do {
					{
					{
					setState(14);
					match(ANY);
					}
					}
					setState(17); 
					_errHandler.sync(this);
					_la = _input.LA(1);
				} while ( _la==ANY );
				setState(19);
				match(NEWLINE);
				}
				break;
			default:
				throw new NoViableAltException(this);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class HtmltextContext extends ParserRuleContext {
		public TerminalNode HTML_TEXT() { return getToken(HtmlStringExtractorParser.HTML_TEXT, 0); }
		public HtmltextContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_htmltext; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof HtmlStringExtractorListener ) ((HtmlStringExtractorListener)listener).enterHtmltext(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof HtmlStringExtractorListener ) ((HtmlStringExtractorListener)listener).exitHtmltext(this);
		}
	}

	public final HtmltextContext htmltext() throws RecognitionException {
		HtmltextContext _localctx = new HtmltextContext(_ctx, getState());
		enterRule(_localctx, 4, RULE_htmltext);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(22);
			match(HTML_TEXT);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static final String _serializedATN =
		"\3\u608b\ua72a\u8133\ub9ed\u417c\u3be7\u7786\u5964\3\20\33\4\2\t\2\4\3"+
		"\t\3\4\4\t\4\3\2\6\2\n\n\2\r\2\16\2\13\3\3\3\3\3\3\3\3\6\3\22\n\3\r\3"+
		"\16\3\23\3\3\5\3\27\n\3\3\4\3\4\3\4\2\2\5\2\4\6\2\2\2\32\2\t\3\2\2\2\4"+
		"\26\3\2\2\2\6\30\3\2\2\2\b\n\5\4\3\2\t\b\3\2\2\2\n\13\3\2\2\2\13\t\3\2"+
		"\2\2\13\f\3\2\2\2\f\3\3\2\2\2\r\16\5\6\4\2\16\17\7\3\2\2\17\27\3\2\2\2"+
		"\20\22\7\20\2\2\21\20\3\2\2\2\22\23\3\2\2\2\23\21\3\2\2\2\23\24\3\2\2"+
		"\2\24\25\3\2\2\2\25\27\7\3\2\2\26\r\3\2\2\2\26\21\3\2\2\2\27\5\3\2\2\2"+
		"\30\31\7\13\2\2\31\7\3\2\2\2\5\13\23\26";
	public static final ATN _ATN =
		new ATNDeserializer().deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
		for (int i = 0; i < _ATN.getNumberOfDecisions(); i++) {
			_decisionToDFA[i] = new DFA(_ATN.getDecisionState(i), i);
		}
	}
}