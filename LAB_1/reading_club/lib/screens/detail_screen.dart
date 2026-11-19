import 'dart:async';

import 'package:flutter/material.dart';

import '../models/book.dart';
import '../models/countdown.dart';
import '../routes.dart';
import '../utils/format.dart';
import '../widgets/empty_state.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({required this.args, super.key});

  final DetailRouteArgs args;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Book _book;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _book = widget.args.book;
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _commit(Book updated) {
    final previous = _book;
    setState(() => _book = updated);
    widget.args.onUpdate(previous, updated);
  }

  Future<void> _editBook() async {
    final edited = await Navigator.of(context).pushNamed<Book>(
      Routes.form,
      arguments: FormRouteArgs(initial: _book),
    );
    if (!mounted || edited == null) return;
    _commit(edited);
  }

  Future<void> _deleteBook() async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete this book?'),
        content: Text('“${_book.title}” will be removed from Reading Club.'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (!mounted || shouldDelete != true) return;
    widget.args.onDelete(_book);
    Navigator.of(context).pop();
  }

  Future<void> _borrowOrReturn() async {
    final name = widget.args.profileName.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Add your reader name in Profile first.'),
          action: SnackBarAction(
            label: 'Open profile',
            onPressed: () {
              widget.args.onSwitchTab(2);
              Navigator.of(context).pop();
            },
          ),
        ),
      );
      return;
    }

    final returning = _book.contains(name);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(returning ? 'Return this book?' : 'Borrow this book?'),
        content: Text(
          returning
              ? 'Remove $name from the readers list for “${_book.title}”?'
              : 'Add $name to the readers list for “${_book.title}”?',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(returning ? 'Return' : 'Borrow'),
          ),
        ],
      ),
    );
    if (!mounted || confirmed != true) return;

    final names = List<String>.of(_book.names);
    if (returning) {
      names.remove(name);
    } else if (!_book.isFull && !names.contains(name)) {
      names.add(name);
    }
    _commit(_book.copyWith(names: names));
  }

  Widget _countdown(ColorScheme colors) {
    final countdown = Countdown.fromDateTime(_book.when);
    final String label = switch (countdown) {
      Upcoming(:final remaining) => 'Starts in ${formatDuration(remaining)}',
      Started(:final elapsed) => 'Started ${elapsed.inMinutes} minutes ago',
      Ended() => 'Meeting ended',
    };
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        child: Text(label, style: Theme.of(context).textTheme.labelMedium),
      ),
    );
  }

  Widget _header(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SizedBox(
      height: 225,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.asset(
            _book.genre.coverAsset,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                ColoredBox(color: colors.surfaceContainerHighest),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[colors.scrim.withValues(alpha: 0.08), colors.scrim.withValues(alpha: 0.6)],
              ),
            ),
          ),
          Positioned(
            left: 14,
            top: 14,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: colors.surface.withValues(alpha: 0.92),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(_book.genre.icon, size: 18, color: _book.genre.color(colors)),
                    const SizedBox(width: 6),
                    Text(_book.genre.label),
                  ],
                ),
              ),
            ),
          ),
          Positioned(right: 14, top: 14, child: _countdown(colors)),
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: Text(
              _book.title,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: colors.onInverseSurface,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _aboutTab(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final (:taken, :free) = _book.places;
    return ListView(
      padding: const EdgeInsets.all(20),
      children: <Widget>[
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(Icons.event_outlined, color: colors.primary),
          title: const Text('Meeting date'),
          subtitle: Text(formatDateTime(_book.when)),
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(_book.mode ? Icons.link : Icons.place_outlined, color: colors.primary),
          title: Text(_book.mode ? 'Online meeting link' : 'Meeting place'),
          subtitle: SelectableText(_book.location),
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(Icons.people_outline, color: colors.primary),
          title: const Text('Borrowers / places'),
          subtitle: Text('$taken of ${_book.limit} places used · $free available'),
        ),
        if (_book.description != null) ...<Widget>[
          const SizedBox(height: 12),
          Text('About this book', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 6),
          Text(_book.description ?? ''),
        ],
      ],
    );
  }

  Widget _readersTab(BuildContext context) {
    final name = widget.args.profileName.trim();
    final sortedNames = List<String>.of(_book.names)
      ..sort((first, second) {
        if (first == name) return -1;
        if (second == name) return 1;
        return first.toLowerCase().compareTo(second.toLowerCase());
      });
    if (sortedNames.isEmpty) {
      return const EmptyState(
        icon: Icons.people_outline,
        message: 'Nobody has borrowed this book yet.',
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: sortedNames.length,
      itemBuilder: (context, index) {
        final reader = sortedNames[index];
        final isYou = name.isNotEmpty && reader == name;
        return ListTile(
          leading: CircleAvatar(
            child: Text(reader.isEmpty ? '?' : reader.substring(0, 1).toUpperCase()),
          ),
          title: Text(
            isYou ? '$reader (You)' : reader,
            style: isYou ? const TextStyle(fontWeight: FontWeight.bold) : null,
          ),
          trailing: isYou ? const Icon(Icons.person) : null,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.args.profileName.trim();
    final isBorrowedByYou = _book.names.any((reader) => reader == name);
    final canBorrow = isBorrowedByYou || !_book.isFull;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book details'),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (choice) {
              if (choice == 'edit') _editBook();
              if (choice == 'delete') _deleteBook();
            },
            itemBuilder: (context) => const <PopupMenuEntry<String>>[
              PopupMenuItem<String>(value: 'edit', child: Text('Edit')),
              PopupMenuItem<String>(value: 'delete', child: Text('Delete')),
            ],
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          _header(context),
          Expanded(
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: <Widget>[
                  TabBar(
                    tabs: <Widget>[
                      const Tab(text: 'About'),
                      Tab(text: 'Readers (${_book.count})'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: <Widget>[
                        _aboutTab(context),
                        _readersTab(context),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: FilledButton.icon(
          onPressed: canBorrow ? _borrowOrReturn : null,
          icon: Icon(isBorrowedByYou ? Icons.assignment_return : Icons.bookmark_add_outlined),
          label: Text(isBorrowedByYou ? 'Return book' : 'Borrow book'),
        ),
      ),
    );
  }
}
