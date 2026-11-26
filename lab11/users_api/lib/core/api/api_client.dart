import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:http/http.dart' as http;

import '../storage/secure_store.dart';
import 'api_exception.dart';

class ApiClient {
  ApiClient(
    this._client,
    this._store, {
    this.host = 'jsonplaceholder.typicode.com',
  });

  final http.Client _client;
  final SecureStore _store;
  final String host;

  Future<Map<String, String>> _headers() async => {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
    if (await _store.readToken() case final t?) 'Authorization': 'Bearer $t',
  };

  Future<http.Response> _send(Future<http.Response> Function() call) async {
    try {
      final response = await call().timeout(const Duration(seconds: 10));
      developer.log(
        '${response.statusCode} ${response.request?.url}',
        name: 'api',
      );
      return response;
    } on SocketException {
      throw const NoConnectionException();
    } on TimeoutException {
      throw const NoConnectionException();
    }
  }

  void _check(http.Response r) {
    if (r.statusCode == 401) {
      throw const UnauthorizedException();
    }
    if (r.statusCode == 404) {
      throw const NotFoundException();
    }
    if (r.statusCode >= 500) {
      throw ServerException(r.statusCode);
    }
  }

  dynamic _decode(http.Response r) {
    try {
      return jsonDecode(r.body);
    } on FormatException catch (e) {
      throw BadResponseException(e.toString());
    }
  }

  Future<dynamic> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) async {
    final uri = Uri.https(host, endpoint, queryParameters);
    final response = await _send(
      () async => _client.get(uri, headers: await _headers()),
    );
    _check(response);
    return _decode(response);
  }

  Future<dynamic> post(String endpoint, {Object? body}) async {
    final uri = Uri.https(host, endpoint);
    final response = await _send(
      () async => _client.post(
        uri,
        headers: await _headers(),
        body: body != null ? jsonEncode(body) : null,
      ),
    );
    _check(response);
    return _decode(response);
  }
}
