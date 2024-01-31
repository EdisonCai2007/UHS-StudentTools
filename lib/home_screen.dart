import "package:flutter/material.dart";

// Home Screen Page; Holds The Many Crucial Widgets and Announcements
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "Home",
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface)
        ),
        shadowColor: Colors.black,
        elevation: 5,
        centerTitle: true,
      ),

      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).colorScheme.primary,
        shadowColor: Colors.black,
        elevation: 50,
        height: 60,
        child: Center(
          child: Text(
            "Nav Bar Placeholder Text",
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          ),
        ),
      ),

      body: const Text("Yar"),
    );
  }
}
