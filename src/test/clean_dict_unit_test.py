import pytest
from src.util.dataModels.DataModels import Bookcase

def test_clean_dict():

    bookcase = Bookcase().clean_dict()

    length = len(bookcase)
    assert length == 1


if __name__ == '__main__':
    pytest.main()
