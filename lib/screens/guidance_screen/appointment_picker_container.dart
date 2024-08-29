import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:html/dom.dart' as dom;

import '../../models_services/teachassist_model.dart';
import '../../shared_prefs.dart';

class AppointmentPickerContainer extends StatefulWidget {
  const AppointmentPickerContainer({super.key});

  @override
  State<AppointmentPickerContainer> createState() =>
      _AppointmentPickerContainerState();
}

class _AppointmentPickerContainerState
    extends State<AppointmentPickerContainer> {
  dom.Document htmlData = dom.Document();
  List<List<String>> dateSchedule = [];

  final searchController = TextEditingController();

  Future<void> _fetchGuidanceDate(date) async {
    htmlData = await fetchGuidanceDate(
        sharedPrefs.username, sharedPrefs.password, date);
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
        padding: const EdgeInsets.all(20),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
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

              dateSchedule.isEmpty
                  ? const Text('NOT A SCHOOL DAY')
                  : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(children: buildDateSchedule(dateSchedule))
              ),
            ],
          ),
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
        for (final data in htmlData
            .querySelectorAll('body > div > div.box.blue > div')
            .map((element) => element.innerHtml.trim())
            .toList()) {
          dateSchedule.add(data.split('\n'));
        }
        searchController.text = selectedDate.toString().split(" ")[0];
      });
    }
  }

  List<Widget> buildDateSchedule(List<List<String>> dateSchedule) {
    List<Widget> columns = [];
    for (int counselor = 0; counselor < dateSchedule.length; counselor++) {
      columns.add(
        Column(
          children: <Widget>[
            Text('${dateSchedule[counselor][0].substring(4,dateSchedule[counselor][0].indexOf(':'))}'
                '${dateSchedule[counselor][0].substring(dateSchedule[counselor][0].indexOf('('),dateSchedule[counselor][0].indexOf('.'))}'),

            // for (int i = 1; i < dateSchedule[counselor].length; i++) TextButton(
            //   child: Text(dateSchedule[counselor][i]),
            //   onPressed: ,
            // )

          ],
        ),
      );
    }
    return columns;
  }


}
