import pytest
from src.util.dataModels.DataModels import Bookcase

class TestCleanDict:
    def test_clean_dict(self):

        bookcase = Bookcase().clean_dict()

        assert_list = ["id", "deleted"]
        assert_not_list = ["genre", "sequence_ordinal", "case_name", "sorting_method"]

        for item in assert_list:
            assert item in bookcase
            assert bookcase[item] is not None

        for item in assert_not_list:
            assert item not in bookcase

        assert len(bookcase) == len(assert_list)


if __name__ == '__main__':
    pytest.main()
