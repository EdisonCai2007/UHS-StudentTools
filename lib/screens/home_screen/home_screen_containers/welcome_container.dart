import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:wolfpackapp/misc/shared_prefs.dart';

class WelcomeContainer extends Container {

  //TODO: CHECK IF SINGLE "d" PARAMETER WORKS FOR DOUBLE DIGIT DAYS
  final String date = DateFormat("MMMM d, yyyy").format(DateTime.now());
  final String day = DateFormat("EEEE").format(DateTime.now());

  WelcomeContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      margin: const EdgeInsets.only(
        left: 30,
        right: 30,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Displays "Month Day, Year"
          Text(date,
              style: GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.w500)),
          const SizedBox(height: 3),

          //Displays Day of the Week
          Align(
            alignment: Alignment.centerLeft,
            child: FittedBox (
              fit: BoxFit.scaleDown,
              child: Text(day,
                  style: GoogleFonts.roboto(fontSize: 65, fontWeight: FontWeight.w800)),
            ),
          ),

          const SizedBox(height: 2),
          Text(sharedPrefs.username != '' ? sharedPrefs.username : 'Guest', style: GoogleFonts.roboto(fontSize: 15)),
        ],
      ),
    );
  }
}
