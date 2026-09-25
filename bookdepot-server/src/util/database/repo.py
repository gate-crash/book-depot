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

        logging.log(level=logging.INFO,
                    msg=f"Inserting data: {data} into table: {table_name}")

    def remove_data_by_id(self, table, id):
        ## This should only be used in the direst of scenarios.
        ## Any user scenarios should use the set_data_to_deleted() method.

        try:
            self.cursor.execute(
                "DELETE FROM {table} WHERE id = ?;"
                .format(table=table),
                (id,)
            )
            self.conn.commit()

            print("Data deleted successfully.")

        except sqlite3.IntegrityError as e:
            print("Data delete failed.")
            raise e

    def set_data_to_deleted(self, table, id):
        try:
            self.cursor.execute(
                "UPDATE {table} SET deleted = True WHERE id = ?;"
                .format(table=table),
                (id,)
            )
            self.conn.commit()

            print("Record set to deleted.")

        except sqlite3.IntegrityError as e:
            print("Data delete failed.")
            raise e

    def check_unshelved(self):

        try:
            self.cursor.execute(
                "SELECT id FROM {bookcases} WHERE case_name = ?;"
                .format(bookcases=self.table_config["bookcases"]),
                ('Unshelved',)
            )

            self.conn.commit()
            id = self.cursor.fetchall()[0]["id"]

            if id is not None:
                self.cursor.execute(
                    "SELECT * FROM {shelves} WHERE bookcase = ?;"
                    .format(shelves=self.table_config["shelves"]),
                    (id,)
                )

                self.conn.commit()
                data = self.cursor.fetchall()

                if len(data) == 1:
                    return True
                else:
                    return False

        except sqlite3.IntegrityError as e:
            logging.log(msg=f"Data error. {e}", level=logging.DEBUG)
            return False

        except IndexError as e:
            logging.log(msg=f"Data error. {e}", level=logging.DEBUG)
            return False

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

    def fetch_books_by_shelf(self, shelf: str):
        try:
            self.cursor.execute(
                "SELECT * FROM {books} WHERE shelf = ?;"
                .format(books=self.table_config["books"]),
                (shelf,)
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
            logging.log(msg=f"Data for possession {loan_id} saved successfully.",
                        level=logging.INFO)

        except sqlite3.IntegrityError as e:
            print("Data error.")
            raise e

    def fetch_all_possessions(self):

        try:
            self.cursor.execute(
                "SELECT * FROM {possessions};"
                .format(possessions=self.table_config["possessions"]),
            )

            self.conn.commit()
            data = self.cursor.fetchall()

        except sqlite3.IntegrityError as e:
            print("Data error.")
            raise e

        return data

