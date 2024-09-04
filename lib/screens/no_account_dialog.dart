import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models_services/teachassist_model.dart';
import '../shared_prefs.dart';

class NoAccountDialog extends Container {
  NoAccountDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top:15, right: 15, left: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FittedBox(
            fit: BoxFit.contain,
            child: Text('You\'re Not Signed In',
                style: GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.w900)),
          ),

          FittedBox(
          fit: BoxFit.contain,
          child: Text('Sign In For More Features',
              style: GoogleFonts.lato(fontSize: 12, fontWeight: FontWeight.w400)),
          ),

          FittedBox(
            fit: BoxFit.contain,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: const BorderRadius.all(Radius.elliptical(10, 10)),
              ),
              margin: const EdgeInsets.all(20),
              child: TextButton.icon(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () {
                  sharedPrefs.username = '';
                  sharedPrefs.password = '';
                  TeachAssistModel.clearCourses();
                  Navigator.pushNamed(context, '/loginScreen');
                },
                icon: const Icon(Icons.login),
                label: Text('Sign In',
                  style: GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.w400)
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
