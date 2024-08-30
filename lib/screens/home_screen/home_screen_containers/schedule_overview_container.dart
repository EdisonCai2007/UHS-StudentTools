import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:wolfpackapp/models_services/timeConstants.dart';


class ScheduleOverviewContainer extends StatefulWidget{
  const ScheduleOverviewContainer({super.key});

  @override
  State<ScheduleOverviewContainer> createState() => _ScheduleOverviewContainerState();
}

class _ScheduleOverviewContainerState extends State<ScheduleOverviewContainer> {

  late Timer? timer;
  String twelveHrTime = "";
  int minuteTime = 0;
  
  @override
  void initState() {
    super.initState();
    twelveHrTime = DateFormat.jm().format(DateTime.now());
    minuteTime = (DateTime.now().hour * 60) + DateTime.now().minute;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {

      setState(() {
        twelveHrTime = DateFormat.jm().format(DateTime.now());
        minuteTime = (DateTime.now().hour * 60) + DateTime.now().minute;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: const BorderRadius.all(Radius.elliptical(20, 20)),
        boxShadow: const [
          BoxShadow(blurRadius: 10)
        ],
      ),
      height: 230,
      margin: const EdgeInsets.only(top: 30, left: 30, right: 30,),
      padding: const EdgeInsets.all(20),

      child: Column(
        children: [
          /*
          ###################
          #=-=-= Title =-=-=#
          ###################
          */
          SizedBox(
            height: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 4 ,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Container(
                        alignment: Alignment.topLeft,
                        child: FittedBox(
                          fit: BoxFit.fitHeight,
                          child: Text(TimeConstants().getPeriod(minuteTime),
                            style: GoogleFonts.lato(
                                fontSize: 70, fontWeight: FontWeight.w800)),
                        ),
                      ),
                    ),
                  ),

                  Expanded(
                    flex: 2 ,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Container(
                        width: 10,
                      ),
                    ),
                  ),

                  Expanded(
                    flex: 3 ,
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.tertiary,
                          borderRadius: const BorderRadius.all(Radius.elliptical(10, 10)),
                          boxShadow: const [
                            BoxShadow(blurRadius: 10)
                          ],
                        ),

                        alignment: Alignment.center,
                        height: 40,
                        width: 120,
                        margin: const EdgeInsets.all(5),
                        padding: const EdgeInsets.all(5),
                        child: FittedBox(
                          fit: BoxFit.fitHeight,
                          child: Text(" $twelveHrTime ",
                            style: GoogleFonts.lato(
                                fontSize: 20, fontWeight: FontWeight.w800)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ),

          /*
          ###################
          #=-=-= Slider =-=-=#
          ###################
          */
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
              border: Border.all(
                width: 2,
                color: Theme.of(context).colorScheme.primary
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              child: LinearProgressIndicator(
                minHeight: 20,
                color: Theme.of(context).colorScheme.secondary,
                value: TimeConstants().getPeriodProgress(minuteTime),
              ),
            ),
          ),

          /*
          #########################
          #=-=-= Period Info =-=-=#
          #########################
          */

        ],
      ),
    );
  }
}