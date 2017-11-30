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
	"""
	takes the report path and gives back its input files """
	json_report = open(report_path).read()
	data = json.loads(json_report)
	return data.keys()

def get_filerows_as_list(file_path):
    # loads file into dict. Every line is an index and holds the sting as a value. Starting with line 1
    file_dict = {}
    count= 1
    try:
        with open(file_path, "r") as file:
            for line in file:
                file_dict[count] = line.rstrip()
                count += 1
        
        return file_dict
    
    except IOError:
        print("File '{}' does not exist.".format(file_path))
        pass

    return file_dict

def transform_keys(self, key, key_format):

        key_value = key.strip()
        if key_format is not None:
            key = key_format.replace('KEY', key_value)
        else:
            key = key_value

        return key

def final_replace(key_type, picked_line, v, key_format):

    key = self.transform_keys(v[key_type], key_format)
    picked_line_1 = picked_line.replace("'" + v['text'].strip() + "'", key)
    picked_line_2 = picked_line_1.replace('"' + v['text'].strip() + '"', key)
    picked_line_3 = picked_line_2.replace(v['text'].strip(), key)
    return picked_line_3

def replace_strings_for_keys(report_to_dict, file_dict, key):
        # file is list of strings. replaces strings in list
        if key is None:
        	key = "KEY"

        for i in range(len(report_to_dict.index)):
			print(report_to_dict[0]["value"])
			print(report_to_dict[0]["start_line"])

            idx_start = report_to_dict[0]["start_line"]
            idx_end = report_to_dict[0]["end_line"]

            if idx_start == idx_end:
                picked_line = file_dict[idx_start]
                # replaces with html keys. "STRING" -->  ${KEY}
                try:
			        if v['existing_keys'] is None:
			            replaced_line = self.final_replace('generated_keys', picked_line, v, key)
			        else:
			            replaced_line = self.final_replace('existing_keys', picked_line, v, key)
			        file_dict[idx_start] = replaced_line
			    except KeyError:
			    	continue
			    	
            # multi-line replacement
            if idx_start < idx_end:
                picked_lines = list()
                for i in range(idx_start, idx_end):
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

def execute(curdir, input_dir=None, report_dir=None, key_format=None):
		"""
		Input is the input-directory and qordoba reports. 
		Output is a replaced input directory - stringliterals for keys - plus a i18n JSON file which contains the new keys
		"""
		reports = get_files_in_dir_with_subdirs(report_dir)
		reports = ignore_files(reports)

		for report_path in reports:
			
			df = pd.read_json(report_path)
			#files_in_report are the files where stringliterals have been extracted
			files_in_report = get_files_in_report(report_path)
			for file_in_report in files_in_report:

				log.info("Reading old file `{}`.".format(file_in_report))
				old_file_linedict = get_filerows_as_list(file_in_report)
				report_filedict = (df[file_in_report])

                # checking if file is empty
                # try:
                #     if len(old_file_linedict) == 0:
                #     	print('File {} is empty'.format(file_in_report))
                #     	continue
                # except TypeError:
                #     print('File {} is empty'.format(file_in_report))
                #     continue

                new_file_linedict = replace_strings_for_keys(report_filedict, old_file_linedict, key_format)
				
				# import sys
				# sys.exit()
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
