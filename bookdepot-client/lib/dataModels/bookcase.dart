class Bookcase {
  final String caseName;

  Bookcase({required this.caseName});

  factory Bookcase.fromJson(Map<String, dynamic> json) {
    return Bookcase(
      caseName: json['case_name'] ?? 'Unnamed Case',
    );
  }
}