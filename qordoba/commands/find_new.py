from __future__ import unicode_literals, print_function

import logging
from qordoba.languages import get_source_language, init_language_storage
from qordoba.project import ProjectAPI
from qordoba.settings import get_push_pattern
from qordoba.sources import find_files_by_pattern

log = logging.getLogger('qordoba')

def vendored(file):
    pass


def find_new_command(curdir, config, files=() ):
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
        vendored(file)