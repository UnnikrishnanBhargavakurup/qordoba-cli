import pytest

# no lexer
# pygments lexer
# qordoba lexer
# bulk
# test_capitalize.py

@pytest_fixtures:

def capital_case(x):
    return x.capitalize()

def test_capital_case():
    assert capital_case('semaphore') == 'Semaphore'