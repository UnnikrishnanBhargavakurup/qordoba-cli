from qordoba.commands.i18n_base import BaseClass
import pandas as pd
import os


class i18nExecutionClass(BaseClass):
    '''
     CSV as dataframe
     While filename the same
         get line , end of line
         merge list components
         replace key
         append to new list
         write line by line to file, with extension

     Get file: load
     Lines to list

     '''
    def __init__(self):
        self.next = False

    def replace_strings_for_keys(self, df_to_dict, file_array):
        try:
            for k, v in df_to_dict.iteritems():
                for _, array in v.iteritems():
                    print(array)

                '''{'
                filename': '/work_dir/./folder/cloudflare-json-translation-example.json', 
                'startLineNumber': 13, 
                'startCharIdx': 30, 
                'endLineNumber': 13, 
                'endCharIdx': 33, 
                'text': '21', 
                'existing_eys': None, 
                'existing_localization_file': None, 
                'generated_keys': '21'}'''
        except AttributeError:
            for k, v in df_to_dict.items():
                print(v)
                print(v['startLineNumber'])
                # for _, array in v.items():
                #     print(type(array))



    def get_filerows_as_list(self, file_path):
        with open(file_path, "r") as ins:
            file_array = ins.read().splitlines()

            return file_array


    def execute(self, report, directory, output):
        if report[-1] == '/':
            report = report[:-1]

        reports = self.get_files_in_Dir(report)
        reports_file_path = [report + '/' + x for x in reports if x.endswith('.csv')]
        for report_path in reports_file_path:

            df_nan = pd.read_csv(report_path)
            df = df_nan.where((pd.notnull(df_nan)), None)
            files = list()
            for index, row in df.iterrows():
                files.append(row.filename)

            # split report into filesections, get file content, replace
            files_in_report = set(files)
            for file_in_report in files_in_report:
                project_file_path = directory + file_in_report[11:]
                df_single_file = df[df.filename == file_in_report]
                df_to_dict = df_single_file.T.to_dict()
                file_array = self.get_filerows_as_list(project_file_path)
                new_file = self.replace_strings_for_keys(df_to_dict, file_array)

                # remove old file, dump new
                # os.remove(file_path)
                # for item in new_file:
                #     file_path.write("%s\n" % item)

        #create localization file in output folder
