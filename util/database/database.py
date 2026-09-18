import shelve
import sqlite3
import uuid

conn = sqlite3.connect("bookDepot_data.db")
cursor = conn.cursor()

def database_init():
    try:
        table_schema = """
                        CREATE TABLE IF NOT EXISTS bookcases (
                            uuid TEXT PRIMARY KEY
                        );
                        CREATE TABLE IF NOT EXISTS shelves (
                            uuid TEXT PRIMARY KEY,
                            bookcase TEXT NOT NULL,
                            FOREIGN KEY (bookcase) REFERENCES bookcases (uuid)
                        );
                        CREATE TABLE IF NOT EXISTS books (
                            uuid TEXT PRIMARY KEY,
                            title TEXT NOT NULL,
                            shelf TEXT NOT NULL,
                            FOREIGN KEY (shelf) REFERENCES shelves (uuid)
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

conn.close()
