from __future__ import unicode_literals, print_function

import logging
from qordoba.settings import get_find_new_pattern, get_find_new_blacklist_pattern, get_qorignore
from qordoba.strategies import Extension, Shebang, Filename
from qordoba.classifier import  Classifier
from qordoba.framework import Framework
import operator

import os
import yaml
import re
from binaryornot.check import is_binary
import datetime
import operator
log = logging.getLogger('qordoba')

CUSTOM_BLACKLIST = set(get_qorignore())

STRATEGIES = [
    Extension(),
    Filename(),
    # Classifier(),
    Shebang(),
    # Modeline(),
]

FRAMEWORKS = Framework()

class FilesNotFound(Exception):
    """
    Files not found
    """

def empty(fileobj):
     if os.stat(fileobj).st_size == 0:
         return True
     else:
         False

def valid_file(fileobj):
    conditions = [
        is_binary(fileobj),
        empty(fileobj),
    ]
    if any(condition == True for condition in conditions):
        return False
    else:
        return True


def regex_file_match(regexFile, string):
    try:
        with open(regexFile, 'r') as stream:
            try:
                output = yaml.load(stream)
                result = [re.match(pattern, str(string)) for pattern in output]
                if any(result) is not None:
                    return False
                return True
            except yaml.YAMLError as exc:
                print(exc)
    except UnicodeDecodeError as exception:
        return False


def framework_detect(dir_path):
    framework = FRAMEWORKS.find_framework(dir_path)
    log.info('\nFramework Detected: {framework} at path: {path}'.format(framework=framework, path=dir_path))
    return framework


def find_new_command(curdir, config, files=()):
    pattern = get_find_new_pattern(config)
    blacklist_pattern = get_find_new_blacklist_pattern(config)
    # walk through whole path
    log.info('\n Starting reading and validating files from path .....')
    if not files:
        files = []
        for single_path in pattern:
            framework = "not found"

            if os.path.isdir(single_path):
                framework = framework_detect(single_path)
                for (path, dirnames, filenames) in os.walk(single_path):
                    files.extend(os.path.join(path, name) for name in filenames)
                files = [file for file in files if not any(path in file for path in blacklist_pattern)]
            if os.path.isfile(single_path):
                files.append(single_path)
        if not files:
            raise FilesNotFound('Files not found by pattern `{}`'.format(pattern))

        file_source_pool = dict()
    """Start applying the Strategies"""
    files_ignored = 0
    for file_path in files:
        vendor_code = regex_file_match("../resources/vendor.yml", file_path)
        documentation_code = regex_file_match("../resources/documentation.yml", file_path)
        if not valid_file(file_path):
            files_ignored += 1
            continue
        if vendor_code or documentation_code:
            files_ignored += 1
            continue
        if any(item in file_path for item in CUSTOM_BLACKLIST):
            files_ignored += 1
            continue

        # Add count of files being ignored and print a log outside the for loop
        log.info('Starting.... processing file {}'.format(file_path))
        results_file = {}
        for strategy in STRATEGIES:
            type = strategy.find_type(file_path)
            results_file[strategy.strategy_name] = type
            file_source_pool[file_path] = results_file

    file_sources = dict()
    language_distribution = dict()

    STRATEGY_WEIGHTS = {
        'extension': 0.8,
        'filename': 0.7,
        'shebang': 0.6,
        'modeline': 0.5,
        'classifier': 0.4,

    }

    #weighted source result
    for file_path, value in file_source_pool.items():
        weights = dict()
        for strategy, sources in value.items():
            if sources == []:
                continue
            for single_source in sources:
                try:
                    weights[single_source] += STRATEGY_WEIGHTS[strategy]
                except KeyError:
                    weights[single_source] = STRATEGY_WEIGHTS[strategy]
            source_max = max(weights.items(), key=operator.itemgetter(1))[0]
            file_sources[file_path] = source_max
            try:
                language_distribution[source_max] += os.stat(file_path).st_size
            except KeyError:
                language_distribution[source_max] = os.stat(file_path).st_size

    language_distribution_sorted = dict()
    for w in sorted(language_distribution, key=language_distribution.get, reverse=True):
        language_distribution_sorted[w] = language_distribution[w]

    lang_sum = sum(language_distribution.values())
    def percentage(x):
        return str(round(x*100.0/lang_sum, 1)) + "%"
    language_percentage = {k: percentage(v) for k, v in language_distribution_sorted.items()}

    timestamp = datetime.datetime.now().isoformat()
    output_file = '../output/file_sources_' + str(timestamp) + ".yml"

    with open(output_file, 'w') as outfile:
        yaml.dump("timestamp: " + timestamp, outfile, default_flow_style=False)
        yaml.dump("framework: " + framework, outfile, default_flow_style=False)
        yaml.dump(language_percentage, outfile, default_flow_style=False)
        yaml.dump(file_sources, outfile)
    log.info("\n Source Analyzer finished. Results in {output_file} \n Found total of {total} files in path, trained on {valid} valid files. Framework is {framework}. \n {language_percentage}".format(output_file=output_file, total=len(files), valid=(len(files)-files_ignored), framework=framework, language_percentage=language_percentage))