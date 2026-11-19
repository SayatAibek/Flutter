import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({
    required this.icon,
    required this.message,
    this.buttonLabel,
    this.onPressed,
    super.key,
  });

  final IconData icon;
  final String message;
  final String? buttonLabel;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(icon, size: 48, color: colors.secondary),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            if (buttonLabel != null && onPressed != null) ...<Widget>[
              const SizedBox(height: 12),
              FilledButton(onPressed: onPressed, child: Text(buttonLabel ?? '')),
            ],
          ],
        ),
      ),
    );
  }
}
