class Author {
  final String name;
  final String? country;

  const Author({
    required this.name,
    this.country,
  });

  @override
  String toString() =>
      country == null ? name : '$name ($country)';
}

enum Genre {
  craft('Craft'),
  theory('Theory'),
  unknown('Unknown');

  final String label;

  const Genre(this.label);

  static Genre fromString(String? raw) => switch (raw) {
        'craft' => Genre.craft,
        'theory' => Genre.theory,
        _ => Genre.unknown,
      };
}

abstract class LibraryItem {
  final String title;
  final int year;

  const LibraryItem({
    required this.title,
    required this.year,
  });

  String describe();

  bool get isOld => year < 2000;
}

mixin Borrowable on LibraryItem {
  String borrowLabel() => 'Available to borrow: $title';
}

class Book extends LibraryItem with Borrowable {
  final int pages;
  final Author author;
  final Genre genre;
  final String? description;

  const Book({
    required super.title,
    required super.year,
    required this.pages,
    required this.author,
    required this.genre,
    this.description,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    final title = json['title'] as String? ?? 'Unknown';
    final year = json['year'] as int? ?? 0;
    final pages = json['pages'] as int? ?? 0;
    final authorName = json['author'] as String? ?? 'Unknown';
    final country = json['country'] as String?;
    final genreText = json['genre'] as String?;
    final description = json['description'] as String?;

    return Book(
      title: title,
      year: year,
      pages: pages,
      author: Author(
        name: authorName,
        country: country,
      ),
      genre: Genre.fromString(genreText),
      description: description,
    );
  }

  bool get isLong => pages > 400;

  Book copyWith({
    String? title,
    int? year,
    int? pages,
    Author? author,
    Genre? genre,
    String? description,
  }) =>
      Book(
        title: title ?? this.title,
        year: year ?? this.year,
        pages: pages ?? this.pages,
        author: author ?? this.author,
        genre: genre ?? this.genre,
        description: description ?? this.description,
      );

  @override
  String describe() =>
      '$title by ${author.name}, published in $year';

  @override
  String toString() =>
      '$title ($year) - $pages pages - ${author.name} - ${genre.label}';
}

class Magazine extends LibraryItem {
  final int issue;

  const Magazine({
    required super.title,
    required super.year,
    required this.issue,
  });

  @override
  String describe() =>
      '$title, issue $issue ($year)';
}

class Ghost implements LibraryItem {
  @override
  final String title;

  @override
  final int year;

  const Ghost({
    required this.title,
    required this.year,
  });

  @override
  bool get isOld => year < 2000;

  @override
  String describe() =>
      'Ghost library item: $title ($year)';
}