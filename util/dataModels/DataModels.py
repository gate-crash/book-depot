import uuid
from dataclasses import dataclass

@dataclass
class Bookcase(object):
    number: int
    id: uuid.UUID | uuid.uuid4()
    name: str | None
    sorting_method: str | None
    genre: str | None

    def generate_shelf(self, **kwargs):
        shelf = Shelf(bookcase=self, **kwargs)

    def name_case(self, name: str):
        self.name = name

    def update_sort(self, sorting_method: str):
        self.sorting_method = sorting_method

    def update_genre(self, genre: str):
        self.genre = genre

@dataclass
class Shelf(object):
    number: int | None
    id: uuid.UUID | uuid.uuid4()
    bookcase: Bookcase | None
    sorting_method: str | None
    genre: str | None

    def update_number(self, number: int):
        self.number = number

    def update_bookcase(self, bookcase: Bookcase):
        self.bookcase = bookcase

    def update_sorting_method(self, sorting_method: str):
        self.sorting_method = sorting_method

    def update_genre(self, genre: str):
        self.genre = genre

@dataclass
class Book:
    title: str
    id: uuid.UUID | uuid.uuid4()
    shelf: Shelf | None
    author: list | None
    genre: str | None
    language: str | None
    publish_date: str | None
    printing_date: str | None
    series: str | None
    volume_number: int | None
    genre: str | None
    language: str | None
    format: str | None
    fiction: bool=True
    read: bool=True

    def update_shelf(self, shelf: Shelf):
        self.shelf = shelf

    def update_attributes(self, attributes: dict):
        # In progress
        self.author = attributes["author"]
