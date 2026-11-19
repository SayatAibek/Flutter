import 'package:flutter/material.dart';

import '../models/book.dart';
import '../models/profile.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({
    required this.profile,
    required this.books,
    required this.themeMode,
    required this.onProfileChanged,
    required this.onThemeModeChanged,
    super.key,
  });

  final Profile profile;
  final List<Book> books;
  final ThemeMode themeMode;
  final ValueChanged<Profile> onProfileChanged;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _groupController = TextEditingController();
  final GlobalKey<FormState> _groupFormKey = GlobalKey<FormState>();
  final RegExp _groupPattern = RegExp(r'^[A-Za-z0-9_-]{2,20}$');

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.profile.name;
    _groupController.text = widget.profile.group;
  }

  @override
  void didUpdateWidget(covariant ProfileTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.profile.name != widget.profile.name) {
      _nameController.text = widget.profile.name;
    }
    if (oldWidget.profile.group != widget.profile.group) {
      _groupController.text = widget.profile.group;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _groupController.dispose();
    super.dispose();
  }

  void _saveName(String value) {
    widget.onProfileChanged(
      Profile(name: value.trim(), group: _groupController.text.trim()),
    );
  }

  void _saveGroup(String value) {
    if (!(_groupFormKey.currentState?.validate() ?? false)) return;
    widget.onProfileChanged(
      Profile(name: _nameController.text.trim(), group: value.trim()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final name = widget.profile.name.trim();
    final listsCount = widget.books.fold<int>(
      0,
      (total, book) => total + (book.contains(name) ? 1 : 0),
    );

    return ListView(
      padding: const EdgeInsets.all(20),
      children: <Widget>[
        Center(
          child: CircleAvatar(
            radius: 42,
            backgroundColor: colors.primaryContainer,
            child: Icon(Icons.person, size: 42, color: colors.onPrimaryContainer),
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: Text(
            name.isEmpty ? 'Your reader profile' : name,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        const SizedBox(height: 4),
        Center(child: Text('You are on $listsCount lists')),
        const SizedBox(height: 24),
        TextFormField(
          controller: _nameController,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
            labelText: 'Reader name',
            hintText: 'Enter your name',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.person_outline),
          ),
          onFieldSubmitted: _saveName,
        ),
        const SizedBox(height: 14),
        Form(
          key: _groupFormKey,
          child: TextFormField(
            controller: _groupController,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              labelText: 'Group',
              hintText: 'For example, IT-2301',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.groups_outlined),
            ),
            validator: (value) {
              final text = value?.trim() ?? '';
              return _groupPattern.hasMatch(text)
                  ? null
                  : 'Use 2–20 letters, numbers, underscores, or hyphens.';
            },
            onFieldSubmitted: _saveGroup,
          ),
        ),
        const SizedBox(height: 28),
        Text('Appearance', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          children: <Widget>[
            for (final option in <(String, ThemeMode)>[
              ('System', ThemeMode.system),
              ('Light', ThemeMode.light),
              ('Dark', ThemeMode.dark),
            ])
              ChoiceChip(
                label: Text(option.$1),
                selected: widget.themeMode == option.$2,
                onSelected: (_) => widget.onThemeModeChanged(option.$2),
              ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          'Your name is used when you borrow or return a book. The group field accepts 2–20 letters, numbers, underscores, or hyphens.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colors.onSurfaceVariant,
              ),
        ),
      ],
    );
  }
}
