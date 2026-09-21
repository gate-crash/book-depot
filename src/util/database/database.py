import logging
import sqlite3
from configparser import ConfigParser
import os

class Database:

    def __init__(self):

        config = ConfigParser()

        # get the path to config.ini
        config_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), '../config.ini')

        config.read(config_path)

        self.database_config = config["database"]
        self.database_path = self.database_config["path"] + self.database_config["name"]
        self.conn = sqlite3.connect(self.database_path)

        self.tables_config = config["tables"]
        self.bookcases_table = self.tables_config["bookcases"]
        self.shelves_table = self.tables_config["shelves"]
        self.authors_table = self.tables_config["authors"]
        self.possessions_table = self.tables_config["possessions"]
        self.books_table = self.tables_config["books"]

    def setup(self):

        cursor = self.conn.cursor()

        try:
            table_schema = ("""
                            CREATE TABLE IF NOT EXISTS {bookcases} (
                                id TEXT PRIMARY KEY,
                                number INTEGER,
                                name TEXT,
                                sorting_method TEXT,
                                sequence_ordinal INCREMENT INTEGER,
                                genre TEXT
                            );
                            CREATE TABLE IF NOT EXISTS {shelves} (
                                id TEXT PRIMARY KEY,
                                bookcase TEXT NOT NULL,
                                number INTEGER,
                                sorting_method TEXT,
                                genre TEXT,
                                sequence_ordinal INCREMENT INTEGER,
                                FOREIGN KEY (bookcase) REFERENCES {bookcases} (id)
                            );
                            CREATE TABLE IF NOT EXISTS {authors} (
                                id TEXT PRIMARY KEY,
                                first_name TEXT NOT NULL,
                                last_name TEXT
                            );
                            CREATE TABLE IF NOT EXISTS {possessions} (
                                id TEXT PRIMARY KEY,
                                lend_date DATE,
                                holder TEXT CHECK (length(holder) <= 100),
                                holder_contact CHECK (length(holder_contact) <= 100)
                            );
                            CREATE TABLE IF NOT EXISTS {books} (
                                id TEXT PRIMARY KEY,
                                title TEXT NOT NULL CHECK (length(title) <= 100),
                                shelf TEXT NOT NULL,
                                author TEXT,
                                isbn TEXT CHECK (length(isbn) <= 13),
                                issn TEXT CHECK (length(issn) <= 8),
                                genre TEXT CHECK (length(genre) <= 20),
                                series TEXT CHECK (length(series) <= 20),
                                volume_number INTEGER,
                                language TEXT CHECK (length(language) <= 20),
                                edition INTEGER,
                                format TEXT CHECK (length(format) <= 20),
                                fiction BOOLEAN,
                                read BOOLEAN,
                                shelved BOOLEAN,
                                possession TEXT,
                                publish_date DATE,
                                printing_date DATE,
                                description TEXT CHECK (length(description) <= 500),
                                notes TEXT CHECK (length(notes) <= 500),
                                sequence_ordinal FLOAT,
                                FOREIGN KEY (possession) REFERENCES {possessions} (id),
                                FOREIGN KEY (shelf) REFERENCES {shelves} (id),
                                FOREIGN KEY (author) REFERENCES {authors} (id)
                            );
                           """
                            .format(
                bookcases=self.bookcases_table,
                shelves=self.shelves_table,
                authors=self.authors_table,
                possessions=self.possessions_table,
                books=self.books_table))

            logging.log(msg="Table schema created.", level=logging.DEBUG)
            cursor.executescript(table_schema)
            self.conn.commit()
            logging.log(msg="Table schema committed.", level=logging.DEBUG)

            cursor.execute("SELECT name FROM sqlite_master WHERE type='table';")
            db_validation = cursor.fetchall()
            logging.log(
                msg="Database created at {database_path}. Tables created: {db_validation}"
                .format(
                    database_path=self.database_path,
                    db_validation=db_validation
                ),
                level=logging.DEBUG)

        except sqlite3.OperationalError as e:
            raise e
    
    def close(self):
        self.conn.close()
        
    def check(self):
        cursor = self.conn.cursor()

        if os.path.isfile(self.database_path):
            try:
                cursor.execute("SELECT name FROM sqlite_master WHERE type='table';")
                print(cursor.fetchall())
                logging.log(msg="Database at {database_path} found."
                            .format(database_path=self.database_path), level=logging.DEBUG)
                return True
            except sqlite3.OperationalError as e:
                raise e

        else:
            logging.log(msg="Database at {database_path} doesn't exist."
                        .format(database_path=self.database_path), level=logging.WARN)
            return False
        