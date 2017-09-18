
from qordoba.commands.i18n_base import BaseClass, IGNOREFILES

import logging
import pprint
from subprocess import Popen,PIPE
from qordoba.commands.find_new_converter import FindNewConverter

pp = pprint.PrettyPrinter(indent=4)
log = logging.getLogger('qordoba')

class FindNewStringClass(BaseClass):
    """
    The FindNewString class is created to find StringLiterals within a project directory (currently python, Scala)
    input: Directory of the files to be converted
    output: location where the CSV with all info should be stored

    when the stringLiterals are found, it will run through the project and
    """

    def find_new_string(self, curdir, config, run=False, directory=None, output=None, localization=False):
        log.info(u"\U0001F4E1" + " - loading data from space")
        log.info("strings from your files are exported")
        Process = Popen('../string-extractor/bin/start-container.sh %s %s' % (str(directory), str(output),), shell=True)
        print Process.communicate()

        if localization:
            converter = FindNewConverter()
            converter.main(output + '/string-literals.csv', localization, output)


