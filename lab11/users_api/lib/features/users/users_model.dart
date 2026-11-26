import 'package:flutter/foundation.dart';

import '../../core/api/api_exception.dart';
import 'user.dart';
import 'user_repository.dart';

class UsersModel extends ChangeNotifier {
  UsersModel(this._repo);

  final UserRepository _repo;

  List<User> items = const [];
  ApiException? error;
  bool loading = false;
  bool fromCache = false;

  List<String> get cities =>
      ({for (final u in items) u.address.city}.toList()..sort());

  List<User> visible(String? city) => city == null
      ? items
      : items.where((u) => u.address.city == city).toList();

  Future<void> load() async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      final r = await _repo.getAll();
      items = r.items;
      fromCache = r.fromCache;
    } on ApiException catch (e) {
      error = e;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<bool> createUser(User draft) async {
    try {
      final newUser = await _repo.create(draft);
      items = [newUser, ...items];
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      error = e;
      notifyListeners();
      return false;
    }
  }
}
