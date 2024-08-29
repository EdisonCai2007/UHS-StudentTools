import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppointmentOverviewContainer extends StatelessWidget {
  const AppointmentOverviewContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: FittedBox (
                fit: BoxFit.scaleDown,
                child: Text('Appointments',
                    style: GoogleFonts.lato(fontSize: 50, fontWeight: FontWeight.w900)),
              ),
            ),

            const SizedBox(height: 30,),

            FittedBox (
              fit: BoxFit.scaleDown,
              child: Text('You have no appointments today',
                style: GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.w500)),
            ),
          ],
      ),
    );
  }
}
