import 'catalogue.dart';
import 'data.dart';
import 'models.dart';
import 'shelf_state.dart';

void main() {
  final books =
      rawBooks.map((data) => Book.fromJson(data)).toList();

  final library = Library();

  library.open();

  for (final book in books) {
    library.add(book);
  }

  print('=== LIBRARY ===');
  print(library.report);

  print('\n=== SEARCH ===');

  final cleanCode = library.findByTitle('Clean Code');
  print('Clean Code: ${cleanCode?.describe() ?? 'not found'}');

  final missingBook = library.findByTitle('Harry Potter');
  print(
    'Harry Potter: ${missingBook?.describe() ?? 'not found'}',
  );

  print(
    'Clean Code country: ${library.countryOf('Clean Code')}',
  );

  print(
    'Design Patterns country: '
    '${library.countryOf('Design Patterns')}',
  );

  print('\n=== COLLECTION QUERIES ===');

  print('Titles: ${library.titles}');
  print('Books after 2010: ${library.booksAfter2010}');
  print('Average pages: ${library.averagePageCount}');
  print('Books per author: ${library.booksPerAuthor}');
  print('Authors: ${library.authorNames}');
  print('Genres: ${library.genres}');

  print('\n=== BOOK FEATURES ===');

  for (final book in books) {
    print(
      '${book.title}: '
      'long=${book.isLong}, '
      'old=${book.isOld}, '
      '${book.borrowLabel()}',
    );
  }

  print('\n=== RECORD ===');

  final stats = statsOf(books);

  print('Book count: ${stats.count}');
  print('Average pages: ${stats.avgPages}');

  print('\n=== SHELF STATES ===');

  const ShelfState emptyState = Empty();

  final ShelfState readyState = Ready(books);

  const ShelfState brokenState =
      Broken('Catalogue is unavailable');

  print(describe(emptyState));
  print(describe(readyState));
  print(describe(brokenState));
}