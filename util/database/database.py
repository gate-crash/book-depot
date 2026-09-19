import sqlite3
from configparser import ConfigParser
import os


class Database:

    def __init__(self):

        config = ConfigParser()

        # get the path to config.ini
        config_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), '../config.ini')

        config.read(config_path)

        config.read(config_path)

        self.database_config = config["database"]
        self.database_name = self.database_config["name"]
        self.conn = sqlite3.connect(self.database_name)

    def database_init(self):

        cursor = self.conn.cursor()

        try:
            table_schema = """
                            CREATE TABLE IF NOT EXISTS bookcases (
                                uuid TEXT PRIMARY KEY,
                                number INTEGER,
                                name TEXT,
                                sortingMethod TEXT,
                                genre TEXT
                            );
                            CREATE TABLE IF NOT EXISTS shelves (
                                uuid TEXT PRIMARY KEY,
                                bookcase TEXT NOT NULL,
                                number INTEGER,
                                sortingMethod TEXT,
                                genre TEXT,
                                FOREIGN KEY (bookcase) REFERENCES bookcases (uuid)
                            );
                            CREATE TABLE IF NOT EXISTS authors (
                                uuid TEXT PRIMARY KEY,
                                firstName TEXT NOT NULL,
                                lastName TEXT
                            );
                            CREATE TABLE IF NOT EXISTS books (
                                uuid TEXT PRIMARY KEY,
                                title TEXT NOT NULL CHECK (length(title) <= 100),
                                shelf TEXT NOT NULL,
                                author TEXT,
                                isbn TEXT CHECK (length(isbn) <= 13),
                                issn TEXT CHECK (length(issn) <= 8),
                                genre TEXT CHECK (length(genre) <= 20),
                                series TEXT CHECK (length(series) <= 20),
                                volumeNumber INTEGER,
                                language TEXT CHECK (length(language) <= 20),
                                edition INTEGER,
                                format TEXT CHECK (length(format) <= 20),
                                fiction BOOLEAN,
                                read BOOLEAN,
                                shelved BOOLEAN,
                                possession TEXT CHECK (length(title) <= 100),
                                publishDate DATE,
                                printingDate DATE,
                                description TEXT CHECK (length(title) <= 500),
                                notes TEXT CHECK (length(title) <= 500),
                                FOREIGN KEY (shelf) REFERENCES shelves (uuid),
                                FOREIGN KEY (author) REFERENCES authors (uuid)
                            );
                           """

            print("Table schema created.")
            cursor.executescript(table_schema)
            self.conn.commit()
            print("Table schema committed.")

            cursor.execute("SELECT name FROM sqlite_master WHERE type='table';")
            print(cursor.fetchall())

            # self.conn.close()

        except sqlite3.OperationalError as e:
            raise e