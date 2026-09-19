import sqlite3
import uuid

class DatabaseRepo:
    
    def __init__(self, conn: sqlite3.Connection):
        self.conn = conn
    
    def add_bookcase(self):
        cursor = self.conn.cursor()

        try:
            bookcase_id = str(uuid.uuid4())
            cursor.execute(
                "INSERT INTO bookcases (uuid) VALUES (?)",
                (bookcase_id,)
            )

            self.conn.commit()
            print("Data saved successfully.")
            return bookcase_id

        except sqlite3.IntegrityError:
            print("Data already exists, skipping.")

        self.conn.close()

    def delete_bookcase(self, bookcase_id):
        cursor = self.conn.cursor()

        try:
            cursor.execute(
                "DELETE FROM bookcases WHERE uuid = ?;",
                (bookcase_id,)
            )
            self.conn.commit()

            print("Data deleted successfully.")

        except sqlite3.IntegrityError:
            print("Delete failed.")

        self.conn.close()

    def get_all_bookcases(self):
        cursor = self.conn.cursor()

        try:
            cursor.execute(
                "SELECT * FROM bookcases;",
            )

            self.conn.commit()
            return cursor.fetchall()

        except sqlite3.IntegrityError as e:
            print("Data error.")

        self.conn.close()

    def add_shelf(self, bookcase=None):
        cursor = self.conn.cursor()

        try:
            shelf_id = str(uuid.uuid4())
            cursor.execute(
                "INSERT INTO shelves (uuid, bookcase) VALUES (?, ?)",
                (shelf_id , bookcase,)
            )

            self.conn.commit()
            print("Data saved successfully.")
            return shelf_id

        except sqlite3.IntegrityError:
            print("Data already exists, skipping.")

        self.conn.close()

    def delete_shelf(self, shelf_id):
        cursor = self.conn.cursor()

        try:
            cursor.execute(
                "DELETE FROM shelves WHERE uuid = ?;",
                (shelf_id,)
            )
            self.conn.commit()

            print("Data deleted successfully.")

        except sqlite3.IntegrityError:
            print("Data delete failed.")

        self.conn.close()

    def get_shelves(self, bookcase):
        cursor = self.conn.cursor()

        try:
            cursor.execute(
                "SELECT * FROM shelves WHERE bookcase = ?;",
                (bookcase,)
            )

            self.conn.commit()

            return cursor.fetchall()

        except sqlite3.IntegrityError as e:
            print("Data error.")

        self.conn.close()

    def add_author(self, first_name, last_name):
        cursor = self.conn.cursor()

        try:
            author_id = str(uuid.uuid4())
            cursor.execute(
                "INSERT INTO authors (uuid, firstName, lastName) VALUES (?, ?, ?)",
                (author_id, first_name, last_name,)
            )

            self.conn.commit()

            print("Data saved successfully.")
            return author_id

        except sqlite3.IntegrityError as e:
            print("Data error.")
            print(e)

        self.conn.close()

    def check_author_by_name(self, first_name, last_name):
        cursor = self.conn.cursor()

        try:
            cursor.execute(
                "SELECT * FROM authors WHERE firstName = ? AND lastName = ?;",
                (first_name, last_name,)
            )

            self.conn.commit()
            return cursor.fetchall()

        except sqlite3.IntegrityError as e:
            print("Data error.")
            print(e)

        self.conn.close()

    def fetch_all_authors(self):
        cursor = self.conn.cursor()

        try:
            cursor.execute(
                "SELECT * FROM authors;",
            )

            self.conn.commit()
            return cursor.fetchall()

        except sqlite3.IntegrityError as e:
            print("Data error.")

        self.conn.close()

    def add_book(self, title, author, shelf=None):
        cursor = self.conn.cursor()

        try:
            book_id = str(uuid.uuid4())
            cursor.execute(
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
        cursor = self.conn.cursor()
        try:
            cursor.execute(
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

        cursor = self.conn.cursor()

        author_search = self.check_author_by_name(first_name, last_name)

        if author_search is not None:
            #TODO: add support for multiple results - this currently assumes only one

            author_uuid = author_search[0][0]

            try:
                cursor.execute(
                    """SELECT *
                            FROM books
                            INNER JOIN authors
                            WHERE authors.uuid = ?;""",
                    (author_uuid,)
                )

                return cursor.fetchall()

            except sqlite3.IntegrityError as e:
                print("Data error.")

        else:
            print("No author found by that name.")

        self.conn.close()

    def fetch_all_books(self):
        cursor = self.conn.cursor()

        try:
            cursor.execute(
                "SELECT * FROM books;",
            )

            self.conn.commit()
            return cursor.fetchall()

        except sqlite3.IntegrityError as e:
            print("Data error.")

        self.conn.close()