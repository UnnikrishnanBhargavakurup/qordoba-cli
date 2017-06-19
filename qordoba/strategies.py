from __future__ import unicode_literals, print_function

import os
import yaml

class Extension(object):
    def __init__(self):
        pass

    def reveal_extension(self, blob):
        filename, file_extension = os.path.splitext(blob)
        return file_extension

    def find_ext(self, d, tag):
        if tag in d:
            yield d[tag]
        for k, v in d.items():
            if isinstance(v, dict):
                for i in self.find_ext(v, tag):
                    yield i, k

    def find(self, blob):
        extension = self.reveal_extension(blob)
        with open("language.yml", 'r') as stream:
            try:
                data = (yaml.load(stream))
                languages = []
                for ext_key_value in self.find_ext(data, 'extensions'):
                    (ext_list, ext_key) = ext_key_value

                    for ext in ext_list:
                        if ext == extension:
                            languages.append(ext_key)
                return languages
            except yaml.YAMLError as exc:
                print(exc)


class Shebang():
    def __init__(self):
        pass

    def interpreter(self, blob):
        infile = open(blob, 'r')
        firstLine = infile.readline()
        if firstLine[:2] == '#!':
            print
            "yaaay"
        else:
            print("no shebang")


    def find(self, blob):
        self.interpreter(blob)



