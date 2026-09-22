import pytest
from src.util.dataModels.DataModels import Bookcase

class TestCleanDict:
    def test_clean_dict(self):

        bookcase = Bookcase().clean_dict()

        length = len(bookcase)
        assert length == 1


if __name__ == '__main__':
    pytest.main()
