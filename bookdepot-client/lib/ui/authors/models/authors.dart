class Author {
  String? id;
  String? firstName;
  String? lastName;
  String? sortingMethod;
  String? genre;
  int? sequenceOrdinal;
  String? fullName;

  Author({
    required this.id,
    this.sortingMethod,
    this.firstName,
    this.lastName,
    this.genre,
    this.fullName,
    this.sequenceOrdinal,
  });

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      id: json['id'],
      sortingMethod: json['sorting_method'],
      sequenceOrdinal: json['sequence_ordinal'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      fullName: '${json['first_name']} ${json['last_name']}',
    );
  }

  String? operator [](String other) {
    return null;
  }
}