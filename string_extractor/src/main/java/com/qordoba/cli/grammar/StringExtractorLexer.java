package com.qordoba.cli.grammar;

// Generated from StringExtractor.g4 by ANTLR 4.7
import org.antlr.v4.runtime.Lexer;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.Token;
import org.antlr.v4.runtime.TokenStream;
import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.atn.*;
import org.antlr.v4.runtime.dfa.DFA;
import org.antlr.v4.runtime.misc.*;

@SuppressWarnings({"all", "warnings", "unchecked", "unused", "cast"})
public class StringExtractorLexer extends Lexer {
	static { RuntimeMetaData.checkVersion("4.7", RuntimeMetaData.VERSION); }

	protected static final DFA[] _decisionToDFA;
	protected static final PredictionContextCache _sharedContextCache =
		new PredictionContextCache();
	public static final int
		DOCSTRING=1, EMPTY_STRING=2, COMMENT=3, STRING_LITERAL=4, NEWLINE=5, DOCSTRING_DELIMITER=6, 
		ANY=7;
	public static String[] channelNames = {
		"DEFAULT_TOKEN_CHANNEL", "HIDDEN"
	};

	public static String[] modeNames = {
		"DEFAULT_MODE"
	};

	public static final String[] ruleNames = {
		"DOCSTRING", "EMPTY_STRING", "COMMENT", "STRING_LITERAL", "NEWLINE", "DOCSTRING_DELIMITER", 
		"ANY", "STRING_ELEMENT", "CHAR_ESC_SEQ"
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


	public StringExtractorLexer(CharStream input) {
		super(input);
		_interp = new LexerATNSimulator(this,_ATN,_decisionToDFA,_sharedContextCache);
	}

	@Override
	public String getGrammarFileName() { return "StringExtractor.g4"; }

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
		"\3\u608b\ua72a\u8133\ub9ed\u417c\u3be7\u7786\u5964\2\tt\b\1\4\2\t\2\4"+
		"\3\t\3\4\4\t\4\4\5\t\5\4\6\t\6\4\7\t\7\4\b\t\b\4\t\t\t\4\n\t\n\3\2\3\2"+
		"\7\2\30\n\2\f\2\16\2\33\13\2\3\2\3\2\3\2\6\2 \n\2\r\2\16\2!\3\2\3\2\7"+
		"\2&\n\2\f\2\16\2)\13\2\3\2\3\2\3\3\3\3\3\3\3\3\3\3\3\3\3\3\6\3\64\n\3"+
		"\r\3\16\3\65\3\3\3\3\3\3\3\3\3\3\3\3\3\3\3\3\3\3\6\3A\n\3\r\3\16\3B\3"+
		"\3\3\3\5\3G\n\3\3\4\3\4\7\4K\n\4\f\4\16\4N\13\4\3\5\3\5\3\5\6\5S\n\5\r"+
		"\5\16\5T\3\5\3\5\3\5\3\5\6\5[\n\5\r\5\16\5\\\3\5\5\5`\n\5\3\6\5\6c\n\6"+
		"\3\6\3\6\3\7\3\7\3\7\3\7\3\b\3\b\3\t\3\t\3\t\5\tp\n\t\3\n\3\n\3\n\5!T"+
		"\\\2\13\3\3\5\4\7\5\t\6\13\7\r\b\17\t\21\2\23\2\3\2\6\4\2$$))\4\2\f\f"+
		"\17\17\5\2\"#%(*\u0081\b\2$$))^^ddhhvv\2\u0087\2\3\3\2\2\2\2\5\3\2\2\2"+
		"\2\7\3\2\2\2\2\t\3\2\2\2\2\13\3\2\2\2\2\r\3\2\2\2\2\17\3\2\2\2\3\31\3"+
		"\2\2\2\5F\3\2\2\2\7H\3\2\2\2\t_\3\2\2\2\13b\3\2\2\2\rf\3\2\2\2\17j\3\2"+
		"\2\2\21o\3\2\2\2\23q\3\2\2\2\25\30\7\"\2\2\26\30\5\23\n\2\27\25\3\2\2"+
		"\2\27\26\3\2\2\2\30\33\3\2\2\2\31\27\3\2\2\2\31\32\3\2\2\2\32\34\3\2\2"+
		"\2\33\31\3\2\2\2\34\37\5\r\7\2\35 \5\21\t\2\36 \t\2\2\2\37\35\3\2\2\2"+
		"\37\36\3\2\2\2 !\3\2\2\2!\"\3\2\2\2!\37\3\2\2\2\"\'\3\2\2\2#&\5\23\n\2"+
		"$&\7\"\2\2%#\3\2\2\2%$\3\2\2\2&)\3\2\2\2\'%\3\2\2\2\'(\3\2\2\2(*\3\2\2"+
		"\2)\'\3\2\2\2*+\5\r\7\2+\4\3\2\2\2,-\7$\2\2-G\7$\2\2./\7$\2\2/\60\7\""+
		"\2\2\60G\7$\2\2\61\63\7$\2\2\62\64\5\23\n\2\63\62\3\2\2\2\64\65\3\2\2"+
		"\2\65\63\3\2\2\2\65\66\3\2\2\2\66\67\3\2\2\2\678\7$\2\28G\3\2\2\29:\7"+
		")\2\2:G\7)\2\2;<\7)\2\2<=\7\"\2\2=G\7)\2\2>@\7)\2\2?A\5\23\n\2@?\3\2\2"+
		"\2AB\3\2\2\2B@\3\2\2\2BC\3\2\2\2CD\3\2\2\2DE\7)\2\2EG\3\2\2\2F,\3\2\2"+
		"\2F.\3\2\2\2F\61\3\2\2\2F9\3\2\2\2F;\3\2\2\2F>\3\2\2\2G\6\3\2\2\2HL\7"+
		"%\2\2IK\n\3\2\2JI\3\2\2\2KN\3\2\2\2LJ\3\2\2\2LM\3\2\2\2M\b\3\2\2\2NL\3"+
		"\2\2\2OR\7$\2\2PS\5\21\t\2QS\7)\2\2RP\3\2\2\2RQ\3\2\2\2ST\3\2\2\2TU\3"+
		"\2\2\2TR\3\2\2\2UV\3\2\2\2V`\7$\2\2WZ\7)\2\2X[\5\21\t\2Y[\7$\2\2ZX\3\2"+
		"\2\2ZY\3\2\2\2[\\\3\2\2\2\\]\3\2\2\2\\Z\3\2\2\2]^\3\2\2\2^`\7)\2\2_O\3"+
		"\2\2\2_W\3\2\2\2`\n\3\2\2\2ac\7\17\2\2ba\3\2\2\2bc\3\2\2\2cd\3\2\2\2d"+
		"e\7\f\2\2e\f\3\2\2\2fg\7$\2\2gh\7$\2\2hi\7$\2\2i\16\3\2\2\2jk\13\2\2\2"+
		"k\20\3\2\2\2lp\t\4\2\2mp\5\23\n\2np\7\f\2\2ol\3\2\2\2om\3\2\2\2on\3\2"+
		"\2\2p\22\3\2\2\2qr\7^\2\2rs\t\5\2\2s\24\3\2\2\2\24\2\27\31\37!%\'\65B"+
		"FLRTZ\\_bo\2";
	public static final ATN _ATN =
		new ATNDeserializer().deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
		for (int i = 0; i < _ATN.getNumberOfDecisions(); i++) {
			_decisionToDFA[i] = new DFA(_ATN.getDecisionState(i), i);
		}
	}
}