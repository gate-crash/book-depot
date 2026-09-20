import enum


class Format(enum.Enum):
    hardcover = "Hardcover Book"
    softcover = "Softcover Book"
    binder_book = "Binder Book"
    album = "Album"
    comic_issue = "Comic Issue"
    comic_volume = "Comic Volume"
    ebook = "Ebook"
    audiobook = "Audiobook"
    movie = "Movie"
    magazine = "Magazine"
    zine = "Zine"
    coloring_book = "Coloring Book"

class Genre(enum.Enum):
    biography = "Biography"
    memoir = "Memoir"
    scifi = "SciFi"
    fantasy = "Fantasy"
    history = "History"
    literature = "Literature"
    poetry = "Poetry"
    rpg_sourcebook = "RPG Sourcebook"
    young_adult = "Young Adult"
    romance = "Romance"
    computer_science = "Computer Science"
    metaphysics = "Metaphysics"
    philosophy = "Philosophy"
    parapsychology = "Parapsychology/Occultism"
    ethics = "Ethics"
    religion = "Religion"
    arts = "Arts"
    self_help = "Self-help"

class SortingMethod(enum.Enum):
    alphabetical_az = "Alphabetical A-Z"
    manual = "Manual"
    dewey_decimal = "Dewey Decimal"
