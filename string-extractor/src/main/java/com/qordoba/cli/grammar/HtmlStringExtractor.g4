grammar HtmlStringExtractor;

textfile: line+;

// Split stringLiterals from the rest of the line
line
    : htmltext NEWLINE
    ;

htmltext: HTML_TEXT;

HTML_TEXT
    : ~'<'+
    ;

NEWLINE
    : '\r'? '\n'
    ;