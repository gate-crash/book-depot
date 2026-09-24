__author__  = "Emily Thomas <thomas.ech@gmail.com>"
__status__  = "alpha"
__version__ = "0.0.1"
__date__    = "23 September 2026"


import os

from src.util.database.database import Database
from src.util.database.repo import DatabaseRepo as DbR
import src.util.dataModels.DataModels as DataModels
from src.util.dataModels import Descriptors

def __init__():
    _PROJECT_ROOT_MARKER = "requirements.txt"

    def _find_project_root(start_path, marker=_PROJECT_ROOT_MARKER):
        current = os.path.abspath(start_path)
        while True:
            if os.path.exists(os.path.join(current, marker)):
                return current
            parent = os.path.dirname(current)
            if parent == current:
                raise FileNotFoundError(
                    "Could not locate project root (missing marker file '{marker}') "
                    "starting from '{start_path}'.".format(marker=marker, start_path=start_path)
                )
            current = parent

    try:
        database = Database()

        if database.check():
            pass
        else:
            database.setup()
        repo = DbR(database.conn)


        # TODO: export this logic into its own method

        unshelved_case = DataModels.Bookcase(
            number=0,
            name="Unshelved",
            sorting_method=Descriptors.SortingMethod.manual.value,
            genre=Descriptors.Genre.miscellaneous.value,
            sequence_ordinal=0
        ).clean_dict()
        repo.insert_data('bookcases', unshelved_case )

        unshelved_shelf = DataModels.Shelf(
            number=0,
            bookcase=unshelved_case['id'],
            sorting_method=Descriptors.SortingMethod.manual.value,
            genre=Descriptors.Genre.miscellaneous.value,
            sequence_ordinal=0
        ).clean_dict()
        repo.insert_data('shelves', unshelved_shelf )

    except Exception as error:
        raise error
    