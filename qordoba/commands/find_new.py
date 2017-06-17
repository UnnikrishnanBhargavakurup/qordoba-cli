from __future__ import unicode_literals, print_function

import logging
from qordoba.languages import get_source_language, init_language_storage
from qordoba.project import ProjectAPI
from qordoba.settings import get_push_pattern
from qordoba.sources import find_files_by_pattern
import yaml
import re
import sys
# import magic

log = logging.getLogger('qordoba')

class FilesNotFound(Exception):
    """
    Files not found
    """

def _text_characters():
    PY3 = sys.version_info[0] == 3
    int2byte = (lambda x: bytes((x,))) if PY3 else chr
    txt = (b''.join(int2byte(i) for i in range(32, 127)) + b'\n\r\t\f\b')
    return txt

def likely_binary(fileobj, blocksize=512):
    x_file = open(fileobj)
    block = x_file.read(blocksize)
    if b'\x00' in block:
        # Files with null bytes are binary
        return True
    elif not block:
        # An empty file is considered a valid text file
        return False
    # Use translate's 'deletechars' argument to efficiently remove all
    # occurrences of _text_characters from the block
    txt_characters = self._text_characters()
    nontext = block.translate(None, txt_characters)
    # if nontext is more than 30%, than file considered binary
    return float(len(nontext)) / len(block) >= 0.30

def encoding_binary(fileobj):
    blob = open(fileobj).read()
    m = magic.Magic(mime_encoding=True)
    encoding = m.from_buffer(blob)
    return encoding == 'binary'

def empty(fileobj, blocksize=512):
    y_file = open(fileobj)
    block = y_file.read(blocksize)
    if not block:
        return True


def regex_file_match(regexFile, string):
    with open(regexFile, 'r') as stream:
        try:
            output = yaml.load(stream)
            result = [re.match(pattern, str(string)) for pattern in output]
            if any(result) is not None:
                return False
            return True
        except yaml.YAMLError as exc:
            print(exc)


def vendored_or_documented(file):
    if regex_file_match("../vendor.yml", file) and regex_file_match("../documentation.yml", file):
        return True
    return False


def not_valid(fileobj):
    conditions = [
        likely_binary(fileobj),
        encoding_binary(fileobj),
        empty(fileobj),
    ]
    if any(condition == True for condition in conditions):
        print(True)
    else:
        return False


def find_new_command(curdir, config, files=()):
    api = ProjectAPI(config)
    init_language_storage(api)

    project = api.get_project()
    source_lang = get_source_language(project)

    if not files:
        pattern = get_push_pattern(config)
        files = list(find_files_by_pattern(curdir, pattern, source_lang))
        if not files:
            raise FilesNotFound('Files not found by pattern `{}`'.format(pattern))

    for file in files:
        print(not_valid(file))
        if not vendored_or_documented(file) and not_valid(file):
            print("yeah")