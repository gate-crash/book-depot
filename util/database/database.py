import sqlite3
import configparser

class Database:

    def __init__(self):
        config = configparser.ConfigParser()
        config.read("../config.ini")

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
                                format TEXT CHECK (length(format) <= 20),
                                fiction BOOLEAN,
                                read BOOLEAN,
                                shelved BOOLEAN,
                                possession TEXT CHECK (length(title) <= 100),
                                publishDate DATE,
                                printingDate DATE,
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

            self.conn.close()

        except sqlite3.OperationalError as e:
            raise e


# add_author(conn, first_name="Herman", last_name="Melville")
# add_bookcase(conn)
# print(get_bookcases(conn))
# add_shelf(conn, '604c43eb-f007-46f6-84b0-e4416c414945')
# print(get_shelves(conn, '604c43eb-f007-46f6-84b0-e4416c414945'))
# id = str(check_author_by_name(conn, first_name="Herman", last_name="Melville")[0])
# add_book(conn, "Moby Dick", id, shelf='604c43eb-f007-46f6-84b0-e4416c414945')
# print(check_books_by_author(conn, first_name="Herman", last_name="Melville"))

Database.database_init()