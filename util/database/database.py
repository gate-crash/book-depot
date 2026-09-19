import sqlite3
import uuid
import configparser

config = configparser.ConfigParser()
config.read("../config.ini")

database_config = config["database"]
database_name = database_config["name"]
conn = sqlite3.connect(database_name)

def database_init(conn: sqlite3.Connection  ):
    cursor = conn.cursor()

    try:
        # Need to expand and appropriately set up the tables to support but not require
        # all the fields documented in the data models
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
                            publishDate DATE,
                            printingDate DATE,
                            FOREIGN KEY (shelf) REFERENCES shelves (uuid),
                            FOREIGN KEY (author) REFERENCES authors (uuid)
                        );
                       """

        print("Table schema created.")
        cursor.executescript(table_schema)
        conn.commit()
        print("Table schema committed.")

        cursor.execute("SELECT name FROM sqlite_master WHERE type='table';")
        print(cursor.fetchall())

        conn.close()

    except sqlite3.OperationalError as e:
        raise e

# database_init(conn)

def add_bookcase(conn: sqlite3.Connection):
    cursor = conn.cursor()

    try:
        bookcase_id = str(uuid.uuid4())
        cursor.execute(
            "INSERT INTO bookcases (uuid) VALUES (?)",
            (bookcase_id,)
        )

        conn.commit()
        print("Data saved successfully.")
        return bookcase_id

    except sqlite3.IntegrityError:
        print("Data already exists, skipping.")

def get_bookcases(conn: sqlite3.Connection):
    cursor = conn.cursor()

    try:
        cursor.execute(
            "SELECT * FROM bookcases;",
        )

        conn.commit()
        return cursor.fetchall()

    except sqlite3.IntegrityError as e:
        print("Data error.")

def add_shelf(conn: sqlite3.Connection, bookcase=None):
    cursor = conn.cursor()

    try:
        shelf_id = str(uuid.uuid4())
        cursor.execute(
            "INSERT INTO shelves (uuid, bookcase) VALUES (?, ?)",
            (shelf_id , bookcase,)
        )

        conn.commit()
        print("Data saved successfully.")
        return shelf_id

    except sqlite3.IntegrityError:
        print("Data already exists, skipping.")

def get_shelves(conn: sqlite3.Connection, bookcase):
    cursor = conn.cursor()

    try:
        cursor.execute(
            "SELECT * FROM shelves WHERE bookcase = ?;",
            (bookcase,)
        )

        conn.commit()

        return cursor.fetchall()

    except sqlite3.IntegrityError as e:
        print("Data error.")

def add_author(conn: sqlite3.Connection, first_name, last_name):
    cursor = conn.cursor()

    try:
        author_id = str(uuid.uuid4())
        cursor.execute(
            "INSERT INTO authors (uuid, firstName, lastName) VALUES (?, ?, ?)",
            (author_id, first_name, last_name,)
        )

        conn.commit()

        print("Data saved successfully.")
        return author_id

    except sqlite3.IntegrityError as e:
        print("Data error.")
        print(e)

def check_author_by_name(conn: sqlite3.Connection, first_name, last_name):
    cursor = conn.cursor()

    try:
        cursor.execute(
            "SELECT * FROM authors WHERE firstName = ? AND lastName = ?;",
            (first_name, last_name,)
        )

        conn.commit()
        return cursor.fetchall()

    except sqlite3.IntegrityError as e:
        print("Data error.")
        print(e)

def add_book(conn: sqlite3.Connection, title, author, shelf=None):
    cursor = conn.cursor()

    try:
        book_id = str(uuid.uuid4())
        cursor.execute(
            "INSERT INTO books (title, uuid, author, shelf) VALUES (?, ?, ?, ?)",
                (title, book_id, author, shelf,)
        )

        conn.commit()
        print("Data saved successfully.")

    except sqlite3.IntegrityError as e:
        print("Data error.")
        print(e)

def check_books_by_author(conn: sqlite3.Connection, first_name, last_name):
    #Still working on this

    cursor = conn.cursor()

    author_search = check_author_by_name(conn, first_name, last_name)

    if author_search is not None:
        author_id = author_search[0][0]
        print(author_id)

        try:
            cursor.execute(
                "SELECT * FROM books WHERE author = ?;",
                (author_id,)
            )

            conn.commit()
            return cursor.fetchall()

        except sqlite3.IntegrityError as e:
            print("Data error.")

    else:
        print("No author found by that name.")

def check_all_books(conn: sqlite3.Connection):
    cursor = conn.cursor()

    try:
        cursor.execute(
            "SELECT * FROM books;",
        )

        conn.commit()
        return cursor.fetchall()

    except sqlite3.IntegrityError as e:
        print("Data error.")


# add_author(conn, first_name="Herman", last_name="Melville")
# add_bookcase(conn)
# print(get_bookcases(conn))
# add_shelf(conn, '604c43eb-f007-46f6-84b0-e4416c414945')
# print(get_shelves(conn, '604c43eb-f007-46f6-84b0-e4416c414945'))
# id = str(check_author_by_name(conn, first_name="Herman", last_name="Melville")[0])
# add_book(conn, "Moby Dick", id, shelf='604c43eb-f007-46f6-84b0-e4416c414945')
print(check_books_by_author(conn, first_name="Herman", last_name="Melville"))
print(check_all_books(conn))

conn.close()
