import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wolfpackapp/screens/guidance_screen/appointment_list.dart';


class AppointmentOverviewContainer extends StatefulWidget {
  const AppointmentOverviewContainer({super.key});

  @override
  State<AppointmentOverviewContainer> createState() => _AppointmentOverviewContainerState();
}

class _AppointmentOverviewContainerState extends State<AppointmentOverviewContainer> {
  @override
  void initState() {
    super.initState();

    Timer.periodic(const Duration(seconds: 5), (Timer t) {

      if (mounted) setState(() {});
    });
  }

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

          buildAppointmentList()
        ],
      ),
    );
  }

  Widget buildAppointmentList() {
    if (!appointmentListLoaded && appointmentList.isEmpty) {
      return FittedBox (
        fit: BoxFit.scaleDown,
        child: Text('Loading Appointments...',
          style: GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.w500)),
      );
    } else if (appointmentList.isNotEmpty) {
      return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.tertiary,
          borderRadius: const BorderRadius.all(Radius.elliptical(10, 10)),
          boxShadow: const [BoxShadow(blurRadius: 5)],
        ),
        padding: const EdgeInsets.all(15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: Align(
                alignment: Alignment.centerLeft,
                child: FittedBox (
                  fit: BoxFit.scaleDown,
                  child: Text(appointmentList[0]['Name']!,
                    style: GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.w500)),
                ),
              ),
            ),

            const Expanded(
              flex: 1,
              child: SizedBox.shrink()
            ),

            Expanded(
              flex: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  FittedBox (
                    fit: BoxFit.scaleDown,
                    child: Text(appointmentList[0]['Date']!,
                      style: GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.w500)),
                  ),
              
                  Padding(
                    padding: const EdgeInsets.only(top:8),
                    child: FittedBox (
                      fit: BoxFit.scaleDown,
                      child: Text('See More',
                        style: GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.w500)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      return FittedBox (
        fit: BoxFit.scaleDown,
        child: Text('You have no appointments this month',
          style: GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.w500)),
      );
    }
  }
}
