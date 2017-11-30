from i18n_base import get_files_in_dir_with_subdirs, ignore_files, iterate_items

import pandas as pd
import json
import logging 
log = logging.getLogger('qordoba')
"""
TO DO 
Validate report status
"""


def get_files_in_report(report_path):
	json_report = open(report_path).read()
	data = json.loads(json_report)
	return data.keys()

def get_filerows_as_list(file_path):
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

    return file_dict


def execute(curdir, input_dir=None, report_dir=None, key_format=None):
		"""
		Input input directory and reports. 
		"""
		reports = get_files_in_dir_with_subdirs(report_dir)
		reports = ignore_files(reports)

		for report_path in reports:
			
			df = pd.read_json(report_path)
			#files_in_report are the files where stringliterals have been extracted
			files_in_report = get_files_in_report(report_path)
			for file_in_report in files_in_report:

				log.info("Reading old file `{}`.".format(file_in_report))
				old_file_dict_lines = get_filerows_as_list(file_in_report)
				new_keys_for_file_in_report = (df[file_in_report])
				for i in range(len(new_keys_for_file_in_report.index)):
					print(nn[0]["value"])

                # checking if file is empty
                try:
                    if len(old_file_dict_lines) == 0:
                        print('File {} is empty'.format(file_in_report))
                        continue
                except TypeError:
                    print('File {} is empty'.format(file_in_report))
                    continue

                import sys
				sys.exit()
				
                key = self.get_key_for_filetype(config, file_in_report)
#                 new_file_dict = self.replace_strings_for_keys(report_to_dict, file_dict, key)
#                 print("old")
#                 print(file_dict)
#                 print("new")
#                 print(new_file_dict)
#                 new_file_dict_1 = [x for x in new_file_dict if x != None]

#                 # remove old file, dump new
#                 os.remove(project_file_path)
#                 Html_file = open(project_file_path, "w")
#                 if project_file_path[-4:] == 'html':
#                     ''.join(new_file_dict_1)
#                 Html_file.write("".join(new_file_dict_1))
#                 Html_file.close()

#             # create localization file in output folder
#             new_localization_file = config.export_i18n[0] + '/qordoba_localization_file.json'
#             # WTF! NEEDS REFACTURING
#             del df['filename']
#             del df['startLineNumber']
#             del df['startCharIdx']
#             del df['endLineNumber']
#             del df['endCharIdx']
#             del df['existing_localization_file']
#             json_dump = dict()
#             for index, row in df.iterrows():
#                 if row['existing_keys'] is None:
#                     json_dump[row['generated_keys']]  = row['text']
#                 else:
#                     json_dump[row['existing_keys']] = row['text']
            
#             import json
#             with open(new_localization_file, "w") as jsonFile:
#                 json.dump(json_dump, jsonFile, sort_keys=True, indent=4, separators=(',', ': '))



# python cli.py i18n-execute -i /Users/franzi/Workspace/artifacts_stringExtractor/testing/test_files -r /Users/franzi/Workspace/artifacts_stringExtractor/testing/test_report --traceback
