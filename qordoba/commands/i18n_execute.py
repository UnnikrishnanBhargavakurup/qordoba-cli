from i18n_base import get_files_in_dir_with_subdirs, ignore_files, iterate_items, unicode_error

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

def transform_keys(key, key_format):

        key_value = key.strip()
        if key_format is not None:
            key = key_format.replace('KEY', key_value)
        else:
            key = key_value

        return key

def final_replace(key, picked_line, stringliteral, key_format):
	# 
    key = transform_keys(key, key_format)
    print(key)
    picked_line_1 = picked_line.replace("'" + unicode_error(stringliteral) + "'", unicode_error(key))
    picked_line_2 = picked_line_1.replace('"' + unicode_error(stringliteral) + '"', unicode_error(key))
    picked_line_3 = picked_line_2.replace('%{' + unicode_error(stringliteral) + '}', unicode_error(key)) #ruby specific %{}
    picked_line_4 = picked_line_3.replace(unicode_error(stringliteral), unicode_error(key))
    return picked_line_4

def replace_strings_for_keys(singel_file_stringliterals, old_file_all_lines_into_dict, key_format):
        # file is list of strings. replaces strings in list

        for i in range(len(singel_file_stringliterals.index)):
        	stringliteral = singel_file_stringliterals[i]["value"]
        	idx_start = singel_file_stringliterals[i]["start_line"]
        	idx_end = singel_file_stringliterals[i]["end_line"]
        	print("idx_start {}".format(idx_start))
        	print("idx_end {}".format(idx_end))
        	print("old line: {}".format(old_file_all_lines_into_dict[idx_start]))
        	# print("stringliteral {}".format((stringliteral)))
        	#getting existing_key and generated key
        	existing_key = singel_file_stringliterals[i].get("existing_key", None) 
        	if existing_key:
        		existing_key = existing_key["key"]
        	generated_key = singel_file_stringliterals[i]["generated_key"]["key"]

        	print(singel_file_stringliterals[i]["generated_key"])
        	if idx_start == idx_end:
				picked_line = old_file_all_lines_into_dict[idx_start]
				print("Line: {}".format(old_file_all_lines_into_dict[idx_start]))
                # replaces with html keys. "STRING" -->  ${KEY}
                try:
                	if existing_key is None:
                		replaced_line = final_replace(generated_key, picked_line, stringliteral, key_format)
                	else:
                		replaced_line = final_replace(existing_key, picked_line, stringliteral, key_format)
                	old_file_all_lines_into_dict[idx_start] = replaced_line
                except KeyError:
                	continue
            	print("new line: {}".format(old_file_all_lines_into_dict[idx_start]))

        	# multi-line replacement
        	if idx_start < idx_end:
        		picked_lines = list()
        		for i in range(idx_start, idx_end):
        			picked_lines.append(old_file_all_lines_into_dict[i])
        		joined_lines = '\n'.join(picked_lines)
        		try:
        			if existing_key is None:
        				replaced_line = final_replace(generated_key, joined_lines, stringliteral, key_format)
        			else:
        				replaced_line = final_replace(existing_key, joined_lines, stringliteral, key_format)
        			old_file_all_lines_into_dict[idx_start] = replaced_line
        		except KeyError:
        			continue
        		print("new line: {}".format(old_file_all_lines_into_dict[idx_start]))
        		# adding to the lost indexes none, so df is not fucked up for later
        		for i in range(idx_start, idx_end):
        			old_file_all_lines_into_dict[i] = None
        file_array_list = list()
        for i in range(len(old_file_all_lines_into_dict)):
        	idx = i + 1
        	file_array_list.append(old_file_all_lines_into_dict[idx])
        return file_array_list

def execute(curdir, input_dir=None, report_dir=None, key_format=None):
		"""
		Input is the input-directory and qordoba reports. 
		Output is a replaced input directory - stringliterals for keys - plus a i18n JSON file which contains the new keys
		"""
		reports = get_files_in_dir_with_subdirs(report_dir)
		reports = ignore_files(reports)

		for report in reports:
			
			df = pd.read_json(report)
			#files_in_report are the files where stringliterals have been extracted
			files_paths_in_report = get_files_in_report(report)
			for single_file_path in files_paths_in_report:

				log.info("Reading old file `{}`.".format(single_file_path))
				old_file_all_lines_into_dict = get_filerows_as_list(single_file_path)
				singel_file_stringliterals = (df[single_file_path])

                # checking if file is empty
                try:
                    if len(old_file_all_lines_into_dict) == 0:
                    	print('File {} is empty'.format(single_file_path))
                    	pass
                except TypeError:
                    print('File {} is empty'.format(single_file_path))
                    pass

                new_file_linedict = replace_strings_for_keys(singel_file_stringliterals, old_file_all_lines_into_dict, key_format)
                import sys
                sys.exit()
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
