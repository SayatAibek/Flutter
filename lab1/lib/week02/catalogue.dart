import 'models.dart';

class Library {
  final List<LibraryItem> items = [];

  late final DateTime openedAt;

  String? _cachedReport;

  void add(LibraryItem item) {
    items.add(item);
  }

  void open() {
    openedAt = DateTime.now();
  }

  Book? findByTitle(String title) {
    for (final item in items) {
      if (item is Book && item.title == title) {
        return item;
      }
    }

    return null;
  }

  String countryOf(String title) =>
      findByTitle(title)?.author.country ?? 'unknown';

  List<String> get titles =>
      items.map((item) => item.title).toList();

  List<Book> get booksAfter2010 =>
      items
          .whereType<Book>()
          .where((book) => book.year > 2010)
          .toList();

  // fold has an initial value, so it is safe for an empty collection.
  // reduce requires at least one element.
  double get averagePageCount =>
      items.whereType<Book>().isEmpty
          ? 0.0
          : items
                  .whereType<Book>()
                  .fold<int>(
                    0,
                    (total, book) => total + book.pages,
                  ) /
              items.whereType<Book>().length;

  Map<String, int> get booksPerAuthor =>
      items.whereType<Book>().fold<Map<String, int>>(
            <String, int>{},
            (counts, book) => {
              ...counts,
              book.author.name:
                  (counts[book.author.name] ?? 0) + 1,
            },
          );

  Set<String> get authorNames =>
      items
          .whereType<Book>()
          .map((book) => book.author.name)
          .toSet();

  Set<Genre> get genres =>
      items
          .whereType<Book>()
          .map((book) => book.genre)
          .toSet();

  List<String> get displayList => [
        'CATALOGUE',
        for (final book in items.whereType<Book>())
          '${book.title} (${book.year})',
        ...authorNames,
        if (items
            .whereType<Book>()
            .any((book) => book.pages == 0))
          '(incomplete data)',
      ];

  String get report {
    _cachedReport ??= displayList.join('\n');
    return _cachedReport ?? '';
  }
}
