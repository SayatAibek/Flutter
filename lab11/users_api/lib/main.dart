import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'core/api/api_client.dart';
import 'features/users/user_repository.dart';
import 'features/users/users_model.dart';
import 'features/users/users_screen.dart';

void main() {
  final apiClient = ApiClient(http.Client());
  final userRepository = UserRepository(apiClient);
  final usersModel = UsersModel(userRepository)..load();

  runApp(
    ChangeNotifierProvider.value(
      value: usersModel,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Users API App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const UsersScreen(),
    );
  }
}