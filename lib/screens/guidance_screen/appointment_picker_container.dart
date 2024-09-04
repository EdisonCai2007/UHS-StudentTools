import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:html/dom.dart' as dom;

import '../../models_services/teachassist_model.dart';
import '../../shared_prefs.dart';
import '../no_account_dialog.dart';

class AppointmentPickerContainer extends StatefulWidget {
  const AppointmentPickerContainer({super.key});

  @override
  State<AppointmentPickerContainer> createState() =>
      _AppointmentPickerContainerState();
}

class _AppointmentPickerContainerState
    extends State<AppointmentPickerContainer> {
  dom.Document guidanceDateHtmlData = dom.Document();
  dom.Document guidanceTimeHtmlData = dom.Document();
  List dateSchedule = [];

  final searchController = TextEditingController();

  Future<void> _fetchGuidanceDate(date) async {
    guidanceDateHtmlData = await fetchGuidanceDate(
        sharedPrefs.username, sharedPrefs.password, date);
  }

  Future<void> _fetchGuidanceTime(counselor, i) async {
    guidanceTimeHtmlData = await fetchGuidanceTime(
        sharedPrefs.username, sharedPrefs.password,
        dateSchedule[counselor]['data'][i].substring(dateSchedule[counselor]['data'][i].indexOf('?')+1,dateSchedule[counselor]['data'][i].indexOf('>')-1).replaceAll('&amp;', '&')
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: const BorderRadius.all(Radius.elliptical(20, 20)),
          boxShadow: const [BoxShadow(blurRadius: 10)],
        ),
        padding: const EdgeInsets.only(top: 30, left: 30, right: 30),
        child: (TeachAssistModel.courses.isEmpty) ? Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: NoAccountDialog(),
            ),
          ],
        ) :
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text('Book an Appointment',
                  style: GoogleFonts.lato(
                      fontSize: 30, fontWeight: FontWeight.w800)),
            ),
            const SizedBox(
              height: 30,
            ),
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Select a Date',
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.inversePrimary),
                ),
              ),
              onTap: selectDate,
            ),
            searchController.text != ''
                ? dateSchedule.isEmpty
                    ? SizedBox(
                        height: 100,
                        child: Align(
                          alignment: Alignment.center,
                          child: Text('NOT A SCHOOL DAY',
                              style: GoogleFonts.lato(
                                  fontSize: 20, fontWeight: FontWeight.w800)),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30),
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            child:
                                Row(children: buildDateSchedule(dateSchedule))),
                      )
                : const SizedBox(
                    height: 30,
                  ),
          ],
        ),
      ),
    );
  }

  Future<void> selectDate() async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      await _fetchGuidanceDate(selectedDate.toString().split(" ")[0]);
      dateSchedule = [];
      setState(() {
        for (final data in guidanceDateHtmlData
            .querySelectorAll('body > div > div.box.blue > div')
            .map((element) => element.innerHtml.trim())
            .toList()) {
          dateSchedule.add({'data': data.split('\n'), 'type': 'guidance'});
        }
        for (final data in guidanceDateHtmlData
            .querySelectorAll('body > div > div.box.yellow > div')
            .map((element) => element.innerHtml.trim())
            .toList()) {
          dateSchedule.add({'data': data.split('\n'), 'type': 'teacher'});
        }
        searchController.text = selectedDate.toString().split(" ")[0];
      });
    }
  }

  List<Widget> buildDateSchedule(dateSchedule) {
    List<Widget> columns = [];
    List checkListItems = [];

    for (int counselor = 0; counselor < dateSchedule.length; counselor++) {
      columns.add(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          decoration: BoxDecoration(
              border: Border(
                right: BorderSide(
                  color: Theme.of(context).colorScheme.secondary,
                  width: 1.5,
                ),
              ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              dateSchedule[counselor]['type'] == 'guidance' ?
              Text(
                  '${dateSchedule[counselor]['data'][0].substring(4, dateSchedule[counselor]['data'][0].indexOf(':'))}'
                  '${dateSchedule[counselor]['data'][0].substring(dateSchedule[counselor]['data'][0].indexOf('('), dateSchedule[counselor]['data'][0].indexOf('.'))}',
                  style: GoogleFonts.lato(
                      fontSize: 14, fontWeight: FontWeight.w900)) :

              Text(
                  '${dateSchedule[counselor]['data'][0].substring(4, dateSchedule[counselor]['data'][0].indexOf(':')+1)}\n'
                  '${dateSchedule[counselor]['data'][0].substring(dateSchedule[counselor]['data'][0].indexOf(':')+2, dateSchedule[counselor]['data'][0].indexOf('<',4))}',
                  style: GoogleFonts.lato(
                      fontSize: 14, fontWeight: FontWeight.w900)),

              (dateSchedule[counselor]['data'].length <= 1) ? Padding(
                padding: const EdgeInsets.all(0),
                child: Text('Fully Booked',
                    style: GoogleFonts.lato(
                    fontSize: 14, fontWeight: FontWeight.w400)
                ),
              ) :
              const SizedBox(
                height: 10,
              ),

              for (int i = 1; i < dateSchedule[counselor]['data'].length; i++) TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  dateSchedule[counselor]['data'][i].substring(
                  dateSchedule[counselor]['data'][i].indexOf('tm=')+3,
                  dateSchedule[counselor]['data'][i].indexOf('&amp',dateSchedule[counselor]['data'][i].indexOf('tm=')+3)-3),
                  style: GoogleFonts.lato(
                      fontSize: 14, fontWeight: FontWeight.w400)
                ),
                onPressed: () async {
                  if (dateSchedule[counselor]['type'] == 'guidance') {
                    await _fetchGuidanceTime(counselor, i);

                    final labels = guidanceTimeHtmlData
                        .querySelectorAll('body > div > form > label')
                        .map((element) => element.innerHtml.trim())
                        .toList();
                    final values = guidanceTimeHtmlData
                        .querySelectorAll('body > div > form > input')
                        .map((element) => element.attributes['value']!)
                        .toList();

                    checkListItems = [];
                    for (int j = 0; j < labels.length; j++) {
                      checkListItems.add({
                        'label': labels[j],
                        'value': values[j + 6],
                        'selected': false,
                      });
                    }

                    if (!context.mounted) return;
                    showDialog(context: context, builder: (context) =>
                        AppointmentOptionAlert(
                          checkListItems: checkListItems,
                          dt: dateSchedule[counselor]['data'][i].substring(dateSchedule[counselor]['data'][i].indexOf('dt=') + 3,
                            dateSchedule[counselor]['data'][i].indexOf('&amp', dateSchedule[counselor]['data'][i].indexOf('dt=') + 3),
                          ),
                          tm: dateSchedule[counselor]['data'][i].substring(dateSchedule[counselor]['data'][i].indexOf('tm=') + 3,
                            dateSchedule[counselor]['data'][i].indexOf('&amp', dateSchedule[counselor]['data'][i].indexOf('tm=') + 3),
                          ),
                          id: dateSchedule[counselor]['data'][i].substring(dateSchedule[counselor]['data'][i].indexOf('id=') + 3,
                            dateSchedule[counselor]['data'][i].indexOf('&amp', dateSchedule[counselor]['data'][i].indexOf('id=') + 3),
                          ),
                          school_id: dateSchedule[counselor]['data'][i].substring(dateSchedule[counselor]['data'][i].indexOf('school_id=') + 10,
                              dateSchedule[counselor]['data'][i].indexOf('">', dateSchedule[counselor]['data'][i].indexOf('school_id=') + 10)
                          ),
                        ));
                  } else {
                    bookGuidanceAppointment(sharedPrefs.username, sharedPrefs.password,

                      dateSchedule[counselor]['data'][i].substring(dateSchedule[counselor]['data'][i].indexOf('dt=') + 3,
                      dateSchedule[counselor]['data'][i].indexOf('&amp',dateSchedule[counselor]['data'][i].indexOf('dt=') + 3)),

                      dateSchedule[counselor]['data'][i].substring(dateSchedule[counselor]['data'][i].indexOf('tm=') + 3,
                      dateSchedule[counselor]['data'][i].indexOf('&amp', dateSchedule[counselor]['data'][i].indexOf('tm=') + 3)),

                      dateSchedule[counselor]['data'][i].substring(dateSchedule[counselor]['data'][i].indexOf('id=') + 3,
                      dateSchedule[counselor]['data'][i].indexOf('&amp', dateSchedule[counselor]['data'][i].indexOf('id=') + 3)),

                      dateSchedule[counselor]['data'][i].substring(dateSchedule[counselor]['data'][i].indexOf('school_id=') + 10,
                      dateSchedule[counselor]['data'][i].indexOf('">', dateSchedule[counselor]['data'][i].indexOf('school_id=') + 10)),
                      null, null, null
                    );
                  }
                },
              )
            ],
          ),
        ),
      );
    }
    return columns;
  }
}

