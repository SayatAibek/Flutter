import 'package:flutter/material.dart';
import 'user.dart';

class UserDetailScreen extends StatelessWidget {
  const UserDetailScreen({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
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
          ),
          ListTile(
            title: const Text('Phone'),
            subtitle: Text(user.phone),
          ),
          ListTile(
            title: const Text('Website'),
            subtitle: Text(user.website ?? 'None'),
          ),
          ListTile(
            title: const Text('Company'),
            subtitle: Text('${user.company.name} (${user.company.catchPhrase})'),
          ),
          ListTile(
            title: const Text('Address'),
            subtitle: Text('${user.address.street}, ${user.address.suite}, ${user.address.city} (${user.address.zipcode})'),
          ),
          ListTile(
            title: const Text('Geo Coordinates'),
            subtitle: Text('Lat: ${user.address.geo.lat}, Lng: ${user.address.geo.lng}'),
          ),
        ],
      ),
    );
  }
}