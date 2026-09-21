import sqlite3
import uuid
from configparser import ConfigParser
import os
import logging

class DatabaseRepo:
    
    def __init__(self, conn: sqlite3.Connection):
        self.conn = conn
        self.cursor = self.conn.cursor()

        config = ConfigParser()

        # get the path to config.ini
        config_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), '../config.ini')

        config.read(config_path)

        self.table_config = config["tables"]

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
                "DELETE FROM {bookcases} WHERE id = ?;"
                .format(bookcases=self.table_config["bookcases"]),
                (bookcase_id,)
            )
            self.conn.commit()

            print("Data deleted successfully.")

        except sqlite3.IntegrityError as e:
            print("Delete failed.")
            raise e

    def fetch_all_bookcases(self):

        try:
            self.cursor.execute(
                "SELECT * FROM {bookcases};"
                .format(bookcases=self.table_config["bookcases"]),
            )

            self.conn.commit()
            data = self.cursor.fetchall()

        except sqlite3.IntegrityError as e:
            print("Data error.")
            raise e

        return data

    def delete_shelf(self, shelf_id):

        try:
            self.cursor.execute(
                "DELETE FROM {shelves} WHERE id = ?;"
                .format(shelves=self.table_config["shelves"]),
                (shelf_id,)
            )
            self.conn.commit()

            print("Data deleted successfully.")

        except sqlite3.IntegrityError as e:
            print("Data delete failed.")
            raise e


    def get_shelves(self, bookcase):

        try:
            self.cursor.execute(
                "SELECT * FROM {shelves} WHERE bookcase = ?;"
                .format(shelves=self.table_config["shelves"]),
                (bookcase,)
            )

            self.conn.commit()

            data = self.cursor.fetchall()

        except sqlite3.IntegrityError as e:
            print("Data error.")
            raise e

        return data

    def check_author_by_name(self, first_name, last_name):

        try:
            self.cursor.execute(
                "SELECT * FROM {authors} WHERE firstName = ? AND lastName = ?;"
                .format(authors=self.table_config["authors"]),
                (first_name, last_name,)
            )

            self.conn.commit()
            data = self.cursor.fetchall()

        except sqlite3.IntegrityError as e:
            print("Data error.")
            raise e

        return data

    def fetch_all_authors(self):

        try:
            self.cursor.execute(
                "SELECT * FROM {authors};"
                .format(authors=self.table_config["authors"]),
            )

            self.conn.commit()
            data = self.cursor.fetchall()

        except sqlite3.IntegrityError as e:
            print("Data error.")
            raise e

        return data

    def delete_book(self, book_id):

        try:
            self.cursor.execute(
                    "DELETE FROM {books} WHERE id = ?;"
                    .format(books=self.table_config["books"]),
                    (book_id,)
            )

            self.conn.commit()
            print("Data deleted successfully.")

        except sqlite3.IntegrityError as e:
            print("Data error.")
            raise e

    def check_books_by_author(self, first_name, last_name):
        #Still working on this
        author_search = self.check_author_by_name(first_name, last_name)

        if author_search is not None:
            #TODO: add support for multiple results - this currently assumes only one

            author_id = author_search[0][0]

            try:
                self.cursor.execute(
                    """SELECT *
                            FROM {books}
                            INNER JOIN {authors}
                            WHERE authors.id = ?;"""
                    .format(books=self.table_config["books"], authors=self.table_config["authors"]),
                    (author_id,)
                )

                data = self.cursor.fetchall()

            except sqlite3.IntegrityError as e:
                print("Data error.")
                raise e

        else:
            print("No author found by that name.")

        return data

    def fetch_all_books(self):

        try:
            self.cursor.execute(
                "SELECT * FROM {books};"
                .format(books=self.table_config["books"]),
            )

            self.conn.commit()
            data = self.cursor.fetchall()

        except sqlite3.IntegrityError as e:
            print("Data error.")
            raise e

        return data

    def find_book_by_title(self, title):

        try:
            self.cursor.execute(
                "SELECT * FROM {books} WHERE title = ?;"
                .format(books=self.table_config["books"]),
                (title,)
            )

            self.conn.commit()
            data = self.cursor.fetchall()

        except sqlite3.IntegrityError as e:
            print("Data error.")
            raise e

        return data

    def create_possession(self, **kwargs):
        try:
            loan_id = str(uuid.uuid4())
            self.cursor.execute(
                "INSERT INTO {possessions} (id) VALUES (?)"
                .format(possessions=self.table_config["possessions"]),
                    (loan_id,)
            )

            self.conn.commit()
            logging.log(msg="Data for possession {loan_id} saved successfully."
                        .format(loan_id=loan_id), level=logging.DEBUG)

        except sqlite3.IntegrityError as e:
            print("Data error.")
            raise e
