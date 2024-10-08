import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wolfpackapp/misc/page_navigator.dart';
import 'package:wolfpackapp/models_services/events_model.dart';
import 'package:wolfpackapp/misc/month_converter.dart';
import 'package:wolfpackapp/misc/time_converter.dart';
import 'package:intl/intl.dart';
import '/menu_drawer.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  late Future<void> _initEvents;
  late List<EventDetails> _events = EventsModel.events;
  final _searchController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  bool clearCheck = true;

  @override
  void initState() {
    super.initState();

    _initEvents = EventsModel().init().then((_) {
      setState(() {
        _events = EventsModel.events;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) => PageNavigator.backButton(context),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,

        appBar: AppBar(
          title: Text('Events', style: GoogleFonts.lato(fontSize: 20)),
          foregroundColor: Theme.of(context).colorScheme.onSurface,
          centerTitle: true,
        ),

        drawer: const MenuDrawer(),

        body: FutureBuilder<void>(
            future: _initEvents,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.secondary,
                ));
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Padding(padding: EdgeInsets.only(bottom: 30)),

                  // -=-  Search Bar  -=-
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: const BorderRadius.all(Radius.elliptical(10, 10)),
                        boxShadow: const [BoxShadow(blurRadius: 5)],
                      ),
                      child: Column(
                        children: [
                          // -=-  Event Title Filter  -=-
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.fromLTRB(15, 15, 15, 5),
                                  child: TextField(
                                    controller: _searchController,
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(Icons.search),
                                      hintText: 'Search Events',
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Theme.of(context).colorScheme.inversePrimary),
                                      ),
                                    ),
                                    onChanged: _searchBook,
                                  ),
                                ),
                              ),

                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                  backgroundColor: const Color.fromRGBO(0, 0, 0, 0),
                                  shadowColor: const Color.fromRGBO(0, 0, 0, 0),
                                  foregroundColor: Theme.of(context).colorScheme.secondary,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _searchController.clear();
                                    _applyFilters();
                                  });
                                },
                                child: const Icon(Icons.delete_forever),
                              ),
                            ],
                          ),

                          const Padding(padding: EdgeInsets.only(bottom: 10)),

                          // -=-  Event Date Filter  -=-
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Padding(padding: EdgeInsets.only(right: 8)),

                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      tapTargetSize: MaterialTapTargetSize.padded,
                                      backgroundColor: const Color.fromRGBO(0, 0, 0, 0),
                                      shadowColor: const Color.fromRGBO(0, 0, 0, 0),
                                      foregroundColor: Theme.of(context).colorScheme.onSurface,
                                    ),
                                    onPressed: _datePicker,
                                    child: Row(
                                      children: [
                                        const Icon(Icons.edit_calendar),

                                        const Padding(padding: EdgeInsets.only(right: 15)),

                                        clearCheck ? Text(
                                          'No Date Selected',
                                          style: GoogleFonts.roboto(fontSize: 15, fontWeight: FontWeight.w400),
                                        )
                                            : Text(
                                            '${DateFormat('E').format(_selectedDate)}, '
                                                '${MonthConverter.getMonthStr(int.parse(_selectedDate.toString().substring(5, 7)))!} ${_selectedDate.toString().substring(8, 10)}, '
                                                '${_selectedDate.toString().substring(0, 4)}',
                                            style: GoogleFonts.roboto(fontSize: 15, fontWeight: FontWeight.w400)
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  shape: const CircleBorder(),
                                  backgroundColor: const Color.fromRGBO(0, 0, 0, 0),
                                  shadowColor: const Color.fromRGBO(0, 0, 0, 0),
                                  foregroundColor: Theme.of(context).colorScheme.secondary,
                                ),
                                onPressed: () {
                                  setState(() {
                                    clearCheck = true;
                                    _applyFilters();
                                  });
                                },
                                child: const Icon(Icons.delete_forever),
                              ),
                            ],
                          ),

                          const Padding(padding: EdgeInsets.only(bottom: 10)),
                        ],
                      ),
                    ),
                  ),

                  const Padding(padding: EdgeInsets.only(bottom: 30)),

                  // -=-  Events List  -=-
                  _events.isNotEmpty ? Expanded(
                    flex: 1,
                    child: ListView.builder(
                      physics: const ClampingScrollPhysics(),
                      itemCount: _events.length,
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
                                    _events[index].title,
                                    overflow: TextOverflow.visible,
                                    style: GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.w800)
                                ),

                                const Padding(padding: EdgeInsets.only(top: 15)),

                                // -=-  Event Start Date/Time  -=-
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${DateFormat('E').format(DateTime.parse(_events[index].startDate))}, '
                                          '${MonthConverter.getMonthStr(int.parse(_events[index].startDate.substring(5, 7)))!} ${_events[index].startDate.substring(8)}, '
                                          '${_events[index].startDate.substring(0, 4)}',
                                      style: GoogleFonts.roboto(fontSize: 15, fontWeight: FontWeight.w400),
                                    ),

                                    Text(
                                      TimeConverter.get12Format(_events[index].startTime),
                                      style: GoogleFonts.roboto(fontSize: 15, fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),

                                // -=-  Event Start Date/Time  -=-
                                if (_events[index].endTime != '' || _events[index].endDate != _events[index].startDate && !(_events[index].title.toLowerCase().contains('day') && DateTime.parse(_events[index].endDate).difference(DateTime.parse(_events[index].startDate)).inDays <= 1)) const Padding(padding: EdgeInsets.only(top: 5)),

                                if (_events[index].endTime != '' || _events[index].endDate != _events[index].startDate && !(_events[index].title.toLowerCase().contains('day') && DateTime.parse(_events[index].endDate).difference(DateTime.parse(_events[index].startDate)).inDays <= 1)) Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    _events[index].endDate != _events[index].startDate ? Text(
                                      '${DateFormat('E').format(DateTime.parse(_events[index].endDate))}, ${MonthConverter.getMonthStr(int.parse(_events[index].endDate.substring(5, 7)))!} ${_events[index].endDate.substring(8)}, ${_events[index].endDate.substring(0, 4)}',
                                      style: GoogleFonts.roboto(fontSize: 15, fontWeight: FontWeight.w400),
                                    ) : const Text(''),

                                    Text(
                                      TimeConverter.get12Format(_events[index].endTime),
                                      style: GoogleFonts.roboto(fontSize: 15, fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),

                                if (_events[index].endTime != '' || _events[index].endDate != _events[index].startDate && !(_events[index].title.toLowerCase().contains('day') && DateTime.parse(_events[index].endDate).difference(DateTime.parse(_events[index].startDate)).inDays <= 1)) const Padding(padding: EdgeInsets.only(bottom: 10)),

                                // -=-  Time Remaining  -=-
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                      padding: const EdgeInsets.only(top: 3, bottom: 3, left: 5, right: 5),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).colorScheme.background.withOpacity(0.6),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: (DateTime.parse(_events[index].startDate).difference(DateTime.now()).inHours / 24).ceil() > 1
                                          ? Text('${(DateTime.parse(_events[index].startDate).difference(DateTime.now()).inHours / 24).ceil()} Days Remaining', style: GoogleFonts.roboto(fontSize: 10, fontWeight: FontWeight.w500, color: Colors.redAccent))
                                          : (DateTime.parse(_events[index].startDate).difference(DateTime.now()).inHours / 24).ceil() == 1
                                          ? Text('Tomorrow', style: GoogleFonts.roboto(fontSize: 10, fontWeight: FontWeight.w500, color: Colors.redAccent))
                                          : (DateTime.parse(_events[index].startDate).difference(DateTime.now()).inHours / 24).ceil() == 0
                                          ? Text('Today', style: GoogleFonts.roboto(fontSize: 10, fontWeight: FontWeight.w500, color: Colors.redAccent))
                                          : Text('The Past', style: GoogleFonts.roboto(fontSize: 10, fontWeight: FontWeight.w500, color: Colors.redAccent))
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  )
                      : Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Filters Result in No Events...',
                      style: GoogleFonts.roboto(
                        fontSize: 20,
                        fontWeight: FontWeight.w300,
                        fontStyle: FontStyle.italic,
                      ),
                      overflow: TextOverflow.visible,
                    ),
                  ),
                ],
              );
            }
        ),
      ),
    );
  }

  void _datePicker() {
    showDatePicker(
        context: context,
        firstDate: DateTime.now(),
        lastDate: DateTime.parse(EventsModel.events.last.startDate),
    ).then((value) => {
      if (value != null) {
        setState(() {
          _selectedDate = value;
          clearCheck = false;

          _applyFilters();
        })
      }
    });
  }

  void _searchBook(String query) {
    setState(() {
      _applyFilters();
    });
  }

  void _applyFilters() {
    String query = _searchController.text.toLowerCase();

    final searchResults = EventsModel.events.where((event) {
      final eventTitle = event.title.toLowerCase();
      final matchesSearch = eventTitle.contains(query);

      final selectedDateStr = _selectedDate.toString().substring(0, 10);
      final matchesDate = clearCheck
          || (selectedDateStr == event.startDate
              || selectedDateStr == event.endDate
              || (DateTime.parse(selectedDateStr).isAfter(DateTime.parse(event.startDate))
                  && DateTime.parse(selectedDateStr).isBefore(DateTime.parse(event.endDate))));

      return matchesSearch && matchesDate;
    }).toList();

    setState(() => _events = searchResults);
  }
}