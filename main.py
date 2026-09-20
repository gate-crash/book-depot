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

        author_split = author.split()
        author = repo.add_author(author_split[0], author_split[1])
        print(author)

        book = DataModels.Book(title = title, author = author, isbn = isbn)
        print(book)

        bookcase = repo.add_bookcase()
        shelf = repo.add_shelf(bookcase)
        repo.add_book(title = book.title, author = book.author, shelf = shelf)

        print("Success!")
        print(repo.find_book_by_title(title))

        repo.__close__()

    # gather_book_data()

    book = DataModels.Book(title="Test", isbn="Test")
    print(book)
    clean = book.clean_dict()
    print(clean)
    test = repo.insert_data(table_name='books', data=clean)
    print(test[0])
    print(tuple(test[1]))

__main__()