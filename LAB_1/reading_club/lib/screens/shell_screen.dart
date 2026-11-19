import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../data/seed_data.dart';
import '../models/book.dart';
import '../models/profile.dart';
import '../routes.dart';
import 'books_tab.dart';
import 'favourites_tab.dart';
import 'profile_tab.dart';

class ShellScreen extends StatefulWidget {
  const ShellScreen({
    required this.themeModeListenable,
    required this.onThemeModeChanged,
    super.key,
  });

  final ValueListenable<ThemeMode> themeModeListenable;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  State<ShellScreen> createState() => _ShellScreenState();
}

class _ShellScreenState extends State<ShellScreen> {
  List<Book> _books = seedBooks();
  Profile _profile = const Profile.empty();
  int _currentTab = 0;

  void _changeTab(int index) {
    if (index < 0 || index > 2) return;
    setState(() => _currentTab = index);
  }

  void _updateBook(Book previous, Book next) {
    setState(() {
      final index = _books.indexWhere((book) => identical(book, previous));
      if (index >= 0) {
        final updatedBooks = List<Book>.of(_books);
        updatedBooks[index] = next;
        _books = updatedBooks;
      }
    });
  }

  void _toggleFavourite(Book book) {
    setState(() {
      _books = _books
          .map((item) => identical(item, book)
              ? item.copyWith(favourite: !item.favourite)
              : item)
          .toList();
    });
  }

  void _deleteBook(Book book) {
    setState(() {
      _books = _books.where((item) => !identical(item, book)).toList();
    });
  }

  void _saveProfile(Profile profile) {
    setState(() => _profile = profile);
  }

  void _openBook(Book book) {
    Navigator.of(context).pushNamed<void>(
      Routes.detail,
      arguments: DetailRouteArgs(
        book: book,
        profileName: _profile.name,
        onUpdate: _updateBook,
        onDelete: _deleteBook,
        onSwitchTab: _changeTab,
      ),
    );
  }

  Future<void> _createBook() async {
    final created = await Navigator.of(context).pushNamed<Book>(
      Routes.form,
      arguments: const FormRouteArgs(),
    );
    if (!mounted || created == null) return;
    setState(() => _books = <Book>[created, ..._books]);
  }

  void _showAbout(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: const Icon(Icons.menu_book),
        title: const Text('About Reading Club'),
        content: const Text(
          'Reading Club helps readers discover books, save favourites, and keep track of who borrowed each book. This lab version keeps all information in memory.',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmReset(BuildContext context) async {
    final shouldReset = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Reset all data?'),
        content: const Text('The original twelve books will be restored and your profile will be cleared.'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
    if (!mounted || shouldReset != true) return;
    setState(() {
      _books = seedBooks();
      _profile = const Profile.empty();
      _currentTab = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final titles = <String>['Books', 'Favourites', 'Profile'];
    final favouriteCount = _books.fold<int>(
      0,
      (count, book) => count + (book.favourite ? 1 : 0),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(titles[_currentTab]),
        actions: <Widget>[
          if (_currentTab == 1 && favouriteCount > 0)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(child: Text('$favouriteCount saved')),
            ),
        ],
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              DrawerHeader(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Icon(Icons.menu_book, size: 42, color: Theme.of(context).colorScheme.primary),
                    const SizedBox(height: 8),
                    Text('Reading Club', style: Theme.of(context).textTheme.titleLarge),
                    Text('Read together, grow together', style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
              Builder(
                builder: (drawerContext) => ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('About'),
                  onTap: () {
                    Navigator.pop(drawerContext);
                    _showAbout(context);
                  },
                ),
              ),
              Builder(
                builder: (drawerContext) => ListTile(
                  leading: const Icon(Icons.restart_alt),
                  title: const Text('Reset data'),
                  onTap: () {
                    Navigator.pop(drawerContext);
                    _confirmReset(context);
                  },
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Lab 1 · Mobile Development', style: Theme.of(context).textTheme.bodySmall),
              ),
            ],
          ),
        ),
      ),
      body: IndexedStack(
        index: _currentTab,
        children: <Widget>[
          BooksTab(
            books: _books,
            onOpen: _openBook,
            onToggleFavourite: _toggleFavourite,
          ),
          FavouritesTab(
            books: _books,
            onOpen: _openBook,
            onToggleFavourite: _toggleFavourite,
          ),
          ValueListenableBuilder<ThemeMode>(
            valueListenable: widget.themeModeListenable,
            builder: (context, themeMode, child) => ProfileTab(
              profile: _profile,
              books: _books,
              themeMode: themeMode,
              onProfileChanged: _saveProfile,
              onThemeModeChanged: widget.onThemeModeChanged,
            ),
          ),
        ],
      ),
      floatingActionButton: _currentTab == 0
          ? FloatingActionButton(
              onPressed: _createBook,
              tooltip: 'Add a book',
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentTab,
        onDestinationSelected: _changeTab,
        destinations: <NavigationDestination>[
          const NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: 'Books',
          ),
          NavigationDestination(
            icon: const Icon(Icons.favorite_border),
            selectedIcon: const Icon(Icons.favorite),
            label: favouriteCount > 0 ? 'Favourites ($favouriteCount)' : 'Favourites',
          ),
          const NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

