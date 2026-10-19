class Shelf {
  String? id;
  String? caseName;

  Shelf({
    required this.id,
    this.caseName,
  });

  factory Shelf.fromJson(Map<String, dynamic> json) {
    return Shelf(
      id: json['id'],
      caseName: json['case_name'],
    );
  }
}