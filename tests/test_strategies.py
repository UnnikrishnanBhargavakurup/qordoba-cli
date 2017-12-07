import os

import pytest
<<<<<<< HEAD

@pytest.fixture
def valid_extension():
    filename = 'this.is.a.json'
=======
<<<<<<< HEAD
from qordoba.strategies import Extension, Shebang
=======
from qordoba.strategies import Extension
>>>>>>> origin

@pytest.fixture
def valid_extension():
    filename = 'this.is.a.json'
<<<<<<< HEAD
    assert Extension.find(filename) == "JSON"
=======
    assert Extension.find(filename) == "JSON"
>>>>>>> origin
>>>>>>> develop
