import os
import yaml
import logging
log = logging.getLogger('qordoba')


class FileNotFound(Exception):
    """
    Settings error
    """


DEFAULT_CONFIG_PATH = os.path.abspath(os.path.join(os.getcwd(), '.i18n-ml.yml'))

class Config(object):
    """
    Represents the i18n-ml config
    """
    def __init__(self, directory, report, exsisting_i18n, export_i18n, key):
        self._directory = directory
        self._report = report
        self._existing_i18n = exsisting_i18n
        self._export_i18n = export_i18n
        self._key = key
        self.config = self.load_i18n_ml_config()

    def load_i18n_ml_config(self):
        try:
            with open(DEFAULT_CONFIG_PATH, 'r') as f:
                config = yaml.safe_load(f)
                if not config or not config.get('i18n', None):
                    log.warning('Could not parse i18n config file: {}'.format(DEFAULT_CONFIG_PATH))
                    return {}
                return config['i18n']
        except FileNotFound:
            return None

    def realpath(self, dir):
        dirs = [os.path.realpath(file) for file in dir]
        return dirs


    def key(self, ext):
        if self._key:
            return self._key
        if self._key is None:
            try:
                return self.config['keys'][str(ext)]
            except KeyError:
                log.info('Please provide ket for {} file'.format(ext))
        raise FileNotFound("Please specify keys for `{}`".format(ext))

    @property
    def directory(self):
        if self._directory:
            return [os.path.realpath(self._directory)]
        if self._directory is None:
            return self.realpath(self.config['input'])
        return None

    @property
    def report(self):
        if self._report:
            return [os.path.realpath(self._report)]
        if self._report is None:
            return self.realpath(self.config['report'])
        raise FileNotFound("No report directory found")

    @property
    def exsisting_i18n(self):
        if self._existing_i18n:
            return [os.path.realpath(self._existing_i18n)]
        if self._existing_i18n is None:
            try:
                return self.realpath(self.config['localization']['existing'])
            except FileNotFound("No localization files found"):
                return None

    @property
    def export_i18n(self):
        if self._export_i18n:
            return [os.path.realpath(self._existing_i18n)]
        if self._export_i18n is None:
            return self.realpath(self.config['localization']['export'])
        raise FileNotFound("Please specify output directory")
