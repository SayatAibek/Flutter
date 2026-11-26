import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/api/api_exception.dart';
import '../settings/settings_model.dart';
import '../settings/settings_screen.dart';
import 'user_create_screen.dart';
import 'user_detail_screen.dart';
import 'users_model.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final m = context.watch<UsersModel>();
    final shown = m.visible(context.watch<SettingsModel>().city);

    if (m.loading && m.items.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Users')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final Widget body;
    final error = m.error;
    if (error != null) {
      switch (error) {
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
        case NotFoundException():
          body = const Center(child: Text('Not Found'));
        case UnauthorizedException():
          body = const Center(child: Text('Unauthorized'));
        case BadResponseException():
          body = const Center(child: Text('Bad Response from server'));
      }
    } else if (shown.isEmpty) {
      body = const Center(child: Text('No users found'));
    } else {
      body = RefreshIndicator(
        onRefresh: m.load,
        child: ListView.separated(
          itemCount: shown.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            final user = shown[index];
            return ListTile(
              title: Text(user.name),
              subtitle: Text('${user.email} • ${user.address.city}'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => UserDetailScreen(user: user)),
              ),
            );
          },
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const UserCreateScreen()),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          if (m.fromCache)
            MaterialBanner(
              content: const Text('Saved data · no connection'),
              actions: [
                TextButton(onPressed: m.load, child: const Text('Retry')),
              ],
            ),
          Expanded(child: body),
        ],
      ),
    );
  }
}
