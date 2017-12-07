<<<<<<< HEAD
import pytest

@pytest.fixture
def test_documentation_file():
    filename = './documentation/test.yml'
    assert vendored_or_documented(filename) == True


def test_valid_file():
    filename = '.test.yml'
    assert vendored_or_documented(filename) == False

=======
>>>>>>> origin

