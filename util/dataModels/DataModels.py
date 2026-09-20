import uuid
from dataclasses import dataclass, asdict
from datetime import datetime

from util.dataModels.Descriptors import Genre, SortingMethod, Format, Language

@dataclass
class Bookcase:
    number: int | None = None
    id: str | None = str(uuid.uuid4())
    name: str | None = None
    sorting_method: str | None = None
    genre: Genre | None = None

    def clean_dict(self):
        return asdict(self, dict_factory=lambda x: {k: v for k, v in x if v is not None})

@dataclass
class Shelf:
    number: int | None = None
    id: str | None = str(uuid.uuid4())
    bookcase: Bookcase | None = None
    sorting_method: str | None = None
    genre: Genre | None = None

    def clean_dict(self):
        return asdict(self, dict_factory=lambda x: {k: v for k, v in x if v is not None})

@dataclass
class Author:
    id: str | None = str(uuid.uuid4())
    first_name: str | None = None
    last_name: str | None = None

    def clean_dict(self):
        return asdict(self, dict_factory=lambda x: {k: v for k, v in x if v is not None})

@dataclass
class Possession:
    id: str | None = str(uuid.uuid4())
    lend_date: datetime | None = None
    holder: str | None = None
    holder_contact: str | None = None

    def clean_dict(self):
        return asdict(self, dict_factory=lambda x: {k: v for k, v in x if v is not None})

@dataclass
class Book:
    title: str
    id: str | None = str(uuid.uuid4())
    isbn: str | None = None # need to add data validation on this field
    issn: str | None = None
    shelf: Shelf | None = None
    author: Author | None = None
    genre: Genre | None = None
    language: Language | None = None
    publish_date: str | None = None
    printing_date: str | None = None
    series: str | None = None
    volume_number: int | None = None
    genre: str | None = None
    format: Format | None = None # might make an enum for this, e.g., comic, audiobook, ebook, magazine, etc
    possession: Possession | None = None # this is meant to denote whose possession it's in if it's not shelved
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

    def clean_dict(self):
        return asdict(self, dict_factory=lambda x: {k: v for k, v in x if v is not None})
