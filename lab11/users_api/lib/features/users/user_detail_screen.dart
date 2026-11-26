import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/storage/secure_store.dart';
import 'user.dart';

class UserDetailScreen extends StatelessWidget {
  const UserDetailScreen({super.key, required this.user});

  final User user;

  Future<void> _open(BuildContext context, Uri uri) async {
    final ok = await launchUrl(uri);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('No app can open this')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final site = user.website;
    return Scaffold(
      appBar: AppBar(title: Text(user.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            title: const Text('Username'),
            subtitle: Text(user.username),
          ),
          ListTile(
            title: const Text('Email'),
            subtitle: Text(user.email),
            trailing: const Icon(Icons.mail_outline),
            onTap: () =>
                _open(context, Uri(scheme: 'mailto', path: user.email)),
          ),
          ListTile(
            title: const Text('Phone'),
            subtitle: Text(user.phone),
            trailing: const Icon(Icons.phone),
            onTap: () =>
                _open(context, Uri(scheme: 'tel', path: user.phoneDigits)),
          ),
          ListTile(
            title: const Text('Website'),
            subtitle: Text(site ?? 'None'),
            trailing: const Icon(Icons.open_in_new),
            onTap: site == null
                ? null
                : () => _open(context, Uri.parse('https://$site')),
          ),
          ListTile(
            title: const Text('Company'),
            subtitle: Text(
              '${user.company.name} (${user.company.catchPhrase})',
            ),
          ),
          ListTile(
            title: const Text('Address'),
            subtitle: Text(
              '${user.address.street}, ${user.address.suite}, ${user.address.city} (${user.address.zipcode})',
            ),
          ),
          ListTile(
            title: const Text('Geo Coordinates'),
            subtitle: Text(
              'Lat: ${user.address.geo.lat}, Lng: ${user.address.geo.lng}',
            ),
          ),
          if (kDebugMode)
            TextButton(
              onPressed: () async {
                final store = context.read<SecureStore>();
                final token = await store.readToken();
                if (token == null) return;
                await Clipboard.setData(ClipboardData(text: token));
              },
              child: const Text('Copy token to clipboard'),
            ),
        ],
      ),
    );
  }
}
