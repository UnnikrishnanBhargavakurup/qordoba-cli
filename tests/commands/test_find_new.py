import pytest
import yaml
import os
from qordoba.commands.find_new import FindNewClass

@pytest.fixture
def load_config():
    try:
        with open('qordoba.yml') as info:
            info_dict = yaml.load(info)
        return info_dict
    except IOError:
        print 'No `.qordoba.yml` file'

@pytest.fixture
def exec_find_new(filedirs):
    current_dir = os.path.abspath(os.getcwd())
    config = load_config()
    config['qordoba']['search']['paths'] = filedirs
    return FindNewClass().find_new_command(current_dir, config, [])

def test_samples_java():
    filedirs = ['../resources/samples/Java']
    language = "Java"
    results = exec_find_new(filedirs)

    languages = set(results.values())

    assert len(languages) == 1
    assert languages.pop() == language


