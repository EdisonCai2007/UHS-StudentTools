import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:wolfpackapp/models_services/teachassist_model.dart';
import 'package:wolfpackapp/misc/timeConstants.dart';

import '../../no_account_dialog.dart';

class ScheduleOverviewContainer extends StatefulWidget {
  const ScheduleOverviewContainer({super.key});

  @override
  State<ScheduleOverviewContainer> createState() =>
      _ScheduleOverviewContainerState();
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
    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted) {
        setState(() {
          twelveHrTime = DateFormat.jm().format(DateTime.now());
          minuteTime = (DateTime.now().hour * 60) + DateTime.now().minute;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: const BorderRadius.all(Radius.elliptical(20, 20)),
        boxShadow: const [BoxShadow(blurRadius: 5)],
      ),
      margin: const EdgeInsets.only(
        top: 20,
        left: 30,
        right: 30,
      ),
      padding: const EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
      ),
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
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Container(
                      alignment: Alignment.topLeft,
                      child: FittedBox(
                        fit: BoxFit.fitHeight,
                        child: Text(TimeConstants().getPeriod(minuteTime),
                            style: GoogleFonts.roboto(
                                fontSize: 70, fontWeight: FontWeight.w800)),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Container(
                      width: 10,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.tertiary,
                        borderRadius:
                            const BorderRadius.all(Radius.elliptical(10, 10)),
                      ),
                      alignment: Alignment.center,
                      height: 40,
                      width: 120,
                      margin: const EdgeInsets.all(5),
                      padding: const EdgeInsets.all(5),
                      child: FittedBox(
                        fit: BoxFit.fitHeight,
                        child: Text(" $twelveHrTime ",
                            style: GoogleFonts.roboto(
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
              border: Border.all(
                width: 3,
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ),
            child: LinearPercentIndicator(
              padding: EdgeInsets.zero,
              lineHeight: 10,
              backgroundColor: Theme.of(context).colorScheme.tertiary,
              percent: TimeConstants().getPeriodProgress(minuteTime),
              linearGradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.center,
                colors: <Color>[
                  Theme.of(context).colorScheme.secondary,
                  Theme.of(context).colorScheme.secondary,
                ],
              ),
              barRadius: const Radius.circular(15),
            ),
          ),

          /*
          #########################
          #=-=-= Period Info =-=-=#
          #########################
          */
          (TeachAssistModel.courses.isEmpty) ? NoAccountDialog() :
          (TimeConstants().getPeriodClass(minuteTime)[0] == '') ? const SizedBox(height: 60) :
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(TimeConstants().getPeriodClass(minuteTime)[0],
                      style: GoogleFonts.roboto(
                          fontSize: 20, fontWeight: FontWeight.w800)),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                              TimeConstants().getPeriodClass(minuteTime)[1],
                              style: GoogleFonts.roboto(
                                  fontSize: 16, fontWeight: FontWeight.w600)),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                              TimeConstants().getPeriodClass(minuteTime)[2],
                              style: GoogleFonts.roboto(
                                  fontSize: 14, fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
