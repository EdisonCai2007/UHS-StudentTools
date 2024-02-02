import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../themes/theme_manager.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Settings'),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () => {
                      Provider.of<ThemeManager>(context, listen: false)
                          .toggleThemeMode(),
                    },
                icon: const Icon(Icons.dark_mode))
          ],
          foregroundColor: Theme.of(context).colorScheme.onSurface),
    );
  }
}
