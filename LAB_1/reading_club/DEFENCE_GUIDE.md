# Defence quick guide

Open these files first when a pool task is announced:

1. **Add a sixth genre with icon and colour:** `lib/models/book.dart` (`BookGenre`) and `assets/books/` for any new artwork. The chips and dropdown iterate over `BookGenre.values`.
2. **Sort by title, keeping past books last:** `lib/screens/books_tab.dart`, in the copied-list `.sort(...)` callback.
3. **Search the place field too:** already supported in `lib/screens/books_tab.dart` by matching both `book.title` and `book.location` case-insensitively.
4. **Add an online-only FilterChip:** add a boolean state field and chip in `lib/screens/books_tab.dart`, then include the boolean in the `filteredBooks` predicate.
5. **Show favourite count on the destination:** `lib/screens/shell_screen.dart`; `favouriteCount` is computed using `fold` and used in the Favourites destination label.
6. **Change grid breakpoint or column cap:** `lib/widgets/book_collection.dart`; the `LayoutBuilder` chooses list vs grid and `SliverGridDelegateWithMaxCrossAxisExtent` caps cell width.
7. **Confirm returning a book:** `lib/screens/detail_screen.dart`, inside `_borrowOrReturn()` where the confirmation dialog is shown for both borrowing and returning.
8. **Change the countdown text:** `lib/models/countdown.dart` and the exhaustive switch in `lib/screens/detail_screen.dart`.
9. **Add Duplicate:** start from `lib/screens/detail_screen.dart`'s popup menu and open `lib/screens/form_screen.dart` with a copy whose `names` list is empty.
10. **Make the limit depend on online mode:** add the condition in `_validateLimit()` in `lib/screens/form_screen.dart`.
11. **Add a drawer Statistics tile:** `lib/screens/shell_screen.dart`; calculate counts with `fold` or `map` and display them in an `AlertDialog`.
12. **Clear the profile:** add a confirmation action in `lib/screens/profile_tab.dart`, then send `const Profile.empty()` through `onProfileChanged`.
13. **Clear search and filters:** `_clearSearch()` in `lib/screens/books_tab.dart` already resets text, genre, and past filter together.
14. **Move past filter to the AppBar:** move the `FilterChip` state/action from `lib/screens/books_tab.dart` into an `IconButton` in `lib/screens/shell_screen.dart`, passing the value and callback through the tab constructor.
15. **Show description on each card:** `lib/widgets/book_card.dart`; the optional description is already rendered using a collection `if` and two-line ellipsis.
16. **Keep “You” first in the readers tab:** `_readersTab()` in `lib/screens/detail_screen.dart` copies and sorts the names so the current profile name is first and bold.

After any change, run `dart format .` and `flutter analyze`. Practise explaining what each changed line does rather than memorising a finished patch.
