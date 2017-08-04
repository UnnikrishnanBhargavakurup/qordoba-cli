grammar StringExtractor;

textfile: line+;

// Split stringLiterals from the rest of the line
line
    : (stringLiteral | ANY)+ NEWLINE
    | NEWLINE
    ;

stringLiteral: StringLiteral;

StringLiteral 
    : '"' StringElement+? '"'
    | '\'' StringElement+? '\''
    ;

NEWLINE
    : '\r'? '\n'
    ;

ANY : .;

// fragments

fragment StringElement
   : '\u0020' | '\u0021' | '\u0023' .. '\u007F'
   | CharEscapeSeq
   ;

fragment CharEscapeSeq: '\\' ('b' | 't' | 'n' | 'f' | 'r' | '"' | '\'' | '\\');

