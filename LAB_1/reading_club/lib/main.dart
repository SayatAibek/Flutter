import 'package:flutter/material.dart';

import 'models/book.dart';
import 'routes.dart';
import 'screens/detail_screen.dart';
import 'screens/form_screen.dart';
import 'screens/shell_screen.dart';

void main() => runApp(const ReadingClubApp());

class ReadingClubApp extends StatefulWidget {
  const ReadingClubApp({super.key});

  @override
  State<ReadingClubApp> createState() => _ReadingClubAppState();
}

class _ReadingClubAppState extends State<ReadingClubApp> {
  ThemeMode _themeMode = ThemeMode.system;
  final ValueNotifier<ThemeMode> _themeModeNotifier = ValueNotifier<ThemeMode>(ThemeMode.system);

  void _setThemeMode(ThemeMode mode) {
    setState(() => _themeMode = mode);
    _themeModeNotifier.value = mode;
  }

  @override
  void dispose() {
    _themeModeNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final seed = ThemeData().colorScheme.primary;
    return MaterialApp(
      title: 'Reading Club',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: seed),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: seed,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: _themeMode,
      initialRoute: Routes.shell,
      routes: <String, WidgetBuilder>{
        Routes.shell: (context) => ShellScreen(
              themeModeListenable: _themeModeNotifier,
              onThemeModeChanged: _setThemeMode,
            ),
      },
      onGenerateRoute: (settings) {
        if (settings.name == Routes.detail && settings.arguments is DetailRouteArgs) {
          final args = settings.arguments as DetailRouteArgs;
          return MaterialPageRoute<void>(
            settings: settings,
            builder: (context) => DetailScreen(args: args),
          );
        }
        if (settings.name == Routes.form && settings.arguments is FormRouteArgs) {
          final args = settings.arguments as FormRouteArgs;
          return MaterialPageRoute<Book>(
            settings: settings,
            builder: (context) => FormScreen(initial: args.initial),
          );
        }
        return null;
      },
      onUnknownRoute: (settings) => MaterialPageRoute<void>(
        settings: settings,
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text('Not found')),
          body: const Center(child: Text('Not found')),
        ),
      ),
    );
  }
}
