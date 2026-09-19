import uuid
from dataclasses import dataclass
from datetime import datetime

@dataclass
class Bookcase:
    number: int | None = None
    id: str | None = str(uuid.uuid4())
    name: str | None = None
    sorting_method: str | None = None
    genre: str | None = None

    def generate_shelf(self, **kwargs):
        shelf = Shelf(bookcase=self, **kwargs)

    def update_number(self, number: int):
        self.number = number

    def name_case(self, name: str):
        self.name = name

    def update_sorting_method(self, sorting_method: str):
        self.sorting_method = sorting_method

    def update_genre(self, genre: str):
        self.genre = genre

@dataclass
class Shelf:
    number: int | None = None
    id: str | None = str(uuid.uuid4())
    bookcase: Bookcase | None = None
    sorting_method: str | None = None
    genre: str | None = None

    def update_number(self, number: int):
        self.number = number

    def update_bookcase(self, bookcase: Bookcase):
        self.bookcase = bookcase

    def update_sorting_method(self, sorting_method: str):
        self.sorting_method = sorting_method

    def update_genre(self, genre: str):
        self.genre = genre

@dataclass
class Author:
    id: str | None = str(uuid.uuid4())
    first_name: str | None = None
    last_name: str | None = None

@dataclass
class Loan:
    id: str | None = str(uuid.uuid4())


@dataclass
class Book:
    title: str
    id: str | None = str(uuid.uuid4())
    isbn: str | None = None # need to add data validation on this field
    issn: str | None = None
    shelf: Shelf | None = None
    author: Author | None = None
    genre: str | None = None
    language: str | None = None
    publish_date: str | None = None
    printing_date: str | None = None
    series: str | None = None
    volume_number: int | None = None
    genre: str | None = None
    language: str | None = None
    format: str | None = None # might make an enum for this, e.g., comic, audiobook, ebook, magazine, etc
    possession: Loan | None = None # this is meant to denote whose possession it's in if it's not shelved
    edition: int | None = None
    description: str | None = None
    notes: str | None = None
    thumbnail_filename: str | None = None
    fiction: bool=True
    read: bool=True
    shelved: bool=True

    def update_shelf(self, shelf: Shelf):
        self.shelf = shelf

    def update_attributes(self, attributes: dict):
        # In progress, needs to flexibly accept attributes without requiring all values
        for key, value in attributes.items():
            setattr(self, key, value)

# title = "title"
# author = "author"
# isbn = "isbn"
# test_book = Book(title=title, author=isbn, isbn=isbn)
# print(test_book)

