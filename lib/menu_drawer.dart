import 'package:flutter/material.dart';


class MenuDrawer extends Drawer {
  const MenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const BeveledRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20)),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon (change later to an actually icon)
          const DrawerHeader(
            child: Text(
              '\nWolf Pack App V2\n   (Better Edition)',
              style: TextStyle(fontSize: 30),
            ),
          ),

          // Home page button
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('H O M E'),
            onTap: () {
              Navigator.pushNamed(context, '/homeScreen');
            },
          ),

          // Settings button
          ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('S E T T I N G S'),
            onTap: () {
              Navigator.pushNamed(context, '/settingsScreen');
            },
          ),
        ],
      ),
    );
  }
}
