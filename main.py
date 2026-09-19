from util.database.database import Database
from util.database.repo import DatabaseRepo

def __main__():

    try:
        database = Database()

        Database.database_init()

    except Exception as error:
        print(error)

    return

