import uuid
from dataclasses import dataclass, asdict
from datetime import datetime

from src.util.dataModels import Descriptors
from src.util.dataModels.Descriptors import Genre, Format, Language

@dataclass
class DataGeneric:
    id: str | None = str(uuid.uuid4())

    def clean_dict(self):
        return asdict(self, dict_factory=lambda x: {k: v for k, v in x if v is not None})

@dataclass
class Bookcase(DataGeneric):
    number: int | None = None
    name: str | None = None
    sorting_method: str | None = None
    genre: str | None = None
    sequence_ordinal: int | None = None
    deleted: bool=False

@dataclass
class Shelf(DataGeneric):
    number: int | None = None
    bookcase: Bookcase | None = None
    sorting_method: str | None = None
    genre: str | None = None
    sequence_ordinal: int | None = None
    deleted: bool=False

@dataclass
class Author(DataGeneric):
    first_name: str | None = None
    last_name: str | None = None
    deleted: bool=False

@dataclass
class Possession(DataGeneric):
    lend_date: datetime | None = None
    holder: str | None = None
    holder_contact: str | None = None
    deleted: bool=False

@dataclass
class Book(DataGeneric):
    title: str | None = None
    isbn: str | None = None
    issn: str | None = None
    shelf: Shelf | None = None
    author: Author | None = None
    genre: str | None = None
    language: str | None = Descriptors.Language.en.value
    publish_date: str | None = None
    printing_date: str | None = None
    series: str | None = None
    volume_number: int | None = None
    format: str | None = Descriptors.Format.paperback.value
    # possession is meant to denote whose possession it's in if it's not shelved
    possession: Possession | None = None
    edition: int | None = None
    description: str | None = None
    notes: str | None = None
    thumbnail_filename: str | None = None
    sequence_ordinal: float | None = None
    fiction: bool=True
    read: bool=True
    shelved: bool=True
    deleted: bool=False

    def update_shelf(self, shelf: Shelf):
        self.shelf = shelf

    def update_attributes(self, attributes: dict):
        # In progress, needs to flexibly accept attributes without requiring all values
        for key, value in attributes.items():
            setattr(self, key, value)

    def __post_init__(self):

        if self.isbn:
            isbn = str(self.isbn).replace('-', '')
            print(isbn)

            if len(isbn) <= 13 | isbn.isdigit():
                self.isbn = str(isbn)
            else:
                raise(ValueError("ISBN must be 13 numbers long or shorter."))
