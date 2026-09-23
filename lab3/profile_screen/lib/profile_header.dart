import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String university;

  const ProfileHeader({
    super.key,
    required this.name,
    required this.university,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Картинка профиля
        Image.asset(
          'assets/images/my_photo.jpg',
          height: 120,
          width: 120,
          fit: BoxFit.cover,
        ),
        const SizedBox(height: 12),
        // имя с кастомным шрифтом
        Text(
          name,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            fontFamily: 'CustomFont', 
          ),
        ),
        const SizedBox(height: 4),
        // универ
        Text(university, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}
