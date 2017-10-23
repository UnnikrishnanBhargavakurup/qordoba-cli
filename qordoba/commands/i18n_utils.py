import os
import yaml
import logging
log = logging.getLogger('qordoba')

DEFAULT_CONFIG_PATH = os.path.abspath(os.path.join(os.getcwd(), '.i18n-ml.yml'))

class SettingsError(Exception):
    """
    Settings error
    """

class Config(object):
    """
    Represents the i18n-ml config
    """
    def __init__(self, directory, report, localization_input, localization_export):
        self.directory = directory
        self.report = report
        self.localization_input = localization_input
        self.localization_export = localization_export


    @classmethod
    def load_i18n_ml_config(self):
        try:
            with open(DEFAULT_CONFIG_PATH, 'r') as f:
                config = yaml.safe_load(f)
                if not config or not config.get('i18n', None):
                    log.warning('Could not parse i18n config file: {}'.format(DEFAULT_CONFIG_PATH))
                    return {}
                return config['i18n']

        except (yaml.parser.ParserError, KeyError):
            log.debug('Could not parse i18n config file: {}'.format(DEFAULT_CONFIG_PATH))
            raise SettingsError('Could not parse i18n config file: {}'.format(DEFAULT_CONFIG_PATH))
        except IOError:
            raise SettingsError('Could not open i18n config file: {}'.format(DEFAULT_CONFIG_PATH))

    @classmethod
    def get_real_path(self, path_list):
        real_paths = [os.path.realpath(k) for k in path_list]
        return real_paths

    DIRECTORY = load_i18n_ml_config)['input']
    REPORT = load_i18n_ml_config['report']
    LOCALIZATION_INPUT = load_i18n_ml_config['localization']['existing']
    LOCALIZATION_EXPORT = load_i18n_ml_config['localization']['export']

    @property
    def directory(self):
        if self.directory is None:
            return self.get_real_path(self.DIRECTORY)
        else:
            return self.get_real_path(self.directory)

    def report(self):
        if self.report is None:
            return self.get_real_path(self.REPORT)
        else:
            return self.get_real_path(self.report)

    def localization_input(self):
        if self.localization_input is None:
            return self.get_real_path(self.LOCALIZATION_INPUT)
        else:
            return self.get_real_path(self.localization_input)

    def localization_export(self):
        if self.localization_export is None:
            return self.get_real_path(self.LOCALIZATION_EXPORT)
        elif self.localization_export:
            return self.get_real_path(self.localization_export)
        else:
            raise ValueError('No config found type: {}'.format(self.text))

    def __repr__(self):
        return 'command {} and paths "{}"'.format(self.qid, self.text)
