import 'package:flutter/material.dart';

// Home Screen Page; Holds The Many Crucial Widgets and Announcements
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Home',
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
        centerTitle: true,
      ),

      body: Text("Yar"),
    );
  }
}
