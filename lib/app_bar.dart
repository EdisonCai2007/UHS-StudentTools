import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '/themes/theme_manager.dart';


class DefaultAppBar extends AppBar {

  String titleValue = "";

  void setTitle(String titleStr) {
    titleValue = titleStr;
  }

  Widget build(BuildContext context) {
    return AppBar(
      title: Text(titleValue, style: GoogleFonts.lato(fontSize: 25)),
      foregroundColor: Theme.of(context).colorScheme.onSurface,
      centerTitle: true,
      actions: [
        IconButton(
            onPressed: () => {
              Provider.of<ThemeManager>(context, listen: false).toggleThemeMode(),
            },
            icon: const Icon(Icons.dark_mode))
      ],
    );
  }
}
