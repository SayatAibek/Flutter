import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path_provider/path_provider.dart';
import 'user.dart';

class UsersCache {
  Future<File> _file() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/users.json');
  }

  Future<void> save(List<User> list) async {
    if (kIsWeb) return; // в браузере нет файловой системы
    final f = await _file();
    await f.writeAsString(jsonEncode([for (final u in list) u.toJson()]));
  }

  Future<List<User>?> load() async {
    if (kIsWeb) return null;
    final f = await _file();
    if (!await f.exists()) return null;
    final raw = jsonDecode(await f.readAsString()) as List<dynamic>;
    return [for (final e in raw) User.fromJson(e as Map<String, dynamic>)];
  }
}