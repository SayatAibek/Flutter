# Reading Club

A Flutter app for a small reading club. Readers can browse books, search by title or place, filter by genre and past meetings, borrow or return a book, manage favourites, and edit their reader profile. All data is held in memory, as required for Lab 1; restarting the app restores the twelve seed books.

## Run it in VS Code

1. Copy the supplied `lib/` and `assets/` folders into the root of your `reading_club` Flutter project, replacing the generated `lib/` folder. Also replace the generated `test/widget_test.dart` with the supplied test file.
2. Add the asset stanza shown in `pubspec_assets_snippet.txt` to the existing `pubspec.yaml` under `flutter:`. Keep the Flutter SDK and `flutter_lints` dependencies; no extra package is needed.
3. In the VS Code terminal, run:

   ```bash
   flutter pub get
   dart format .
   flutter analyze
   flutter test
   flutter run
   ```

## Screenshots to add before submission

Capture screenshots from the running application and save them with these exact names. Use a phone-sized emulator for the first two and a tablet-sized emulator or resized tablet emulator for the third.

### Phone — Light theme

![Phone screenshot, light theme](screenshots/phone-light.png)

### Phone — Dark theme

![Phone screenshot, dark theme](screenshots/phone-dark.png)

### Tablet — Grid layout

![Tablet screenshot showing grid layout](screenshots/tablet-grid.png)

These must be real screenshots of the running app; the image files are intentionally not fabricated here. Add them before the final GitHub submission.

## Decisions

The list of books and the reader profile live in the shell widget's `State`, while each tab receives its data through constructor parameters and sends edits back through callbacks. The detail page receives its book and callbacks through typed route arguments so changes can be committed to the shell without introducing another data store. The form receives an optional book and returns the saved book through `Navigator.pop`, allowing the caller to distinguish a saved result from a cancelled form. The responsive grid uses `LayoutBuilder` and a maximum cell extent so layout decisions depend on available width rather than device labels. `PopScope` compares the current form fields with the values that existed when the form opened, and only asks for confirmation when those values changed. The `Countdown` sealed class makes the upcoming, started, and ended states exhaustive at the point where they are rendered. With the tools from week 9, persistent storage and automated tests could be added without changing the app's main navigation design.

## Suggested commit sequence for the defence requirement

Create at least twelve meaningful commits as you add the supplied groups of files. Example messages:

1. `Add immutable book and profile models`
2. `Seed twelve reading club books`
3. `Add date and time formatting helpers`
4. `Add local category cover assets`
5. `Build reusable book cards and empty states`
6. `Add searchable book list and genre filters`
7. `Add favourites tab`
8. `Add editable reader profile and theme settings`
9. `Add app shell navigation and drawer actions`
10. `Add book detail, borrower actions, and countdown`
11. `Add validated create and edit book form`
12. `Configure routes, assets, and app entry point`
