import sqlite3

from src.util.database.database import Database
from src.util.database.repo import DatabaseRepo as DbR
import src.util.dataModels.DataModels as DataModels
from src.util.dataModels import Descriptors
from src.util.startup import Startup


def __main__():

    try:
        database = Database()
        if database.check():
            pass
        else:
            database.setup()
        repo = DbR(database.conn)

    except Exception as error:
        raise error

    def gather_book_data():
        print("Tell me about your book! ")
        title= input("What's its title? ")
        author = input("Who's its author? ")
        isbn = input("What's its ISBN? ")

        first_name = author.split()[0]
        last_name = author.split()[1]
        author = DataModels.Author(first_name=first_name, last_name=last_name).clean_dict()
        repo.insert_data('authors', author)
        print(author)

        bookcase = DataModels.Bookcase(number=1).clean_dict()
        repo.insert_data('bookcases', bookcase)

        shelf = DataModels.Shelf(bookcase=bookcase['id']).clean_dict()
        repo.insert_data('shelves', shelf)

        book = DataModels.Book(title=title, author=author['id'], isbn=isbn, shelf=shelf['id'])
        # print(book.clean_dict())
        repo.insert_data('books', book.clean_dict())

        print("Success!")
        print(repo.find_book_by_title(title))

        repo.__close__()

    def unshelved_check_setup():
        try:
            repo.check_unshelved()
        except:
            startup = Startup(repo)
            startup.set_up_unshelved()


    unshelved_check_setup()
    # gather_book_data()

    cases = repo.fetch_all_bookcases()
    print(cases)
    print(repo.get_shelves(cases[0][0]))

__main__()