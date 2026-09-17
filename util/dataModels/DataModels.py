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

@dataclass
class Shelf(object):
    number: int
    id: uuid.UUID | uuid.uuid4()
    bookcase: Bookcase | None
    sorting_method: str | None
    genre: str | None

    def update_bookcase(self, bookcase: Bookcase):
        self.bookcase = bookcase

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
