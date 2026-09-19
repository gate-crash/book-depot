import sqlite3
import uuid

class DatabaseRepo:
    
    def __init__(self, conn: sqlite3.Connection):
        self.conn = conn
        self.cursor = self.conn.cursor()
    
    def add_bookcase(self):

        try:
            bookcase_id = str(uuid.uuid4())
            self.cursor.execute(
                "INSERT INTO bookcases (uuid) VALUES (?)",
                (bookcase_id,)
            )

            self.conn.commit()
            print("Data saved successfully.")

        except sqlite3.IntegrityError:
            print("Data already exists, skipping.")

        self.conn.close()
        return bookcase_id

    def delete_bookcase(self, bookcase_id):

        try:
            self.cursor.execute(
                "DELETE FROM bookcases WHERE uuid = ?;",
                (bookcase_id,)
            )
            self.conn.commit()

            print("Data deleted successfully.")

        except sqlite3.IntegrityError:
            print("Delete failed.")

        self.conn.close()

    def fetch_all_bookcases(self):

        try:
            self.cursor.execute(
                "SELECT * FROM bookcases;",
            )

            self.conn.commit()
            data = self.cursor.fetchall()

        except sqlite3.IntegrityError as e:
            print("Data error.")

        self.conn.close()
        return data

    def add_shelf(self, bookcase=None):

        try:
            shelf_id = str(uuid.uuid4())
            self.cursor.execute(
                "INSERT INTO shelves (uuid, bookcase) VALUES (?, ?)",
                (shelf_id , bookcase,)
            )

            self.conn.commit()
            print("Data saved successfully.")

        except sqlite3.IntegrityError:
            print("Data already exists, skipping.")

        self.conn.close()
        return shelf_id

    def delete_shelf(self, shelf_id):

        try:
            self.cursor.execute(
                "DELETE FROM shelves WHERE uuid = ?;",
                (shelf_id,)
            )
            self.conn.commit()

            print("Data deleted successfully.")

        except sqlite3.IntegrityError:
            print("Data delete failed.")

        self.conn.close()

    def get_shelves(self, bookcase):

        try:
            self.cursor.execute(
                "SELECT * FROM shelves WHERE bookcase = ?;",
                (bookcase,)
            )

            self.conn.commit()

            data = self.cursor.fetchall()

        except sqlite3.IntegrityError as e:
            print("Data error.")

        self.conn.close()
        return data

    def add_author(self, first_name, last_name):

        try:
            author_id = str(uuid.uuid4())
            self.cursor.execute(
                "INSERT INTO authors (uuid, firstName, lastName) VALUES (?, ?, ?)",
                (author_id, first_name, last_name,)
            )

            self.conn.commit()

            print("Data saved successfully.")

        except sqlite3.IntegrityError as e:
            print("Data error.")
            print(e)

        self.conn.close()
        return author_id

    def check_author_by_name(self, first_name, last_name):

        try:
            self.cursor.execute(
                "SELECT * FROM authors WHERE firstName = ? AND lastName = ?;",
                (first_name, last_name,)
            )

            self.conn.commit()
            data = self.cursor.fetchall()

        except sqlite3.IntegrityError as e:
            print("Data error.")
            print(e)

        self.conn.close()
        return data

    def fetch_all_authors(self):

        try:
            self.cursor.execute(
                "SELECT * FROM authors;",
            )

            self.conn.commit()
            data = self.cursor.fetchall()

        except sqlite3.IntegrityError as e:
            print("Data error.")

        self.conn.close()
        return data

    def add_book(self, title, author, shelf=None):


        try:
            book_id = str(uuid.uuid4())
            self.cursor.execute(
                "INSERT INTO books (title, uuid, author, shelf) VALUES (?, ?, ?, ?)",
                    (title, book_id, author, shelf,)
            )

            self.conn.commit()
            print("Data saved successfully.")

        except sqlite3.IntegrityError as e:
            print("Data error.")
            print(e)

        self.conn.close()

    def delete_book(self, book_id):

        try:
            self.cursor.execute(
                    "DELETE FROM books WHERE uuid = ?;",
                    (book_id,)
            )

            self.conn.commit()
            print("Data deleted successfully.")

        except sqlite3.IntegrityError as e:
            print("Data error.")

        self.conn.close()

    def check_books_by_author(self, first_name, last_name):
        #Still working on this
        author_search = self.check_author_by_name(first_name, last_name)

        if author_search is not None:
            #TODO: add support for multiple results - this currently assumes only one

            author_uuid = author_search[0][0]

            try:
                self.cursor.execute(
                    """SELECT *
                            FROM books
                            INNER JOIN authors
                            WHERE authors.uuid = ?;""",
                    (author_uuid,)
                )

                data = self.cursor.fetchall()

            except sqlite3.IntegrityError as e:
                print("Data error.")

        else:
            print("No author found by that name.")

        self.conn.close()
        return data

    def fetch_all_books(self):


        try:
            self.cursor.execute(
                "SELECT * FROM books;",
            )

            self.conn.commit()
            data = self.cursor.fetchall()

        except sqlite3.IntegrityError as e:
            print("Data error.")

        self.conn.close()
        return data

    def find_book_by_title(self, title):


        try:
            self.cursor.execute(
                "SELECT * FROM books WHERE title = ?;",
                (title,)
            )

            self.conn.commit()
            data = self.cursor.fetchall()

        except sqlite3.IntegrityError as e:
            print("Data error.")

        self.conn.close()
        return data
