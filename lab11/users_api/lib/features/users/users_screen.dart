import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/api/api_exception.dart';
import 'user_detail_screen.dart';
import 'user_create_screen.dart';
import 'users_model.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final m = context.watch<UsersModel>();

    if (m.loading && m.items.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Users')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    Widget body;
    if (m.error != null) {
      switch (m.error!) {
        case NoConnectionException():
          body = Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('No internet connection'),
                const SizedBox(height: 12),
                ElevatedButton(onPressed: m.load, child: const Text('Retry')),
              ],
            ),
          );
          break;
        case ServerException(:final status):
          body = Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Server Error: $status'),
                const SizedBox(height: 12),
                ElevatedButton(onPressed: m.load, child: const Text('Retry')),
              ],
            ),
          );
          break;
        case NotFoundException():
          body = const Center(child: Text('Not Found'));
          break;
        case UnauthorizedException():
          body = const Center(child: Text('Unauthorized'));
          break;
        case BadResponseException():
          body = const Center(child: Text('Bad Response from server'));
          break;
      }
    } else if (m.items.isEmpty) {
      body = const Center(child: Text('No users found'));
    } else {
      body = RefreshIndicator(
        onRefresh: m.load,
        child: ListView.separated(
          itemCount: m.items.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            final user = m.items[index];
            return ListTile(
              title: Text(user.name),
              subtitle: Text('${user.email} • ${user.address.city}'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => UserDetailScreen(user: user)),
                );
              },
            );
          },
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Users (Practice 11)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const UserCreateScreen()),
              );
            },
          ),
        ],
      ),
      body: body,
    );
  }
}