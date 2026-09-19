from util.database.database import Database
from util.database.repo import DatabaseRepo as DbR
import util.dataModels.DataModels as DataModels

def __main__():

    db = Database()
    db.database_init()
    repo = DbR(db.conn)

    # try:
        # database = Database()
        # database.database_init()
        # repo = DbR(database)

    # except Exception as error:
    #     print(error)

    def gather_book_data():
        print("Tell me about your book! ")
        title= input("What's its title? ")
        author = input("What's its author? ")
        isbn = input("What's its ISBN? ")

        book = DataModels.Book(title, author, isbn)
        print(book)

        bookcase = repo.add_bookcase()
        shelf = repo.add_shelf(bookcase)
        repo.add_book(book.title, book.author, shelf)

        print("Success!")
        print(repo.find_book_by_title(title))

        repo.__close__()

    gather_book_data()

__main__()