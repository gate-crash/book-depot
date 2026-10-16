class Shelf {
  String? id;

  Shelf({
    required this.id,
  });

  factory Shelf.fromJson(Map<String, dynamic> json) {
    return Shelf(
      id: json['id'],
    );
  }
}