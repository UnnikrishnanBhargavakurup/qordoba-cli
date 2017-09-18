
from qordoba.commands.i18n_base import BaseClass, IGNOREFILES

import logging
import pprint
import subprocess

pp = pprint.PrettyPrinter(indent=4)
log = logging.getLogger('qordoba')

class FindNewString(BaseClass):
    """
    The FindNewString class is created to find StringLiterals within a project directory (currently python, Scala)
    input: Directory of the files to be converted
    output: location where the CSV with all info should be stored
    """
    def string_command(self, curdir, config, run=False, directory=None, output=None):
        print(directory, output)
        # subprocess.check_call(['/Users/franzi/Desktop/i18n/qordoba-cli/string-extractor/bin/start-container.sh', directory, output])
        subprocess.check_call(['/Users/franzi/Desktop/i18n/qordoba-cli/string-extractor/bin/start-container.sh'])