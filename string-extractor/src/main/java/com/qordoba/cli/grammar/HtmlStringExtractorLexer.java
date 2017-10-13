package com.qordoba.cli.grammar;
// Generated from HtmlStringExtractor.g4 by ANTLR 4.7
import org.antlr.v4.runtime.Lexer;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.Token;
import org.antlr.v4.runtime.TokenStream;
import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.atn.*;
import org.antlr.v4.runtime.dfa.DFA;
import org.antlr.v4.runtime.misc.*;

@SuppressWarnings({"all", "warnings", "unchecked", "unused", "cast"})
public class HtmlStringExtractorLexer extends Lexer {
	static { RuntimeMetaData.checkVersion("4.7", RuntimeMetaData.VERSION); }

	protected static final DFA[] _decisionToDFA;
	protected static final PredictionContextCache _sharedContextCache =
		new PredictionContextCache();
	public static final int
		NEWLINE=1, HTML_COMMENT=2, HTML_CONDITIONAL_COMMENT=3, XML_DECLARATION=4, 
		CDATA=5, DTD=6, SCRIPTLET=7, SEA_WS=8, HTML_TEXT=9, TAG_SLASH=10, TAG_NAME=11, 
		TAG_WHITESPACE=12, ATTRIBUTE=13, ANY=14;
	public static String[] channelNames = {
		"DEFAULT_TOKEN_CHANNEL", "HIDDEN"
	};

	public static String[] modeNames = {
		"DEFAULT_MODE"
	};

