class Author {
  final String key;
  final String name;
  final int workCount;

  Author({
    required this.key,
    required this.name,
    required this.workCount,
  });

  String get imageUrl => 'https://covers.openlibrary.org/a/olid/$key-M.jpg';


  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      key: json['key'],
      name: json['name'],
      workCount: json['work_count'],
    );
  }
}
