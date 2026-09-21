import enum


class Format(enum.Enum):
    #TODO: This is not comprehensive. Other formats to be added as needed/on request.

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
    #TODO: This is not comprehensive. Working to determine how comprehensive we should get.

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
    nonfiction_general = "Nonfiction (General)"
    fiction_general = "Fiction (General)"

class SortingMethod(enum.Enum):
    alphabetical_az = "Alphabetical A-Z"
    manual = "Manual"
    dewey_decimal = "Dewey Decimal"
    color = "Color"
    chronological_publish = "Chronological (Publish date)"
    chronological_print = "Chronological (Printing date)"
    size = "Size"
    lcc = "Library of Congress Classification"

class Language(enum.Enum):
    # TODO: This is not comprehensive. Additional languages may be added on request/as needed.

    en = "English"
    es = "Español"
    fr = "Francais"
    it = "Italiano"
    de = "Deutsch"
    el = "Ελληνικά"
    la = "Latinum"
    hi = "Hindi"
    he = "Ivrit"
    ht = "Kreyòl ayisyen"
    ja = "日本語"
    ko_s = "한국어"
    ko_n = "조선말"
    ia = "Interlingua"
    id = "Bahasa Indonesia"
    ik = "Iñupiaq"
    iu = "Inuktitut"
    th = "Thai"
    zh = "Zhōngwén"
    uk = "Ukraїnska"
    ru = "Русский"
