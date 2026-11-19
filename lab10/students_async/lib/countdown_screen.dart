import 'dart:async';
import 'package:flutter/material.dart';
import 'api/countdown.dart';

class CountdownScreen extends StatefulWidget {
  const CountdownScreen({super.key});

  @override
  State<CountdownScreen> createState() => _CountdownScreenState();
}

class _CountdownScreenState extends State<CountdownScreen> {
  int _tab = 0; // 0 — Version A (StreamBuilder), 1 — Version B (Subscription)

  // Версия A
  late final Stream<int> _stream = countdown(10);

  // Версия B
  int _left = 10;
  late StreamSubscription<int> _sub;

  @override
  void initState() {
    super.initState();
    _sub = countdown(10).listen((i) => setState(() => _left = i));
  }

  @override
  void dispose() {
    _sub.cancel(); // Обязательная отмена подписки для Version B
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Countdown'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: SegmentedButton<int>(
            segments: const [
              ButtonSegment(value: 0, label: Text('Version A (StreamBuilder)')),
              ButtonSegment(value: 1, label: Text('Version B (Listen)')),
            ],
            selected: {_tab},
            onSelectionChanged: (val) => setState(() => _tab = val.first),
          ),
        ),
      ),
      body: Center(
        child: _tab == 0
            ? StreamBuilder<int>(
                stream: _stream,
                builder: (context, snapshot) {
                  final val = snapshot.data ?? 10;
                  return Text('$val', style: const TextStyle(fontSize: 80));
                },
              )
            : Text('$_left', style: const TextStyle(fontSize: 80)),
      ),
    );
  }
}