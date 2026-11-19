import 'package:flutter/material.dart';

import '../models/book.dart';
import '../widgets/book_collection.dart';
import '../widgets/empty_state.dart';

class BooksTab extends StatefulWidget {
  const BooksTab({
    required this.books,
    required this.onOpen,
    required this.onToggleFavourite,
    super.key,
  });

  final List<Book> books;
  final ValueChanged<Book> onOpen;
  final ValueChanged<Book> onToggleFavourite;

  @override
  State<BooksTab> createState() => _BooksTabState();
}

class _BooksTabState extends State<BooksTab> {
  final TextEditingController _searchController = TextEditingController();
  BookGenre? _selectedGenre;
  bool _showPast = false;
  String _search = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      _search = '';
      _selectedGenre = null;
      _showPast = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    final query = _search.trim().toLowerCase();
    final filteredBooks = widget.books.where((book) {
      final matchesQuery = book.title.toLowerCase().contains(query) ||
          book.location.toLowerCase().contains(query);
      final matchesGenre = _selectedGenre == null || book.genre == _selectedGenre;
      final matchesPast = !_showPast || book.isPast;
      return matchesQuery && matchesGenre && matchesPast;
    }).toList()
      ..sort((first, second) {
        if (first.isPast != second.isPast) return first.isPast ? 1 : -1;
        return first.when.compareTo(second.when);
      });

        

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: TextField(
            controller: _searchController,
            onChanged: (value) => setState(() => _search = value),
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: 'Search books or places',
              border: const OutlineInputBorder(),
              suffixIcon: _search.isEmpty
                  ? null
                  : IconButton(
                      tooltip: 'Clear search and filters',
                      onPressed: _clearSearch,
                      icon: const Icon(Icons.clear),
                    ),
            ),
          ),
        ),
        SizedBox(
          height: 48,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            children: <Widget>[
              ChoiceChip(
                label: const Text('All'),
                selected: _selectedGenre == null,
                onSelected: (_) => setState(() => _selectedGenre = null),
              ),
              const SizedBox(width: 8),
              for (final genre in BookGenre.values) ...<Widget>[
                ChoiceChip(
                  avatar: Icon(genre.icon, size: 17),
                  label: Text(genre.label),
                  selected: _selectedGenre == genre,
                  onSelected: (_) => setState(() {
                    _selectedGenre = _selectedGenre == genre ? null : genre;
                  }),
                ),
                const SizedBox(width: 8),
              ],
              FilterChip(
                avatar: const Icon(Icons.history, size: 17),
                label: const Text('Past'),
                selected: _showPast,
                onSelected: (value) => setState(() => _showPast = value),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Expanded(
          child: filteredBooks.isEmpty
              ? EmptyState(
                  icon: Icons.search_off,
                  message: 'No books match these filters.',
                  buttonLabel: 'Clear filters',
                  onPressed: _clearSearch,
                )
              : BookCollection(
                  books: filteredBooks,
                  onOpen: widget.onOpen,
                  onToggleFavourite: widget.onToggleFavourite,
                ),
        ),
      ],
    );
  }
}
