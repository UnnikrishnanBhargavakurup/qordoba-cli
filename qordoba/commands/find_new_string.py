
from qordoba.commands.i18n_base import BaseClass, IGNOREFILES

import logging
import pprint
from subprocess import Popen,PIPE

pp = pprint.PrettyPrinter(indent=4)
log = logging.getLogger('qordoba')

class FindNewStringClass(BaseClass):
    """
    The FindNewString class is created to find StringLiterals within a project directory (currently python, Scala)
    input: Directory of the files to be converted
    output: location where the CSV with all info should be stored
    """
    def find_new_string(self, curdir, config, run=False, directory=None, output=None):
        print(directory, output)
        Process = Popen('../string-extractor/bin/start-container.sh %s %s' % (str(directory), str(output),), shell=True)
        print Process.communicate()
