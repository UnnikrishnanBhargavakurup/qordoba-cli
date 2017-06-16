from __future__ import unicode_literals, print_function

import logging
from qordoba.languages import get_source_language, init_language_storage
from qordoba.project import ProjectAPI
from qordoba.settings import get_push_pattern
from qordoba.sources import find_files_by_pattern
import yaml
import re


class FilesNotFound(Exception):
    """
    Files not found
    """


log = logging.getLogger('qordoba')

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

def documentation(file):
    pass


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
        if not vendored_or_documented(file):
            print("yeah")