class AppointmentOptionAlert extends StatefulWidget {
  final List checkListItems;
  final String dt;
  final String tm;
  final String id;
  final String school_id;

  const AppointmentOptionAlert({
    super.key,
    required this.checkListItems,
    required this.dt,
    required this.tm,
    required this.id,
    required this.school_id,
  });

  @override
  State<AppointmentOptionAlert> createState() => _AppointmentOptionAlertState();
}

class _AppointmentOptionAlertState extends State<AppointmentOptionAlert> {
  bool withParent = false;
  bool online = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('SELECT AN OPTION'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            children: List.generate(widget.checkListItems.length,
              (index) => CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                dense: true,
                title: Text(widget.checkListItems[index]['label'],
                  style: GoogleFonts.lato(
                  fontSize: 16, fontWeight: FontWeight.w800,
                  color: Theme.of(context).colorScheme.primary)),
                checkboxShape: const CircleBorder(),
                value: widget.checkListItems[index]['selected'],
                onChanged: (value) {
                  setState(() {
                    for (var element in widget.checkListItems) {
                      element['selected'] = false;
                    }
                    widget.checkListItems[index]['selected'] = value;
                  });
                }
              ),
            ),
          ),

          const SizedBox(
            height: 30,
          ),

          CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              dense: true,
              title: Text('Check this box if your parent will be a part of the meeting',
                  style: GoogleFonts.lato(
                      fontSize: 16, fontWeight: FontWeight.w800,
                      color: Theme.of(context).colorScheme.primary)),
              value: withParent,
              onChanged: (value) {
                setState(() {
                  withParent = value!;
                });
              }
          ),

          CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              dense: true,
              title: Text('Request Online Video Meeting',
                  style: GoogleFonts.lato(
                      fontSize: 16, fontWeight: FontWeight.w800,
                      color: Theme.of(context).colorScheme.primary)),
              value: online,
              onChanged: (value) {
                setState(() {
                  online = value!;
                });
              }
          ),
        ],
      ),
      actions: [
        TextButton(
          child: Text('CANCEL',
              style: GoogleFonts.lato(
                  fontSize: 16, fontWeight: FontWeight.w900,
                  color: Theme.of(context).colorScheme.secondary)
          ),
          onPressed: () => Navigator.pop(context),
        ),

        TextButton(
          child: Text('CONFIRM',
              style: GoogleFonts.lato(
                  fontSize: 16, fontWeight: FontWeight.w900,
                  color: Theme.of(context).colorScheme.secondary)
          ),
          onPressed: () {
            String reason = widget.checkListItems.last['value'];
            for (var element in widget.checkListItems) {
              if (element['selected'] == true) reason = element['value'];
            }

            // print(widget.dt);
            // print(widget.tm);
            // print(widget.id);
            // print(widget.school_id);
            // print(reason);
            // print(withParent ? '10' : '');
            // print(online ? '100' : '');

            bookGuidanceAppointment(sharedPrefs.username, sharedPrefs.password,
            widget.dt, widget.tm, widget.id, widget.school_id, reason, withParent ? '10' : '', online ? '100' : ''
            );
          }
        ),
      ],
    );
  }
}
