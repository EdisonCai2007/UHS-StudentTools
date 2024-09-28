import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wolfpackapp/models_services/events_model.dart';
import 'package:wolfpackapp/misc/month_converter.dart';
import 'package:wolfpackapp/misc/time_converter.dart';
import 'package:intl/intl.dart';
import 'package:wolfpackapp/misc/shared_prefs.dart';


import '/menu_drawer.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  late List<EventDetails> events = sharedPrefs.eventsData.map((eventJson) {
    Map<String, dynamic> eventMap = jsonDecode(eventJson);
    return EventDetails.fromJson(eventMap);
  }).toList();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,

      appBar: AppBar(
        title: Text('Events', style: GoogleFonts.lato(fontSize: 20)),
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        centerTitle: true,
      ),

      drawer: const MenuDrawer(),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: ListView.builder(
              physics: const ClampingScrollPhysics(),
              itemCount: events.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: const BorderRadius.all(Radius.elliptical(20, 20)),
                      boxShadow: const [BoxShadow(blurRadius: 5)],
                    ),
                    margin: const EdgeInsets.only(
                      top: 10,
                      left: 5,
                      right: 5,
                      bottom: 10,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // -=-  Event Name  -=-
                        Text(
                          maxLines: 3,
                          events[index].title,
                          overflow: TextOverflow.visible,
                          style: GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.w800)
                        ),

                        const Padding(padding: EdgeInsets.only(top: 15)),

                        // -=-  Event Start Date/Time  -=-
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${DateFormat('E').format(DateTime.parse(events[index].startDate))}, '
                                  '${MonthConverter.getMonthStr(int.parse(events[index].startDate.substring(5, 7)))!} ${events[index].startDate.substring(8)}, '
                                  '${events[index].startDate.substring(0, 4)}',
                              style: GoogleFonts.roboto(fontSize: 15, fontWeight: FontWeight.w400),
                            ),

                            Text(
                              TimeConverter.get12Format(events[index].startTime),
                              style: GoogleFonts.roboto(fontSize: 15, fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),

                        // -=-  Event Start Date/Time  -=-
                        if (events[index].endTime != '' || events[index].endDate != events[index].startDate && !(events[index].title.toLowerCase().contains('day') && DateTime.parse(events[index].endDate).difference(DateTime.parse(events[index].startDate)).inDays <= 1)) const Padding(padding: EdgeInsets.only(top: 5)),

                        if (events[index].endTime != '' || events[index].endDate != events[index].startDate && !(events[index].title.toLowerCase().contains('day') && DateTime.parse(events[index].endDate).difference(DateTime.parse(events[index].startDate)).inDays <= 1)) Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            events[index].endDate != events[index].startDate ? Text(
                              '${DateFormat('E').format(DateTime.parse(events[index].endDate))}, ${MonthConverter.getMonthStr(int.parse(events[index].endDate.substring(5, 7)))!} ${events[index].endDate.substring(8)}, ${events[index].endDate.substring(0, 4)}',
                              style: GoogleFonts.roboto(fontSize: 15, fontWeight: FontWeight.w400),
                            ) : const Text(''),

                            Text(
                              TimeConverter.get12Format(events[index].endTime),
                              style: GoogleFonts.roboto(fontSize: 15, fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),

                        if (events[index].endTime != '' || events[index].endDate != events[index].startDate && !(events[index].title.toLowerCase().contains('day') && DateTime.parse(events[index].endDate).difference(DateTime.parse(events[index].startDate)).inDays <= 1)) const Padding(padding: EdgeInsets.only(bottom: 10)),

                        // -=-  Time Remaining  -=-
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            padding: const EdgeInsets.only(top: 3, bottom: 3, left: 5, right: 5),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.background.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: (DateTime.parse(events[index].startDate).difference(DateTime.now()).inHours / 24).ceil() > 1
                                ? Text('${(DateTime.parse(events[index].startDate).difference(DateTime.now()).inHours / 24).ceil()} Days Remaining', style: GoogleFonts.roboto(fontSize: 10, fontWeight: FontWeight.w500, color: Colors.redAccent))
                                : (DateTime.parse(events[index].startDate).difference(DateTime.now()).inHours / 24).ceil() == 1
                                ? Text('Tomorrow', style: GoogleFonts.roboto(fontSize: 10, fontWeight: FontWeight.w500, color: Colors.redAccent))
                                : Text('Today', style: GoogleFonts.roboto(fontSize: 10, fontWeight: FontWeight.w500, color: Colors.redAccent)),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}