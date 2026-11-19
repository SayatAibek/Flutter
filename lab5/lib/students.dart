
Student(
    name: 'Yerlan Sadyk',
    group: 'IT-2305',
    email: 'yerlan@kbtu.kz',
  ),
];



Файл 2 — lib/routes.dart
Здесь названия маршрутов для перехода между экранами.

abstract final class Routes {
  static const students = '/';
  static const student = '/student';
  static const edit = '/edit';
}