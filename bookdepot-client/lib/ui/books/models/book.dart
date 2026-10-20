class Book {
  String? id;
  String? title;
  String? shelf;
  String? author;
  String? isbn;
  String? issn;
  String? genre;
  String? series;
  int? volumeNumber;
  String? language;
  int? edition;
  String? format;
  bool? fiction;
  bool? read;
  bool? shelved;
  String? possession;
  String? publishDate;
  String? printingDate;
  String? description;
  String? notes;
  int? sequenceOrdinal;
  String? thumbnailFilename;
  bool? deleted;

  Book({
    required this.id,
    this.shelf,
    this.title,
    this.author,
    this.genre,
    this.sequenceOrdinal,
    required this.deleted,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      shelf: json['shelf'],
      title: json['title'],
      author: json['author'],
      genre: json['genre'],
      sequenceOrdinal: json['sequence_ordinal'],
      deleted: json['deleted'],
    );
  }

  String? operator [](String other) {
    return null;
  }
}