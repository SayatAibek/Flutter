import 'package:flutter/material.dart';

import 'models/book.dart';

abstract final class Routes {
  static const String shell = '/';
  static const String detail = '/book-detail';
  static const String form = '/book-form';
}

class DetailRouteArgs {
  const DetailRouteArgs({
    required this.book,
    required this.profileName,
    required this.onUpdate,
    required this.onDelete,
    required this.onSwitchTab,
  });

  final Book book;
  final String profileName;
  final void Function(Book previous, Book next) onUpdate;
  final ValueChanged<Book> onDelete;
  final ValueChanged<int> onSwitchTab;
}

class FormRouteArgs {
  const FormRouteArgs({this.initial});
  final Book? initial;
}
