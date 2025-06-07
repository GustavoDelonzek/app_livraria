class Book {
  final String key;
  final String title;
  final String author;
  final String? thumbnailUrl;
  final String? description;
  final double price;

  Book({
    required this.key,
    required this.title,
    required this.author,
    this.thumbnailUrl,
    this.description,
    required this.price,
  });

  factory Book.fromSubjectJson(Map<String, dynamic> json) {
    final key = json['key'] ?? '';
    final randomPrice = 19.9 + (60 * (key.hashCode % 1000) / 1000);

    return Book(
      key: key,
      title: json['title'] ?? 'Sem título',
      author: (json['authors'] != null && (json['authors'] as List).isNotEmpty)
          ? json['authors'][0]['name']
          : 'Autor desconhecido',
      thumbnailUrl: json['cover_id'] != null
          ? 'https://covers.openlibrary.org/b/id/${json['cover_id']}-M.jpg'
          : null,
      description: json['description'],
      price: double.parse(randomPrice.toStringAsFixed(2)),
    );
  }

  factory Book.fromGoogleJson(Map<String, dynamic> json) {
    final volumeInfo = json['volumeInfo'];
    final key = json['id'] ?? '';
    final randomPrice = 19.9 + (60 * (key.hashCode % 1000) / 1000);

    return Book(
      key: key,
      title: volumeInfo['title'] ?? 'Sem título',
      author: (volumeInfo['authors'] != null && volumeInfo['authors'].isNotEmpty)
          ? volumeInfo['authors'][0]
          : 'Autor desconhecido',
      thumbnailUrl: fixImageUrl(volumeInfo['imageLinks']?['thumbnail']),
      description: volumeInfo['description'],
      price: double.parse(randomPrice.toStringAsFixed(2)),
    );
  }

  String get coverUrl =>
      thumbnailUrl ?? 'https://via.placeholder.com/128x193.png?text=Sem+Capa';

    static String fixImageUrl(String? url) {
    if (url == null) {
      return 'https://via.placeholder.com/128x196?text=Sem+Capa';
    }

    final fixedUrl = url.replaceFirst('http://', 'https://');
    final encoded = Uri.encodeComponent(fixedUrl); 

    return 'http://localhost:3000/proxy/$encoded';
  }

  Book copyWith({String? description}) {
    return Book(
      key: key,
      title: title,
      author: author,
      thumbnailUrl: thumbnailUrl,
      description: description ?? this.description,
      price: price,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'key': key,
      'title': title,
      'author': author,
      'thumbnailUrl': thumbnailUrl,
      'description': description,
      'price': price,
    };
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      key: map['key'],
      title: map['title'],
      author: map['author'],
      thumbnailUrl: map['thumbnailUrl'],
      description: map['description'],
      price: (map['price'] is int)
          ? (map['price'] as int).toDouble()
          : map['price'] ?? 0.0,
    );
  }
}