	public static final String[] ruleNames = {
		"NEWLINE", "HTML_COMMENT", "HTML_CONDITIONAL_COMMENT", "XML_DECLARATION", 
		"CDATA", "DTD", "SCRIPTLET", "SEA_WS", "HTML_TEXT", "TAG_SLASH", "TAG_NAME", 
		"TAG_WHITESPACE", "HEXDIGIT", "DIGIT", "TAG_NameChar", "TAG_NameStartChar", 
		"ATTRIBUTE", "ATTCHAR", "ATTCHARS", "HEXCHARS", "DECCHARS", "DOUBLE_QUOTE_STRING", 
		"SINGLE_QUOTE_STRING", "ANY"
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


	public HtmlStringExtractorLexer(CharStream input) {
		super(input);
		_interp = new LexerATNSimulator(this,_ATN,_decisionToDFA,_sharedContextCache);
	}

	@Override
	public String getGrammarFileName() { return "HtmlStringExtractor.g4"; }

	@Override
	public String[] getRuleNames() { return ruleNames; }

	@Override
	public String getSerializedATN() { return _serializedATN; }

	@Override
	public String[] getChannelNames() { return channelNames; }

	@Override
	public String[] getModeNames() { return modeNames; }

	@Override
	public ATN getATN() { return _ATN; }

	public static final String _serializedATN =
		"\3\u608b\ua72a\u8133\ub9ed\u417c\u3be7\u7786\u5964\2\20\u00f5\b\1\4\2"+
		"\t\2\4\3\t\3\4\4\t\4\4\5\t\5\4\6\t\6\4\7\t\7\4\b\t\b\4\t\t\t\4\n\t\n\4"+
		"\13\t\13\4\f\t\f\4\r\t\r\4\16\t\16\4\17\t\17\4\20\t\20\4\21\t\21\4\22"+
		"\t\22\4\23\t\23\4\24\t\24\4\25\t\25\4\26\t\26\4\27\t\27\4\30\t\30\4\31"+
		"\t\31\3\2\5\2\65\n\2\3\2\3\2\3\3\3\3\3\3\3\3\3\3\3\3\7\3?\n\3\f\3\16\3"+
		"B\13\3\3\3\3\3\3\3\3\3\3\4\3\4\3\4\3\4\3\4\7\4M\n\4\f\4\16\4P\13\4\3\4"+
		"\3\4\3\4\3\5\3\5\3\5\3\5\3\5\3\5\3\5\7\5\\\n\5\f\5\16\5_\13\5\3\5\3\5"+
		"\3\6\3\6\3\6\3\6\3\6\3\6\3\6\3\6\3\6\3\6\3\6\7\6n\n\6\f\6\16\6q\13\6\3"+
		"\6\3\6\3\6\3\6\3\7\3\7\3\7\3\7\7\7{\n\7\f\7\16\7~\13\7\3\7\3\7\3\b\3\b"+
		"\3\b\3\b\7\b\u0086\n\b\f\b\16\b\u0089\13\b\3\b\3\b\3\b\3\b\3\b\3\b\7\b"+
		"\u0091\n\b\f\b\16\b\u0094\13\b\3\b\3\b\5\b\u0098\n\b\3\t\3\t\5\t\u009c"+
		"\n\t\3\t\6\t\u009f\n\t\r\t\16\t\u00a0\3\n\6\n\u00a4\n\n\r\n\16\n\u00a5"+
		"\3\13\3\13\3\f\3\f\7\f\u00ac\n\f\f\f\16\f\u00af\13\f\3\r\3\r\3\r\3\r\3"+
		"\16\3\16\3\17\3\17\3\20\3\20\3\20\3\20\5\20\u00bd\n\20\3\21\5\21\u00c0"+
		"\n\21\3\22\3\22\3\22\3\22\3\22\5\22\u00c7\n\22\3\23\5\23\u00ca\n\23\3"+
		"\24\6\24\u00cd\n\24\r\24\16\24\u00ce\3\24\5\24\u00d2\n\24\3\25\3\25\6"+
		"\25\u00d6\n\25\r\25\16\25\u00d7\3\26\6\26\u00db\n\26\r\26\16\26\u00dc"+
		"\3\26\5\26\u00e0\n\26\3\27\3\27\7\27\u00e4\n\27\f\27\16\27\u00e7\13\27"+
		"\3\27\3\27\3\30\3\30\7\30\u00ed\n\30\f\30\16\30\u00f0\13\30\3\30\3\30"+
		"\3\31\3\31\t@N]o|\u0087\u0092\2\32\3\3\5\4\7\5\t\6\13\7\r\b\17\t\21\n"+
		"\23\13\25\f\27\r\31\16\33\2\35\2\37\2!\2#\17%\2\'\2)\2+\2-\2/\2\61\20"+
		"\3\2\r\4\2\13\13\"\"\3\2>>\5\2\13\f\17\17\"\"\5\2\62;CHch\3\2\62;\4\2"+
		"/\60aa\5\2\u00b9\u00b9\u0302\u0371\u2041\u2042\n\2<<C\\c|\u2072\u2191"+
		"\u2c02\u2ff1\u3003\ud801\uf902\ufdd1\ufdf2\uffff\t\2%%-=??AAC\\aac|\4"+
		"\2$$>>\4\2))>>\2\u0106\2\3\3\2\2\2\2\5\3\2\2\2\2\7\3\2\2\2\2\t\3\2\2\2"+
		"\2\13\3\2\2\2\2\r\3\2\2\2\2\17\3\2\2\2\2\21\3\2\2\2\2\23\3\2\2\2\2\25"+
		"\3\2\2\2\2\27\3\2\2\2\2\31\3\2\2\2\2#\3\2\2\2\2\61\3\2\2\2\3\64\3\2\2"+
		"\2\58\3\2\2\2\7G\3\2\2\2\tT\3\2\2\2\13b\3\2\2\2\rv\3\2\2\2\17\u0097\3"+
		"\2\2\2\21\u009e\3\2\2\2\23\u00a3\3\2\2\2\25\u00a7\3\2\2\2\27\u00a9\3\2"+
		"\2\2\31\u00b0\3\2\2\2\33\u00b4\3\2\2\2\35\u00b6\3\2\2\2\37\u00bc\3\2\2"+
		"\2!\u00bf\3\2\2\2#\u00c6\3\2\2\2%\u00c9\3\2\2\2\'\u00cc\3\2\2\2)\u00d3"+
		"\3\2\2\2+\u00da\3\2\2\2-\u00e1\3\2\2\2/\u00ea\3\2\2\2\61\u00f3\3\2\2\2"+
		"\63\65\7\17\2\2\64\63\3\2\2\2\64\65\3\2\2\2\65\66\3\2\2\2\66\67\7\f\2"+
		"\2\67\4\3\2\2\289\7>\2\29:\7#\2\2:;\7/\2\2;<\7/\2\2<@\3\2\2\2=?\13\2\2"+
		"\2>=\3\2\2\2?B\3\2\2\2@A\3\2\2\2@>\3\2\2\2AC\3\2\2\2B@\3\2\2\2CD\7/\2"+
		"\2DE\7/\2\2EF\7@\2\2F\6\3\2\2\2GH\7>\2\2HI\7#\2\2IJ\7]\2\2JN\3\2\2\2K"+
		"M\13\2\2\2LK\3\2\2\2MP\3\2\2\2NO\3\2\2\2NL\3\2\2\2OQ\3\2\2\2PN\3\2\2\2"+
		"QR\7_\2\2RS\7@\2\2S\b\3\2\2\2TU\7>\2\2UV\7A\2\2VW\7z\2\2WX\7o\2\2XY\7"+
		"n\2\2Y]\3\2\2\2Z\\\13\2\2\2[Z\3\2\2\2\\_\3\2\2\2]^\3\2\2\2][\3\2\2\2^"+
		"`\3\2\2\2_]\3\2\2\2`a\7@\2\2a\n\3\2\2\2bc\7>\2\2cd\7#\2\2de\7]\2\2ef\7"+
		"E\2\2fg\7F\2\2gh\7C\2\2hi\7V\2\2ij\7C\2\2jk\7]\2\2ko\3\2\2\2ln\13\2\2"+
		"\2ml\3\2\2\2nq\3\2\2\2op\3\2\2\2om\3\2\2\2pr\3\2\2\2qo\3\2\2\2rs\7_\2"+
		"\2st\7_\2\2tu\7@\2\2u\f\3\2\2\2vw\7>\2\2wx\7#\2\2x|\3\2\2\2y{\13\2\2\2"+
		"zy\3\2\2\2{~\3\2\2\2|}\3\2\2\2|z\3\2\2\2}\177\3\2\2\2~|\3\2\2\2\177\u0080"+
		"\7@\2\2\u0080\16\3\2\2\2\u0081\u0082\7>\2\2\u0082\u0083\7A\2\2\u0083\u0087"+
		"\3\2\2\2\u0084\u0086\13\2\2\2\u0085\u0084\3\2\2\2\u0086\u0089\3\2\2\2"+
		"\u0087\u0088\3\2\2\2\u0087\u0085\3\2\2\2\u0088\u008a\3\2\2\2\u0089\u0087"+
		"\3\2\2\2\u008a\u008b\7A\2\2\u008b\u0098\7@\2\2\u008c\u008d\7>\2\2\u008d"+
		"\u008e\7\'\2\2\u008e\u0092\3\2\2\2\u008f\u0091\13\2\2\2\u0090\u008f\3"+
		"\2\2\2\u0091\u0094\3\2\2\2\u0092\u0093\3\2\2\2\u0092\u0090\3\2\2\2\u0093"+
		"\u0095\3\2\2\2\u0094\u0092\3\2\2\2\u0095\u0096\7\'\2\2\u0096\u0098\7@"+
		"\2\2\u0097\u0081\3\2\2\2\u0097\u008c\3\2\2\2\u0098\20\3\2\2\2\u0099\u009f"+
		"\t\2\2\2\u009a\u009c\7\17\2\2\u009b\u009a\3\2\2\2\u009b\u009c\3\2\2\2"+
		"\u009c\u009d\3\2\2\2\u009d\u009f\7\f\2\2\u009e\u0099\3\2\2\2\u009e\u009b"+
		"\3\2\2\2\u009f\u00a0\3\2\2\2\u00a0\u009e\3\2\2\2\u00a0\u00a1\3\2\2\2\u00a1"+
		"\22\3\2\2\2\u00a2\u00a4\n\3\2\2\u00a3\u00a2\3\2\2\2\u00a4\u00a5\3\2\2"+
		"\2\u00a5\u00a3\3\2\2\2\u00a5\u00a6\3\2\2\2\u00a6\24\3\2\2\2\u00a7\u00a8"+
		"\7\61\2\2\u00a8\26\3\2\2\2\u00a9\u00ad\5!\21\2\u00aa\u00ac\5\37\20\2\u00ab"+
		"\u00aa\3\2\2\2\u00ac\u00af\3\2\2\2\u00ad\u00ab\3\2\2\2\u00ad\u00ae\3\2"+
		"\2\2\u00ae\30\3\2\2\2\u00af\u00ad\3\2\2\2\u00b0\u00b1\t\4\2\2\u00b1\u00b2"+
		"\3\2\2\2\u00b2\u00b3\b\r\2\2\u00b3\32\3\2\2\2\u00b4\u00b5\t\5\2\2\u00b5"+
		"\34\3\2\2\2\u00b6\u00b7\t\6\2\2\u00b7\36\3\2\2\2\u00b8\u00bd\5!\21\2\u00b9"+
		"\u00bd\t\7\2\2\u00ba\u00bd\5\35\17\2\u00bb\u00bd\t\b\2\2\u00bc\u00b8\3"+
		"\2\2\2\u00bc\u00b9\3\2\2\2\u00bc\u00ba\3\2\2\2\u00bc\u00bb\3\2\2\2\u00bd"+
		" \3\2\2\2\u00be\u00c0\t\t\2\2\u00bf\u00be\3\2\2\2\u00c0\"\3\2\2\2\u00c1"+
		"\u00c7\5-\27\2\u00c2\u00c7\5/\30\2\u00c3\u00c7\5\'\24\2\u00c4\u00c7\5"+
		")\25\2\u00c5\u00c7\5+\26\2\u00c6\u00c1\3\2\2\2\u00c6\u00c2\3\2\2\2\u00c6"+
		"\u00c3\3\2\2\2\u00c6\u00c4\3\2\2\2\u00c6\u00c5\3\2\2\2\u00c7$\3\2\2\2"+
		"\u00c8\u00ca\t\n\2\2\u00c9\u00c8\3\2\2\2\u00ca&\3\2\2\2\u00cb\u00cd\5"+
		"%\23\2\u00cc\u00cb\3\2\2\2\u00cd\u00ce\3\2\2\2\u00ce\u00cc\3\2\2\2\u00ce"+
		"\u00cf\3\2\2\2\u00cf\u00d1\3\2\2\2\u00d0\u00d2\7\"\2\2\u00d1\u00d0\3\2"+
		"\2\2\u00d1\u00d2\3\2\2\2\u00d2(\3\2\2\2\u00d3\u00d5\7%\2\2\u00d4\u00d6"+
		"\t\5\2\2\u00d5\u00d4\3\2\2\2\u00d6\u00d7\3\2\2\2\u00d7\u00d5\3\2\2\2\u00d7"+
		"\u00d8\3\2\2\2\u00d8*\3\2\2\2\u00d9\u00db\t\6\2\2\u00da\u00d9\3\2\2\2"+
		"\u00db\u00dc\3\2\2\2\u00dc\u00da\3\2\2\2\u00dc\u00dd\3\2\2\2\u00dd\u00df"+
		"\3\2\2\2\u00de\u00e0\7\'\2\2\u00df\u00de\3\2\2\2\u00df\u00e0\3\2\2\2\u00e0"+
		",\3\2\2\2\u00e1\u00e5\7$\2\2\u00e2\u00e4\n\13\2\2\u00e3\u00e2\3\2\2\2"+
		"\u00e4\u00e7\3\2\2\2\u00e5\u00e3\3\2\2\2\u00e5\u00e6\3\2\2\2\u00e6\u00e8"+
		"\3\2\2\2\u00e7\u00e5\3\2\2\2\u00e8\u00e9\7$\2\2\u00e9.\3\2\2\2\u00ea\u00ee"+
		"\7)\2\2\u00eb\u00ed\n\f\2\2\u00ec\u00eb\3\2\2\2\u00ed\u00f0\3\2\2\2\u00ee"+
		"\u00ec\3\2\2\2\u00ee\u00ef\3\2\2\2\u00ef\u00f1\3\2\2\2\u00f0\u00ee\3\2"+
		"\2\2\u00f1\u00f2\7)\2\2\u00f2\60\3\2\2\2\u00f3\u00f4\13\2\2\2\u00f4\62"+
		"\3\2\2\2\34\2\64@N]o|\u0087\u0092\u0097\u009b\u009e\u00a0\u00a5\u00ad"+
		"\u00bc\u00bf\u00c6\u00c9\u00ce\u00d1\u00d7\u00dc\u00df\u00e5\u00ee\3\b"+
		"\2\2";
	public static final ATN _ATN =
		new ATNDeserializer().deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
		for (int i = 0; i < _ATN.getNumberOfDecisions(); i++) {
			_decisionToDFA[i] = new DFA(_ATN.getDecisionState(i), i);
		}
	}
}