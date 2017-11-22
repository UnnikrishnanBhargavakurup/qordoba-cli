import os

IGNOREFILES = [
    ".DS_Store",
    ".gitignore",
    ".git"
]

def get_files_in_Dir(directory):
    report = os.path.realpath(directory)
    files=list()
    for file_ in os.listdir(directory):
        if file_ in IGNOREFILES or file_.startswith('.'):
            continue
        files.append(directory + '/' + file_)
    return files