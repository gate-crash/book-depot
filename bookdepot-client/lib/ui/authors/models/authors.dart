class Author {
  String? id;
  String? firstName;
  String? lastName;
  String? sortingMethod;
  String? genre;
  int? sequenceOrdinal;

  Author({
    required this.id,
    this.sortingMethod,
    this.firstName,
    this.lastName,
    this.genre,
    this.sequenceOrdinal,
  });

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      id: json['id'],
      sortingMethod: json['sorting_method'],
      firstName: json['first_name'],
      sequenceOrdinal: json['sequence_ordinal'],
    );
  }

  String? operator [](String other) {
    return null;
  }
}