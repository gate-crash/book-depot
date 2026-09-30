import logging
import sqlite3
from configparser import ConfigParser
import os


_PROJECT_ROOT_MARKER = "requirements.txt"


def _find_project_root(start_path, marker=_PROJECT_ROOT_MARKER):
    current = os.path.abspath(start_path)
    while True:
        if os.path.exists(os.path.join(current, marker)):
            return current
        parent = os.path.dirname(current)
        if parent == current:
            raise FileNotFoundError(
                "Could not locate project root (missing marker file '{marker}') "
                "starting from '{start_path}'.".format(marker=marker, start_path=start_path)
            )
        current = parent


class Database:

    def __init__(self):

        config = ConfigParser()

        # get the path to config.ini
        config_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), '../config.ini')

        config.read(config_path)

        self.database_config = config["database"]

        project_root = os.environ.get("BOOKDEPOT_PROJECT_ROOT") or _find_project_root(
            os.path.dirname(os.path.abspath(__file__))
        )
        self.database_path = os.path.normpath(
            os.path.join(project_root,
                         self.database_config["path"],
                         self.database_config["name"])
        )
        self.conn = sqlite3.connect(self.database_path)
        self.conn.row_factory = sqlite3.Row

        self.tables_config = config["tables"]
        self.bookcases_table = self.tables_config["bookcases"]
        self.shelves_table = self.tables_config["shelves"]
        self.authors_table = self.tables_config["authors"]
        self.possessions_table = self.tables_config["possessions"]
        self.books_table = self.tables_config["books"]
        self.book_search_table = self.tables_config["book_search"]

    def setup(self):

        cursor = self.conn.cursor()

        try:
            table_schema = ("""
                            CREATE TABLE IF NOT EXISTS {bookcases} (
                                id TEXT PRIMARY KEY,
                                number INTEGER,
                                case_name TEXT,
                                sorting_method TEXT,
                                sequence_ordinal INCREMENT INTEGER,
                                genre TEXT,
                                deleted BOOLEAN
                            );
                            CREATE TABLE IF NOT EXISTS {shelves} (
                                id TEXT PRIMARY KEY,
                                bookcase TEXT NOT NULL,
                                number INTEGER,
                                sorting_method TEXT,
                                genre TEXT,
                                sequence_ordinal INCREMENT INTEGER,
                                deleted BOOLEAN,
                                FOREIGN KEY (bookcase) REFERENCES {bookcases} (id)
                            );
                            CREATE TABLE IF NOT EXISTS {authors} (
                                id TEXT PRIMARY KEY,
                                first_name TEXT NOT NULL,
                                last_name TEXT,
                                deleted BOOLEAN
                            );
                            CREATE TABLE IF NOT EXISTS {possessions} (
                                id TEXT PRIMARY KEY,
                                lend_date DATE,
                                holder TEXT CHECK (length(holder) <= 100),
                                holder_contact CHECK (length(holder_contact) <= 100),
                                deleted BOOLEAN
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
                                thumbnail_filename TEXT,
                                deleted BOOLEAN,
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

            logging.log(msg="Table schema created.", level=logging.INFO)
            cursor.executescript(table_schema)
            self.conn.commit()
            logging.log(msg="Table schema committed.", level=logging.INFO)

            # Full-text search index over books + author names, kept in sync via triggers.
            search_values = """
                                {{row}}.id, {{row}}.title, {{row}}.series, {{row}}.genre,
                                {{row}}.isbn, {{row}}.issn, {{row}}.description, {{row}}.notes,
                                (SELECT first_name FROM {authors} WHERE id = {{row}}.author),
                                (SELECT last_name FROM {authors} WHERE id = {{row}}.author)
                            """.format(authors=self.authors_table)
            search_columns = ("book_id, title, series, genre, isbn, issn, description, notes, "
                              "author_first, author_last")

            search_schema = ("""
                            CREATE VIRTUAL TABLE IF NOT EXISTS {book_search} USING fts5(
                                book_id UNINDEXED,
                                title, series, genre, isbn, issn, description, notes,
                                author_first, author_last,
                                tokenize = 'unicode61 remove_diacritics 2'
                            );
                            CREATE TRIGGER IF NOT EXISTS {book_search}_books_ai AFTER INSERT ON {books} BEGIN
                                INSERT INTO {book_search} ({columns}) VALUES ({new_values});
                            END;
                            CREATE TRIGGER IF NOT EXISTS {book_search}_books_ad AFTER DELETE ON {books} BEGIN
                                DELETE FROM {book_search} WHERE book_id = old.id;
                            END;
                            CREATE TRIGGER IF NOT EXISTS {book_search}_books_au AFTER UPDATE ON {books} BEGIN
                                DELETE FROM {book_search} WHERE book_id = old.id;
                                INSERT INTO {book_search} ({columns}) VALUES ({new_values});
                            END;
                            CREATE TRIGGER IF NOT EXISTS {book_search}_authors_au
                            AFTER UPDATE OF first_name, last_name ON {authors} BEGIN
                                UPDATE {book_search}
                                SET author_first = new.first_name, author_last = new.last_name
                                WHERE book_id IN (SELECT id FROM {books} WHERE author = new.id);
                            END;
                            CREATE TRIGGER IF NOT EXISTS {book_search}_authors_ad AFTER DELETE ON {authors} BEGIN
                                UPDATE {book_search} SET author_first = NULL, author_last = NULL
                                WHERE book_id IN (SELECT id FROM {books} WHERE author = old.id);
                            END;
                            DELETE FROM {book_search};
                            INSERT INTO {book_search} ({columns}) SELECT {b_values} FROM {books} b;
                           """
                            .format(
                book_search=self.book_search_table,
                books=self.books_table,
                authors=self.authors_table,
                columns=search_columns,
                new_values=search_values.format(row="new"),
                b_values=search_values.format(row="b")))

            cursor.executescript(search_schema)
            self.conn.commit()
            logging.log(msg="Search index created.", level=logging.INFO)

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
                tables = cursor.fetchall()
                logging.log(msg=f"Tables found {tables}", level=logging.DEBUG)
                logging.log(msg="Database at {database_path} found."
                            .format(database_path=self.database_path), level=logging.INFO)
                table_names = {table[0] for table in tables}
                required = {self.bookcases_table, self.shelves_table, self.authors_table,
                            self.possessions_table, self.books_table, self.book_search_table}
                return required.issubset(table_names)

            except sqlite3.OperationalError as e:
                raise e

        else:
            logging.log(msg="Database at {database_path} doesn't exist."
                        .format(database_path=self.database_path), level=logging.WARN)
            return False
        