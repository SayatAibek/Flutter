import 'package:flutter/foundation.dart';
class Student {
  const Student({
    required this.name,
    required this.group,
    this.gpa,
  });
  final String name;
  final String group;
  final double? gpa;
}

class NoConnectionException implements Exception {}

const _seed = [
  Student(name: 'Aida Nurlanova', group: 'IT-2301', gpa: 3.7),
  Student(name: 'Dias Seitkali', group: 'IT-2301', gpa: 3.1),
  Student(name: 'Aruzhan Bek', group: 'IT-2302'),
  Student(name: 'Timur Alibekov', group: 'IT-2302', gpa: 2.9),
  Student(name: 'Dana Omarova', group: 'IT-2303', gpa: 3.9),
  Student(name: 'Alikhan Kairatuly', group: 'IT-2303', gpa: 3.4),
];

class FakeApi {
  FakeApi({this.empty = false});
  final bool empty;   // true -> на сервере нет студентов
  int calls = 0;      // счетчик вызовов fetchStudents()

  Future<List<Student>> fetchStudents() async {
    calls++;
    debugPrint('fetchStudents #$calls');
    await Future.delayed(const Duration(seconds: 2));

    // Каждые 3 вызова выбрасываем ошибку соединения
    if (calls % 3 == 0) {
      throw NoConnectionException();
    }

    return empty ? const [] : _seed;
  }

  // Level 5: Метод save, который падает на каждый второй вызов
  Future<void> save(int value) async {
    await Future.delayed(const Duration(seconds: 1));
    if (value % 2 == 0) {
      throw StateError('server rejected $value');
    }
  }
}