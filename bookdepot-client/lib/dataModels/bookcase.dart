class Shelf {
  String? id;
  String? caseName;
  int? number;
  String? sortingMethod;
  String? genre;
  int? sequenceOrdinal;
  int deleted;

  Shelf({
    required this.id,
    this.number,
    this.caseName,
    this.sortingMethod,
    this.genre,
    this.sequenceOrdinal,
    required this.deleted,
  });

  factory Shelf.fromJson(Map<String, dynamic> json) {
    return Shelf(
      id: json['id'],
      caseName: json['case_name'],
      number: json['number'],
      sortingMethod: json['sorting_method'],
      genre: json['genre'],
      sequenceOrdinal: json['sequence_ordinal'],
      deleted: json['deleted'],
    );
  }

  String? operator [](String other) {}
}