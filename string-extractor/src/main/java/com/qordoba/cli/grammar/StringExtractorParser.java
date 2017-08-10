package com.qordoba.cli.grammar;

// Generated from StringExtractor.g4 by ANTLR 4.7
import org.antlr.v4.runtime.atn.*;
import org.antlr.v4.runtime.dfa.DFA;
import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.misc.*;
import org.antlr.v4.runtime.tree.*;
import java.util.List;
import java.util.Iterator;
import java.util.ArrayList;

@SuppressWarnings({"all", "warnings", "unchecked", "unused", "cast"})
public class StringExtractorParser extends Parser {
	static { RuntimeMetaData.checkVersion("4.7", RuntimeMetaData.VERSION); }

	protected static final DFA[] _decisionToDFA;
	protected static final PredictionContextCache _sharedContextCache =
		new PredictionContextCache();
	public static final int
		DOCSTRING=1, EMPTY_STRING=2, COMMENT=3, STRING_LITERAL=4, NEWLINE=5, DOCSTRING_DELIMITER=6, 
		ANY=7;
	public static final int
		RULE_textfile = 0, RULE_line = 1, RULE_docstring = 2, RULE_stringLiteral = 3;
	public static final String[] ruleNames = {
		"textfile", "line", "docstring", "stringLiteral"
	};

	private static final String[] _LITERAL_NAMES = {
		null, null, null, null, null, null, "'\"\"\"'"
	};
	private static final String[] _SYMBOLIC_NAMES = {
		null, "DOCSTRING", "EMPTY_STRING", "COMMENT", "STRING_LITERAL", "NEWLINE", 
		"DOCSTRING_DELIMITER", "ANY"
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
	public String getGrammarFileName() { return "StringExtractor.g4"; }

	@Override
	public String[] getRuleNames() { return ruleNames; }

	@Override
	public String getSerializedATN() { return _serializedATN; }

	@Override
	public ATN getATN() { return _ATN; }

	public StringExtractorParser(TokenStream input) {
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
			if ( listener instanceof StringExtractorListener ) ((StringExtractorListener)listener).enterTextfile(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof StringExtractorListener ) ((StringExtractorListener)listener).exitTextfile(this);
		}
	}

