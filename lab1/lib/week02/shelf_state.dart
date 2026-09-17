import 'models.dart';

sealed class ShelfState {
  const ShelfState();
}

final class Empty extends ShelfState {
  const Empty();
}

final class Ready extends ShelfState {
  final List<Book> books;

  const Ready(this.books);
}

final class Broken extends ShelfState {
  final String message;

  const Broken(this.message);
}

String describe(ShelfState state) => switch (state) {
      Empty() => 'The shelf is empty',
      Ready(books: final books) =>
        'The shelf contains ${books.length} books',
      Broken(message: final message) =>
        'Shelf error: $message',
    };

({int count, double avgPages}) statsOf(List<Book> books) {
  final count = books.length;

  final totalPages = books.fold<int>(
    0,
    (total, book) => total + book.pages,
  );

  final average =
      books.isEmpty ? 0.0 : totalPages / count;

  return (
    count: count,
    avgPages: average,
  );
}
