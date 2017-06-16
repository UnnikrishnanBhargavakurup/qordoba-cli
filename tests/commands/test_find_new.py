import pytest
from mock import MagicMock

# import qordoba.commands.find_new

@pytest.fixture
def mock_api(monkeypatch):
    api_mock = MagicMock()
    monkeypatch.setattr('qordoba.commands.push.ProjectAPI', api_mock)
    return api_mock.return_value
