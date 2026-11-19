import 'package:flutter/material.dart';

import '../models/book.dart';
import 'book_card.dart';
import 'empty_state.dart';

class BookCollection extends StatelessWidget {
  const BookCollection({
    required this.books,
    required this.onOpen,
    required this.onToggleFavourite,
    this.emptyMessage = 'No books found.',
    this.emptyIcon = Icons.menu_book_outlined,
    super.key,
  });

  final List<Book> books;
  final ValueChanged<Book> onOpen;
  final ValueChanged<Book> onToggleFavourite;
  final String emptyMessage;
  final IconData emptyIcon;

  @override
  Widget build(BuildContext context) {
    if (books.isEmpty) {
      return EmptyState(icon: emptyIcon, message: emptyMessage);
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 600) {
          return GridView.builder(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 360,
              childAspectRatio: 1.35,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
              return BookCard(
                book: book,
                onOpen: () => onOpen(book),
                onToggleFavourite: () => onToggleFavourite(book),
              );
            },
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
          itemCount: books.length,
          separatorBuilder: (context, index) => const SizedBox(height: 4),
          itemBuilder: (context, index) {
            final book = books[index];
            return BookCard(
              book: book,
              onOpen: () => onOpen(book),
              onToggleFavourite: () => onToggleFavourite(book),
            );
          },
        );
      },
    );
  }
}
