import 'package:flutter/material.dart';

import '../models/book.dart';
import '../widgets/book_collection.dart';

class FavouritesTab extends StatelessWidget {
  const FavouritesTab({
    required this.books,
    required this.onOpen,
    required this.onToggleFavourite,
    super.key,
  });

  final List<Book> books;
  final ValueChanged<Book> onOpen;
  final ValueChanged<Book> onToggleFavourite;

  @override
  Widget build(BuildContext context) {
    final favourites = books.where((book) => book.favourite).toList()
      ..sort((a, b) => a.when.compareTo(b.when));
    return BookCollection(
      books: favourites,
      onOpen: onOpen,
      onToggleFavourite: onToggleFavourite,
      emptyMessage: 'No favourites yet. Tap a heart on any book to save it here.',
      emptyIcon: Icons.favorite_border,
    );
  }
}
