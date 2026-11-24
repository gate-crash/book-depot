class Author {
  String? id;
  String? sortingMethod;
  String? genre;
  int? sequenceOrdinal;
  String? name;

  Author({
    required this.id,
    this.sortingMethod,
    this.genre,
    this.name,
    this.sequenceOrdinal,
  });

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      id: json['id'],
      sortingMethod: json['sorting_method'],
      sequenceOrdinal: json['sequence_ordinal'],
      name: '${json['name']}',
    );
  }

  String? operator [](String other) {
    return null;
  }
}