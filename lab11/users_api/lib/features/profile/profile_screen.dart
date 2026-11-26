import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../settings/settings_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<void> _pick(ImageSource source) async {
    final x = await ImagePicker().pickImage(
      source: source,
      maxWidth: 1024,
      imageQuality: 85,
    );
    if (x == null) return;
    final dir = await getApplicationDocumentsDirectory();
    final saved = await File(x.path).copy('${dir.path}/avatar.jpg');
    await FileImage(saved).evict();
    if (!mounted) return;
    await context.read<SettingsModel>().setAvatarPath(saved.path);
  }

  Future<void> _takePhoto() async {
    final status = await Permission.camera.request();
    if (!mounted) return;
    switch (status) {
      case PermissionStatus.granted:
      case PermissionStatus.limited:
        await _pick(ImageSource.camera);
      case PermissionStatus.denied:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Camera access is needed to take a photo.'),
          ),
        );
      case PermissionStatus.permanentlyDenied:
      case PermissionStatus.restricted:
      case PermissionStatus.provisional:
        await showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Camera is blocked'),
            content: const Text(
              'The camera is turned off for this app. Allow it in system settings to take a photo.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(ctx);
                  await openAppSettings();
                },
                child: const Text('Open settings'),
              ),
            ],
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final path = context.watch<SettingsModel>().avatarPath;
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: path == null ? null : FileImage(File(path)),
              child: path == null
                  ? const Text('?', style: TextStyle(fontSize: 40))
                  : null,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => _pick(ImageSource.gallery),
              child: const Text('Choose photo'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: _takePhoto,
              child: const Text('Take photo'),
            ),
          ],
        ),
      ),
    );
  }
}
