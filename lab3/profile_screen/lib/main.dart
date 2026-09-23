import 'package:flutter/material.dart';

import 'data.dart';
import 'profile_header.dart';
import 'info_row.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('My profile')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const ProfileHeader(name: myName, university: myUniversity),
              const SizedBox(height: 24),
              // Цикл collection-for для вывода всех фактов из data.dart
              for (final fact in facts)
                InfoRow(label: fact.label, value: fact.value),
            ],
          ),
        ),
      ),
    );
  }
}
