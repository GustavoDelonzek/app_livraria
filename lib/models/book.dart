class Book {
  final String title;
  final String author;
  final int? coverId;

  Book({
    required this.title,
    required this.author,
    this.coverId,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      title: json['title'] ?? 'Sem título',
      author: (json['author_name'] != null && (json['author_name'] as List).isNotEmpty)
          ? json['author_name'][0]
          : 'Autor desconhecido',
      coverId: json['cover_i'],
    );
  }

  factory Book.fromSubjectJson(Map<String, dynamic> json) {
    return Book(
      title: json['title'] ?? 'Sem título',
      author: (json['authors'] != null && (json['authors'] as List).isNotEmpty)
          ? json['authors'][0]['name']
          : 'Autor desconhecido',
      coverId: json['cover_id'],
    );
  }

  String get coverUrl {
    if (coverId != null) {
      return 'https://covers.openlibrary.org/b/id/$coverId-M.jpg';
    }
    return 'https://via.placeholder.com/128x193.png?text=Sem+Capa';
  }
}
