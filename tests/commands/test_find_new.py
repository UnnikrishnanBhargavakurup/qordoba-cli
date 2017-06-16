import pytest

from qordoba.commands.find_new import vendored_or_documented


@pytest.fixture
def test_documentation_file():
    filename = './documentation/test.yml'
    assert vendored_or_documented("../vendor.yml", filename) == True


def test_valid_file():
    filename = './documentation/test.yml'
    assert vendored_or_documented("../vendor.yml", filename) == False
