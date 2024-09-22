import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wolfpackapp/models_services/events_model.dart';
import 'package:wolfpackapp/models_services/month_converter.dart';
import 'package:wolfpackapp/models_services/time_converter.dart';

import '/menu_drawer.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  List<EventDetails> events = EventsModel.events;

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    print(events.length);
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
                        Text(
                          maxLines: 3,
                          events[index].title,
                          overflow: TextOverflow.visible,
                          style: GoogleFonts.roboto(fontSize: 15, fontWeight: FontWeight.w800)
                        ),

                        const Padding(padding: EdgeInsets.only(top: 15)),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${MonthConverter.getMonthStr(int.parse(events[index].startDate.substring(5, 7)))!} ${events[index].startDate.substring(8)}, ${events[index].startDate.substring(0, 4)}',
                              style: GoogleFonts.roboto(fontSize: 15, fontWeight: FontWeight.w400),
                            ),
                            Text(
                              TimeConverter.get12Format(events[index].startTime),
                              style: GoogleFonts.roboto(fontSize: 15, fontWeight: FontWeight.w400),
                            ),
                          ],
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