// ignore_for_file: prefer_initializing_formals

import 'package:flutter/material.dart';

enum BookGenre {
  classic('Classic', Icons.menu_book, 'assets/books/classic.png'),
  fiction('Fiction', Icons.auto_stories, 'assets/books/fiction.png'),
  fantasy('Fantasy', Icons.psychology, 'assets/books/fantasy.png'),
  science('Science', Icons.science, 'assets/books/science.png'),
  mystery('Mystery', Icons.search, 'assets/books/mystery.png'),
  selfHelp('Self-Help', Icons.lightbulb, 'assets/books/self_help.png');

  const BookGenre(this.label, this.icon, this.coverAsset);

  final String label;
  final IconData icon;
  final String coverAsset;

  Color color(ColorScheme colors) => switch (this) {
        BookGenre.classic => colors.primary,
        BookGenre.fiction => colors.secondary,
        BookGenre.fantasy => colors.tertiary,
        BookGenre.science => colors.primaryContainer,
        BookGenre.mystery => colors.secondaryContainer,
        BookGenre.selfHelp => colors.tertiaryContainer,
      };
}

class Book {
  const Book({
    required this.title,
    required this.genre,
    required this.when,
    required this.limit,
    required List<String> names,
    required this.mode,
    required this.location,
    this.description,
    this.favourite = false,
  }) : _names = names;

  Book.empty()
      : title = '',
        genre = BookGenre.fiction,
        when = DateTime.utc(2026, 10, 20, 18, 9),
        limit = 10,
        _names = const [],
        mode = false,
        location = 'Library Hall',
        description = null,
        favourite = false;

  final String title;
  final BookGenre genre;
  final DateTime when;
  final int limit;
  final List<String> _names;
  final bool mode;
  final String location;
  final String? description;
  final bool favourite;

  List<String> get names => List.unmodifiable(_names);

  int get count => _names.length;

  ({int taken, int free}) get places {
    final t = count;
    final f = limit - t;
    return (taken: t, free: f < 0 ? 0 : f);
  }

  bool get isFull => count >= limit;

  bool get isPast => when.isBefore(DateTime.now());

  bool contains(String name) => _names.contains(name);

  Book copyWith({
    String? title,
    BookGenre? genre,
    DateTime? when,
    int? limit,
    List<String>? names,
    bool? mode,
    String? location,
    String? description,
    bool? favourite,
  }) =>
      Book(
        title: title ?? this.title,
        genre: genre ?? this.genre,
        when: when ?? this.when,
        limit: limit ?? this.limit,
        names: names ?? _names,
        mode: mode ?? this.mode,
        location: location ?? this.location,
        description: description ?? this.description,
        favourite: favourite ?? this.favourite,
      );
}