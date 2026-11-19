import 'package:flutter/material.dart';
import 'api/fake_api.dart';
import 'widgets/loading_view.dart';
import 'widgets/error_view.dart';
import 'widgets/empty_view.dart';
import 'widgets/student_list.dart';

class StudentsScreen extends StatefulWidget {
  const StudentsScreen({super.key});

  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  List<Student>? _students;
  Object? _error;
  final _api = FakeApi();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _load(); // Синхронный вызов без await
  }

  Future<void> _load() async {
    setState(() {
      _students = null;
      _error = null;
    });
    try {
      final list = await _api.fetchStudents();
      if (!mounted) return;
      setState(() => _students = list);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e);
    }
  }

  Future<void> _saveData() async {
    if (_students == null || _students!.isEmpty) return;
    setState(() => _saving = true);
    try {
      await _api.save(_students!.length);
      if (!mounted) return;
      Navigator.pop(context);
    } on StateError catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    if (_error != null) {
      body = ErrorView(onRetry: _load);
    } else if (_students == null) {
      body = const LoadingView();
    } else if (_students!.isEmpty) {
      body = const EmptyView();
    } else {
      body = StudentList(_students!);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Students (By Hand)')),
      body: body,
      floatingActionButton: (_students != null && _students!.isNotEmpty)
          ? FloatingActionButton(
              onPressed: _saving ? null : _saveData,
              child: _saving
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Icon(Icons.save),
            )
          : null,
    );
  }
}