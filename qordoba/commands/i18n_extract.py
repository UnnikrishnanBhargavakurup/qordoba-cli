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
from pygments.lexers import get_lexer_by_name, guess_lexer, get_all_lexers, get_lexer_by_name, \
    load_lexer_from_file, get_lexer_for_filename, find_lexer_class_for_filename


def extract(curdir, input=None, output=None, lexer_custom=None):

    files = get_files_in_Dir(input)
    for file_ in files:

        f = codecs.open(file_, 'r')
        code = f.read()

        file_name = file_.split('/')[-1]

        lexer = find_lexer_class_for_filename(file_name)
        if lexer is None:
            lexer = get_lexer_for_filename(file_name)
        if lexer is None:
            lexer = get_lexer_for_filename(file_name)
        if lexer is None:
            lexer  = guess_lexer(code)

        if lexer_custom:
            lexer = get_lexer_by_name(lexer, stripall=True)
        

        result = lexer().get_tokens_unprocessed(code)
        # print(result)

        for item in result:

            pos, token, value = item

            if str(token) == "Token.Literal.String" and not re.match(r'\n', value) and value.strip() != '':
                print(item)
            if str(token) == "Token.Text" and not re.match(r'\n', value) and value.strip() != '':
                print(item)

extract('curdir', input="/Users/franzi/Workspace/artifacts_stringExtractor/directory_cloudflare", output="/Users/franzi/Workspace/artifacts_stringExtractor/directory_cloudflare")
