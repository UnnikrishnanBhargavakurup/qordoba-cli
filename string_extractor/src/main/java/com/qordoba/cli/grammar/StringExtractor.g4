grammar StringExtractor;

textfile: line+;

// Split stringLiterals from the rest of the line
line
    : docstring NEWLINE
    | COMMENT NEWLINE
    | (stringLiteral | ANY | EMPTY_STRING)+ COMMENT NEWLINE
    | (stringLiteral | ANY | EMPTY_STRING)+ NEWLINE
    | NEWLINE
    ;

docstring: DOCSTRING;

DOCSTRING
    : (' '|CHAR_ESC_SEQ)* DOCSTRING_DELIMITER  (STRING_ELEMENT|'"'|'\'')+? (CHAR_ESC_SEQ|' ')* DOCSTRING_DELIMITER
    ;

EMPTY_STRING
    : '""'
    | '" "'
    | '"' CHAR_ESC_SEQ+ '"'
    | '\'\''
    | '\' \''
    | '\'' CHAR_ESC_SEQ+ '\''
    ;

COMMENT
    :  '#' ~( '\r' | '\n' )*
    ;

stringLiteral: STRING_LITERAL;

STRING_LITERAL 
    : '"' (STRING_ELEMENT|'\'')+? '"'
    | '\'' (STRING_ELEMENT|'"')+? '\''
    ;

NEWLINE
    : '\r'? '\n'
    ;

DOCSTRING_DELIMITER
    : '"""'
    ;

ANY : .;

// fragments

fragment STRING_ELEMENT
   : '\u0020'
   | '\u0021'
   | '\u0023' .. '\u0026'
   | '\u0028' .. '\u007F'
   | CHAR_ESC_SEQ
   | '\u000A'
   ;

fragment CHAR_ESC_SEQ: '\\' ('b' | 't' | 'f' | '"' | '\'' | '\\');

