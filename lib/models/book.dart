class Book {
  final String key;
  final String title;
  final String author;
  final int? coverId;
  final String? description;

  Book({
    required this.title,
    required this.author,
    this.coverId,
    this.description,
    required this.key,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      key: json['key'],
      title: json['title'] ?? 'Sem título',
      author: (json['author_name'] != null && (json['author_name'] as List).isNotEmpty)
          ? json['author_name'][0]
          : 'Autor desconhecido',
      coverId: json['cover_i'],
      description: json['description'],
    );
  }

  factory Book.fromSubjectJson(Map<String, dynamic> json) {
    return Book(
      key: json['key'],
      title: json['title'] ?? 'Sem título',
      author: (json['authors'] != null && (json['authors'] as List).isNotEmpty)
          ? json['authors'][0]['name']
          : 'Autor desconhecido',
      coverId: json['cover_id'],
      description: json['description'],
    );
  }

  String get coverUrl {
    if (coverId != null) {
      return 'https://covers.openlibrary.org/b/id/$coverId-M.jpg';
    }
    return 'https://via.placeholder.com/128x193.png?text=Sem+Capa';
  }

    Book copyWith({String? description}) {
    return Book(
      key: key,
      title: title,
      author: author,
      coverId: coverId,
      description: description ?? this.description,
    );
  }

}
