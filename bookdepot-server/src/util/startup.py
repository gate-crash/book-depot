from dataModels import DataModels, Descriptors

class Startup:

    def __init__(self, repo):
        self.repo = repo

    def set_up_unshelved(self):
        unshelved_case = DataModels.Bookcase(
            number=0,
            case_name="Unshelved",
            sorting_method=Descriptors.SortingMethod.manual.value,
            genre=Descriptors.Genre.miscellaneous.value,
            sequence_ordinal=0
        ).clean_dict()
        self.repo.insert_data('bookcases', unshelved_case)

        unshelved_shelf = DataModels.Shelf(
            number=0,
            bookcase=unshelved_case['id'],
            sorting_method=Descriptors.SortingMethod.manual.value,
            genre=Descriptors.Genre.miscellaneous.value,
            sequence_ordinal=0
        ).clean_dict()
        self.repo.insert_data('shelves', unshelved_shelf)

        self.repo.conn.commit()
