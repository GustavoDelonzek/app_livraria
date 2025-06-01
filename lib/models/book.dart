class Book {
  final String key;
  final String title;
  final String author;
  final int? coverId;
  final String? description;
  final double price;

  Book({
    required this.title,
    required this.author,
    this.coverId,
    this.description,
    required this.key,
    required this.price,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    final key = json['key'] ?? '';

    final randomPrice = 19.9 + (60 * (key.hashCode % 1000) / 1000);

    return Book(
      key: json['key'],
      title: json['title'] ?? 'Sem título',
      author: (json['author_name'] != null && (json['author_name'] as List).isNotEmpty)
          ? json['author_name'][0]
          : 'Autor desconhecido',
      coverId: json['cover_i'],
      description: json['description'],
      price: double.parse(randomPrice.toStringAsFixed(2)),
    );
  }

  factory Book.fromSubjectJson(Map<String, dynamic> json) {
      final key = json['key'] ?? '';
      
      final randomPrice = 19.9 + (60 * (key.hashCode % 1000) / 1000);

      return Book(
        key: key,
        title: json['title'] ?? 'Sem título',
        author: (json['authors'] != null && (json['authors'] as List).isNotEmpty)
            ? json['authors'][0]['name']
            : 'Autor desconhecido',
        coverId: json['cover_id'],
        description: json['description'],
        price: double.parse(randomPrice.toStringAsFixed(2)), 
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
      price: price,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'key': key,
      'title': title,
      'author': author,
      'coverId': coverId,
      'description': description,
      'price': price,
    };
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      key: map['key'],
      title: map['title'],
      author: map['author'],
      coverId: map['coverId'],
      description: map['description'],
      price: (map['price'] is int)
          ? (map['price'] as int).toDouble()
          : map['price'] ?? 0.0,
    );
  }

}
