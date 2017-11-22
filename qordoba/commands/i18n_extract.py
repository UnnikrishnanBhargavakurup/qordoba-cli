from i18n_base import get_files_in_Dir, save_to_jsonfile, get_root_path

import codecs
import re

import datetime
now = datetime.datetime.now()
date = now.strftime("%Y%m%d%H%M")

"""
 The Extract Handler takes in a directory and extracts stringliterals file by file
 input: Directory of the files
 output: location where the JSON report is stored


 toDo:
 bulk
 custom lexer

 """
import pygments
from pygments.lexers import get_lexer_by_name, guess_lexer, get_all_lexers, \
    load_lexer_from_file, get_lexer_for_filename, find_lexer_class_for_filename

def get_lexer(file_name, code, lexer_custom=None):
    # finding the right lexer for filename 
    lexer = find_lexer_class_for_filename(file_name)
    
    if lexer is None:
        lexer = get_lexer_for_filename(file_name)
    if lexer is None:
        lexer = guess_lexer(file_name)
    if lexer_custom: # if custom lexer is given
        lexer = get_lexer_by_name(lexer, stripall=True)

    return lexer


def extract(curdir, input=None, output=None, lexer_custom=None, bulk_report=False):

    absolute_path = get_root_path(input)
    print(absolute_path)
    files = get_files_in_Dir(input)

    if bulk_report: #if True, the report will reflect all files in the directory
        json_report = dict()
        json_report[file_] = {}

    for file_ in files:
        print(file_)

        if not bulk_report:
            json_report = {}
            json_report[file_] = {}

        f = codecs.open(file_, 'r')
        code = f.read()
        file_name = file_.split('/')[-1]

        lexer = get_lexer(file_name, code, lexer_custom=lexer_custom)
        results_generator = lexer().get_tokens_unprocessed(code)
        
        for item in results_generator: #unpacking content of generator
            pos, token, value = item
            print(1)
            #filter for stringliterals
            if str(token) in ["Token.Literal.String", "Token.Text"] and not re.match(r'\n', value) and value.strip() != '':
                print(2)
                pos, token, value = item
                value = value.strip()
                json_report[file_][value] = {"value": value, "pos": pos}

        if not bulk_report:
            print(3)
            file_path = output + '/qordoba-report-' + file_name + "-" + date +'.json'
            save_to_jsonfile(file_path, json_report)


    # creating report file for bulk
    if bulk_report:
        file_path = output + '/qordoba-bulkreport-' + date +'.json'
        save_to_jsonfile(file_path, json_report)


extract('curdir', input="/Users/franzi/Workspace/artifacts_stringExtractor/directory_cloudflare", output="/Users/franzi/Workspace/artifacts_stringExtractor/directory_cloudflare", bulk_report=False)
