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
        # Python 2
        try:
            for k, v in df_to_dict.iteritems():
                if v['startLineNumber'] == v['endLineNumber']:
                    idx = v['startLineNumber']-1
                    picked_line = file_array[idx]
                    picked_line = picked_line.replace("'" + v['text']+"'", "${" + v['generated_keys'] + "}")
                    picked_line = picked_line.replace('"' + v['text'] + '"', "${" + v['generated_keys'] + "}")
                    file_array[idx] = picked_line
                if v['startLineNumber'] < v['endLineNumber']:
                    idx_start = v['startLineNumber'] - 1
                    idx_end = v['endLineNumber'] - 1
                    picked_lines = file_array[idx_start:idx_end]
                    print('START')
                    print(picked_lines)
                    print(v['startLineNumber'], v['endLineNumber'])


        # Python 3
        except AttributeError:
            for k, v in df_to_dict.items():

                if v['startLineNumber'] == v['endLineNumber']:
                    idx = v['startLineNumber']-1
                    picked_line = file_array[idx]
                    picked_line = picked_line.replace("'" + v['text']+"'", "${" + v['generated_keys'] + "}")
                    picked_line = picked_line.replace('"' + v['text'] + '"', "${" + v['generated_keys'] + "}")
                    file_array[idx] = picked_line

                if v['startLineNumber'] < v['endLineNumber']:
                    idx_start = v['startLineNumber'] - 1
                    idx_end = v['endLineNumber'] - 1
                    picked_lines = file_array[idx_start:idx_end]
                    joined_lines = '\n'.join(picked_lines)
                    print('START')
                    print(joined_lines)
                    print(picked_lines)
                    print(v['startLineNumber'], v['endLineNumber'])
                    print(v['text'])
                    picked_line = picked_lines.replace("'" + v['text'] + "'", "${" + v['generated_keys'] + "}")
                    picked_line = picked_lines.replace('"' + v['text'] + '"', "${" + v['generated_keys'] + "}")
                    file_array[idx_end] = picked_line
                    for i in range(idx_start, idx_end):
                        file_array[i] = None

                return file_array



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
                print(file_array)
                new_file_array = self.replace_strings_for_keys(df_to_dict, file_array)
                new_file_array = [x for x in new_file_array if x != None]

                # remove old file, dump new
                # os.remove(project_file_path)
                project_file_path_new = directory + '/new_w_keys.html'
                Html_file = open(project_file_path_new, "w")
                Html_file.write("\n".join(new_file_array))
                Html_file.close()
                # with open(project_file_path, "w") as new_file:
                #     new_file.write("\n".join(new_file_array))


        #create localization file in output folder
