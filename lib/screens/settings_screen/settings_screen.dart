import 'package:flutter/material.dart';

import '../../menu_drawer.dart';


class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*
      ####################
      #=-=-= AppBar =-=-=#
      ####################
      */
      appBar: AppBar(
          title: const Text('Settings'),
          centerTitle: true,
          foregroundColor: Theme.of(context).colorScheme.onSurface
      ),

      /*
      #########################
      #=-=-= Menu Drawer =-=-=#
      #########################
      */
      drawer: const MenuDrawer(),
    );
  }
}
