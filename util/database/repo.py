import sqlite3
import uuid
from dataclasses import asdict
from typing import Type

from util.dataModels import DataModels

class DatabaseRepo:
    
    def __init__(self, conn: sqlite3.Connection):
        self.conn = conn
        self.cursor = self.conn.cursor()

    def __close__(self):
        self.conn.commit()
        self.cursor.close()
        self.conn.close()

    def insert_data(self, table_name, data: dict):
        columns = list(data.keys())
        values = list(data.values())

        placeholders = ", ".join(["?"] * len(columns))
        column_names = ", ".join(columns)

        sql = f"INSERT INTO {table_name} ({column_names}) VALUES ({placeholders})"

        self.cursor.execute(sql, values)
        self.conn.commit()

    def delete_bookcase(self, bookcase_id):

        try:
            self.cursor.execute(
                "DELETE FROM bookcases WHERE id = ?;",
                (bookcase_id,)
            )
            self.conn.commit()

            print("Data deleted successfully.")

        except sqlite3.IntegrityError:
            print("Delete failed.")

    def fetch_all_bookcases(self):

        try:
            self.cursor.execute(
                "SELECT * FROM bookcases;",
            )

            self.conn.commit()
            data = self.cursor.fetchall()

        except sqlite3.IntegrityError as e:
            print("Data error.")

        return data

    def delete_shelf(self, shelf_id):

        try:
            self.cursor.execute(
                "DELETE FROM shelves WHERE id = ?;",
                (shelf_id,)
            )
            self.conn.commit()

            print("Data deleted successfully.")

        except sqlite3.IntegrityError:
            print("Data delete failed.")

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

        return data

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

        return data

    def delete_book(self, book_id):

        try:
            self.cursor.execute(
                    "DELETE FROM books WHERE id = ?;",
                    (book_id,)
            )

            self.conn.commit()
            print("Data deleted successfully.")

        except sqlite3.IntegrityError as e:
            print("Data error.")

    def check_books_by_author(self, first_name, last_name):
        #Still working on this
        author_search = self.check_author_by_name(first_name, last_name)

        if author_search is not None:
            #TODO: add support for multiple results - this currently assumes only one

            author_id = author_search[0][0]

            try:
                self.cursor.execute(
                    """SELECT *
                            FROM books
                            INNER JOIN authors
                            WHERE authors.id = ?;""",
                    (author_id,)
                )

                data = self.cursor.fetchall()

            except sqlite3.IntegrityError as e:
                print("Data error.")

        else:
            print("No author found by that name.")

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

        return data

    def create_possession(self, **kwargs):
        try:
            loan_id = str(uuid.uuid4())
            self.cursor.execute(
                "INSERT INTO possession (id) VALUES (?)",
                    (loan_id,)
            )

            self.conn.commit()
            print("Data saved successfully.")

        except sqlite3.IntegrityError as e:
            print("Data error.")
            print(e)
