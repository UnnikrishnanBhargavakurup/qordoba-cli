import os

import pytest
from qordoba.strategies import Extension, Shebang

@pytest.fixture
def valid_extension():
    filename = 'this.is.a.json'
    assert Extension.find(filename) == "JSON"