
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

    def find_new_string(self, curdir, run=False, directory=None, output=None, localization=False):
        log.info('\b')
        log.info( " Loading Data from Outer Space")
        log.info('\b')
        log.info("       ... "+ u"\U0001F4E1"+" ...")
        log.info('\b')
        log.info("       ... "+ u"\U0001F4E1"+" ...")
        log.info('\b')
        log.info("Strings are now being exported from your files")
        log.info('\b')

        Process = Popen('../string-extractor/bin/start-container.sh %s %s' % (str(directory), str(output),), shell=True)
        log.info(Process.communicate())

        log.info('\b')
        log.info('Extraction completed. All exported Strings can be found within the ' + u"\U0001F4C1" + ' file `string-literal.csv`')
        log.info('\b')

        if localization:
            converter = FindNewConverter()
            converter.main(output + '/string-literals.csv', localization, output)