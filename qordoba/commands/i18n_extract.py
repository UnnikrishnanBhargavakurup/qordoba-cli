import i18n_base
# import Pygments

# without custom lexer

import codecs
import re
from i18n_base import get_files_in_Dir
"""
 The Extract Handler takes in a directory and extracts stringliterals file by file 
 input: Directory of the files
 output: location where the JSON report is stored

 """
import pygments
from pygments.lexers import get_lexer_by_name


def extract(curdir, input=None, output=None, lexer=None):

    files = get_files_in_Dir(input)
    for file_ in files:

        f = codecs.open(file, 'r')
        code = f.read()

        lexer = get_lexer_by_name("scala", stripall=True)

        result = lexer.get_tokens_unprocessed(code)
        print(result)

        for item in result:

            pos, token, value = item

            if str(token) == "Token.Literal.String" and not re.match(r'\n', value) and value.strip() != '':
                print(item)
