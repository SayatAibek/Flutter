import '../../core/api/api_client.dart';
import '../../core/api/api_exception.dart';
import 'user.dart';

class UserRepository {
  UserRepository(this._api);

  final ApiClient _api;

  Future<List<User>> getAll() async {
    try {
      final data = await _api.get('/users');
      final list = data as List<dynamic>;
      return list.map((item) => User.fromJson(item as Map<String, dynamic>)).toList();
    } catch (e) {
      if (e is ApiException) rethrow;
      throw BadResponseException('getAll: $e');
    }
  }

  Future<User> getById(int id) async {
    try {
      final data = await _api.get('/users/$id');
      return User.fromJson(data as Map<String, dynamic>);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw BadResponseException('getById($id): $e');
    }
  }

  Future<User> create(User draft) async {
    try {
      final data = await _api.post('/users', body: draft.toJson());
      return User.fromJson(data as Map<String, dynamic>);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw BadResponseException('create: $e');
    }
  }
}