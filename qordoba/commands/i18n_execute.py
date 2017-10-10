from qordoba.commands.i18n_base import BaseClass

class i18nExecutionClass(BaseClass):

    def execute(self, report, directory, output):
        print(report, directory, output)