import pandas as pd
import os
import logging

from qordoba.commands.i18n_base import BaseClass
from qordoba.commands.i18n_utils import Config
log = logging.getLogger('qordoba')

class ReportNotValid(Exception):
    """
    Files not found
    """

class i18nExecutionClass(BaseClass):

    def transform_keys(self, key, key_format):

        key_value = key.strip()
        if key_format is not None:
            key = key_format.replace('KEY', key_value)
        else:
            key = key_value

        return key

    def final_replace(self, key_type, picked_line, v, key_format):

        key = self.transform_keys(v[key_type], key_format)
        picked_line_1 = picked_line.replace("'" + v['text'].strip() + "'", key)
        picked_line_2 = picked_line_1.replace('"' + v['text'].strip() + '"', key)
        picked_line_3 = picked_line_2.replace(v['text'].strip(), key)
        return picked_line_3

    def replace_strings_for_keys(self, report_to_dict, file_dict, key):
        # file is list of strings. replaces strings in list
        for k, v in self.iterate_items(report_to_dict):

            idx_start = v['startLineNumber']
            idx_end = v['endLineNumber']

            if idx_start == idx_end:
                picked_line = file_dict[idx_start]
                # replaces with html keys. "STRING" -->  ${KEY}
                if v['existing_keys'] is None:
                    replaced_line = self.final_replace('generated_keys', picked_line, v, key)
                else:
                    replaced_line = self.final_replace('existing_keys', picked_line, v, key)
                file_dict[idx_start] = replaced_line

            # multi-line replacement
            if idx_start < idx_end:
                picked_lines = list()
                for i in range(idx_start, idx_end+1):
                    print((file_dict))
                    picked_lines.append(file_dict[i])
                joined_lines = '\n'.join(picked_lines)

                if v['existing_keys'] is None:
                    replaced_line = self.final_replace('generated_keys', joined_lines, v, key)
                else:
                    replaced_line = self.final_replace('existing_keys', joined_lines, v, key)

                file_dict[idx_end] = replaced_line

                # adding to the lost indexes none, so df is not fucked up for later
                for i in range(idx_start, idx_end):
                    file_dict[i] = None

        file_array_list = list()
        for i in range(len(file_dict)):
            idx = i + 1
            file_array_list.append(file_dict[idx])
        return file_array_list

    def get_filerows_as_list(self, file_path):
        # loads file into dict. Items of dict are lines in file with linenumber.
        file_dict = {}
        count= 0
        try:
            with open(file_path, "r") as file:
                for line in file:
                    count += 1
                    file_dict[count] = line.rstrip()
            return file_dict
        except IOError:
            print("File '{}' does not exist.".format(file_path))
            pass

    def get_files_in_report(self, report_path):

        df_nan = pd.read_csv(report_path)
        df = df_nan.where((pd.notnull(df_nan)), None)
        files = list()
        for index, row in df.iterrows():
            files.append(row.filename)
         # batch lines in report with same filepath, apply replace
        return set(files), df

    def get_key_for_filetype(self, config, file_in_report):

        ext = file_in_report.split('.')[-1]
        key = config.key(ext)
        return key[0]

    def execute(self, curdir, report, directory, output, key):

        config = Config(directory, report, None, output, key)
        reports = self.get_files_in_Dir(config.report[0])
        for report_path in reports:
            DataFrame = None

            if not self.validate_report(report_path, keys=True):
                log.info("The given report `{}` is not valid.".format(report_path))
                continue

            files_in_report, df = self.get_files_in_report(report_path)
            for file_in_report in files_in_report:
                log.info("Replacing strings with keys in `{}`.".format(file_in_report))

                df_filtered_for_single_file = df[df.filename == file_in_report]
                report_to_dict = df_filtered_for_single_file.T.to_dict()
                print(df)
                project_file_path = config.directory[0] + '/' + file_in_report[11:]
                file_dict = self.get_filerows_as_list(project_file_path)

                # checking if file is empty
                try:
                    if len(file_dict) == 0:
                        print('File {} is empty'.format(file_in_report))
                        continue
                except TypeError:
                    print('File {} is empty'.format(file_in_report))
                    continue

                key = self.get_key_for_filetype(config, file_in_report)
                new_file_dict = self.replace_strings_for_keys(report_to_dict, file_dict, key)
                new_file_dict_1 = [x for x in new_file_dict if x != None]

                # remove old file, dump new

                os.remove(project_file_path)
                Html_file = open(project_file_path, "w")
                if project_file_path[-4:] == 'html':
                    ''.join(new_file_dict_1)
                Html_file.write("".join(new_file_dict_1))
                Html_file.close()


            # create localization file in output folder
            new_localization_file = config.export_i18n[0] + '/qordoba_localization_file.json'
            # WTF! NEEDS REFACTURING
            del df['filename']
            del df['startLineNumber']
            del df['startCharIdx']
            del df['endLineNumber']
            del df['endCharIdx']
            del df['existing_localization_file']
            json_dump = dict()
            for index, row in df.iterrows():
                if row['existing_keys'] is None:
                    json_dump[row['generated_keys']]  = row['text']
                else:
                    json_dump[row['existing_keys']] = row['text']

            import json
            with open(new_localization_file, "w") as jsonFile:
                json.dump(json_dump, jsonFile, sort_keys=True, indent=4, separators=(',', ': '))