	public final TextfileContext textfile() throws RecognitionException {
		TextfileContext _localctx = new TextfileContext(_ctx, getState());
		enterRule(_localctx, 0, RULE_textfile);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(9); 
			_errHandler.sync(this);
			_la = _input.LA(1);
			do {
				{
				{
				setState(8);
				line();
				}
				}
				setState(11); 
				_errHandler.sync(this);
				_la = _input.LA(1);
			} while ( (((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << DOCSTRING) | (1L << EMPTY_STRING) | (1L << COMMENT) | (1L << STRING_LITERAL) | (1L << NEWLINE) | (1L << ANY))) != 0) );
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
		public DocstringContext docstring() {
			return getRuleContext(DocstringContext.class,0);
		}
		public TerminalNode NEWLINE() { return getToken(StringExtractorParser.NEWLINE, 0); }
		public TerminalNode COMMENT() { return getToken(StringExtractorParser.COMMENT, 0); }
		public List<StringLiteralContext> stringLiteral() {
			return getRuleContexts(StringLiteralContext.class);
		}
		public StringLiteralContext stringLiteral(int i) {
			return getRuleContext(StringLiteralContext.class,i);
		}
		public List<TerminalNode> ANY() { return getTokens(StringExtractorParser.ANY); }
		public TerminalNode ANY(int i) {
			return getToken(StringExtractorParser.ANY, i);
		}
		public List<TerminalNode> EMPTY_STRING() { return getTokens(StringExtractorParser.EMPTY_STRING); }
		public TerminalNode EMPTY_STRING(int i) {
			return getToken(StringExtractorParser.EMPTY_STRING, i);
		}
		public LineContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_line; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof StringExtractorListener ) ((StringExtractorListener)listener).enterLine(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof StringExtractorListener ) ((StringExtractorListener)listener).exitLine(this);
		}
	}

	public final LineContext line() throws RecognitionException {
		LineContext _localctx = new LineContext(_ctx, getState());
		enterRule(_localctx, 2, RULE_line);
		int _la;
		try {
			setState(36);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,5,_ctx) ) {
			case 1:
				enterOuterAlt(_localctx, 1);
				{
				setState(13);
				docstring();
				setState(14);
				match(NEWLINE);
				}
				break;
			case 2:
				enterOuterAlt(_localctx, 2);
				{
				setState(16);
				match(COMMENT);
				setState(17);
				match(NEWLINE);
				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(21); 
				_errHandler.sync(this);
				_la = _input.LA(1);
				do {
					{
					setState(21);
					_errHandler.sync(this);
					switch (_input.LA(1)) {
					case STRING_LITERAL:
						{
						setState(18);
						stringLiteral();
						}
						break;
					case ANY:
						{
						setState(19);
						match(ANY);
						}
						break;
					case EMPTY_STRING:
						{
						setState(20);
						match(EMPTY_STRING);
						}
						break;
					default:
						throw new NoViableAltException(this);
					}
					}
					setState(23); 
					_errHandler.sync(this);
					_la = _input.LA(1);
				} while ( (((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << EMPTY_STRING) | (1L << STRING_LITERAL) | (1L << ANY))) != 0) );
				setState(25);
				match(COMMENT);
				setState(26);
				match(NEWLINE);
				}
				break;
			case 4:
				enterOuterAlt(_localctx, 4);
				{
				setState(30); 
				_errHandler.sync(this);
				_la = _input.LA(1);
				do {
					{
					setState(30);
					_errHandler.sync(this);
					switch (_input.LA(1)) {
					case STRING_LITERAL:
						{
						setState(27);
						stringLiteral();
						}
						break;
					case ANY:
						{
						setState(28);
						match(ANY);
						}
						break;
					case EMPTY_STRING:
						{
						setState(29);
						match(EMPTY_STRING);
						}
						break;
					default:
						throw new NoViableAltException(this);
					}
					}
					setState(32); 
					_errHandler.sync(this);
					_la = _input.LA(1);
				} while ( (((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << EMPTY_STRING) | (1L << STRING_LITERAL) | (1L << ANY))) != 0) );
				setState(34);
				match(NEWLINE);
				}
				break;
			case 5:
				enterOuterAlt(_localctx, 5);
				{
				setState(35);
				match(NEWLINE);
				}
				break;
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

	public static class DocstringContext extends ParserRuleContext {
		public TerminalNode DOCSTRING() { return getToken(StringExtractorParser.DOCSTRING, 0); }
		public DocstringContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_docstring; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof StringExtractorListener ) ((StringExtractorListener)listener).enterDocstring(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof StringExtractorListener ) ((StringExtractorListener)listener).exitDocstring(this);
		}
	}

	public final DocstringContext docstring() throws RecognitionException {
		DocstringContext _localctx = new DocstringContext(_ctx, getState());
		enterRule(_localctx, 4, RULE_docstring);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(38);
			match(DOCSTRING);
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

	public static class StringLiteralContext extends ParserRuleContext {
		public TerminalNode STRING_LITERAL() { return getToken(StringExtractorParser.STRING_LITERAL, 0); }
		public StringLiteralContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_stringLiteral; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof StringExtractorListener ) ((StringExtractorListener)listener).enterStringLiteral(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof StringExtractorListener ) ((StringExtractorListener)listener).exitStringLiteral(this);
		}
	}

	public final StringLiteralContext stringLiteral() throws RecognitionException {
		StringLiteralContext _localctx = new StringLiteralContext(_ctx, getState());
		enterRule(_localctx, 6, RULE_stringLiteral);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(40);
			match(STRING_LITERAL);
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
		"\3\u608b\ua72a\u8133\ub9ed\u417c\u3be7\u7786\u5964\3\t-\4\2\t\2\4\3\t"+
		"\3\4\4\t\4\4\5\t\5\3\2\6\2\f\n\2\r\2\16\2\r\3\3\3\3\3\3\3\3\3\3\3\3\3"+
		"\3\3\3\6\3\30\n\3\r\3\16\3\31\3\3\3\3\3\3\3\3\3\3\6\3!\n\3\r\3\16\3\""+
		"\3\3\3\3\5\3\'\n\3\3\4\3\4\3\5\3\5\3\5\2\2\6\2\4\6\b\2\2\2\63\2\13\3\2"+
		"\2\2\4&\3\2\2\2\6(\3\2\2\2\b*\3\2\2\2\n\f\5\4\3\2\13\n\3\2\2\2\f\r\3\2"+
		"\2\2\r\13\3\2\2\2\r\16\3\2\2\2\16\3\3\2\2\2\17\20\5\6\4\2\20\21\7\7\2"+
		"\2\21\'\3\2\2\2\22\23\7\5\2\2\23\'\7\7\2\2\24\30\5\b\5\2\25\30\7\t\2\2"+
		"\26\30\7\4\2\2\27\24\3\2\2\2\27\25\3\2\2\2\27\26\3\2\2\2\30\31\3\2\2\2"+
		"\31\27\3\2\2\2\31\32\3\2\2\2\32\33\3\2\2\2\33\34\7\5\2\2\34\'\7\7\2\2"+
		"\35!\5\b\5\2\36!\7\t\2\2\37!\7\4\2\2 \35\3\2\2\2 \36\3\2\2\2 \37\3\2\2"+
		"\2!\"\3\2\2\2\" \3\2\2\2\"#\3\2\2\2#$\3\2\2\2$\'\7\7\2\2%\'\7\7\2\2&\17"+
		"\3\2\2\2&\22\3\2\2\2&\27\3\2\2\2& \3\2\2\2&%\3\2\2\2\'\5\3\2\2\2()\7\3"+
		"\2\2)\7\3\2\2\2*+\7\6\2\2+\t\3\2\2\2\b\r\27\31 \"&";
	public static final ATN _ATN =
		new ATNDeserializer().deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
		for (int i = 0; i < _ATN.getNumberOfDecisions(); i++) {
			_decisionToDFA[i] = new DFA(_ATN.getDecisionState(i), i);
		}
	}
}