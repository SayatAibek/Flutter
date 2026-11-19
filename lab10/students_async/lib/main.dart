import 'package:flutter/material.dart';
import 'students_screen.dart';
import 'students_future_screen.dart';
import 'countdown_screen.dart';
import 'api/fake_api.dart';

void main() {
  // Эксперименты Level 1 для консоли
  print('A');
  Future.delayed(const Duration(seconds: 2), () => print('B'));
  print('C');
  final api = FakeApi();
  api.fetchStudents().then((l) => print('${l.length} students'));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Practice 10: The Data Arrives Later')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const StudentsScreen()),
              ),
              child: const Text('By hand (Level 2 & 5)'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const StudentsFutureScreen()),
              ),
              child: const Text('FutureBuilder (Level 3)'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CountdownScreen()),
              ),
              child: const Text('Countdown (Level 4)'),
            ),
          ],
        ),
      ),
    );
  }
}