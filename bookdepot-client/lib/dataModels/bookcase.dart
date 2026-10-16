class Bookcase {
  String? id;
  String? caseName;
  int? number;
  String? sortingMethod;
  String? genre;
  int? sequenceOrdinal;
  int deleted;

  Bookcase({
    required this.id,
    this.number,
    this.caseName,
    this.sortingMethod,
    this.genre,
    this.sequenceOrdinal,
    required this.deleted,
  });

  factory Bookcase.fromJson(Map<String, dynamic> json) {
    return Bookcase(
      id: json['id'],
      caseName: json['case_name'],
      number: json['number'],
      sortingMethod: json['sorting_method'],
      genre: json['genre'],
      sequenceOrdinal: json['sequence_ordinal'],
      deleted: json['deleted'],
    );
  }
}