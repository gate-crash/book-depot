import shelve
import sqlite3
import uuid

conn = sqlite3.connect("bookDepot_data.db")
cursor = conn.cursor()

def database_init():
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

    except sqlite3.OperationalError as e:
        raise e

database_init()

def add_bookcase():
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

def add_shelf(bookcase=None):
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

def add_book(title, shelf=None):
    try:
        book_id = str(uuid.uuid4())
        cursor.execute(
            "INSERT INTO books (title, uuid, shelf) VALUES (?, ?, ?)",
                (title, book_id, shelf,)
        )

        conn.commit()
        print("Data saved successfully.")

    except sqlite3.IntegrityError as e:
        print("Data error.")
        print(e)
'''
These are testing lines to confirm the ability to add a book to the db

bookcase = add_bookcase()
shelf = add_shelf(bookcase)
book = add_book("Moby Dick", shelf)

cursor.execute("SELECT * FROM bookcases")
rows = cursor.fetchall()
for row in rows:
    print(row)

cursor.execute("SELECT * FROM shelves")
rows = cursor.fetchall()
for row in rows:
    print(row)

cursor.execute("SELECT * FROM books")
rows = cursor.fetchall()
for row in rows:
    print(row)    
'''

conn.close()
