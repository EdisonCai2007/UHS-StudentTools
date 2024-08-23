import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models_services/teachassist_model.dart';
import '../../shared_prefs.dart';

class AppointmentPickerContainer extends StatefulWidget {
  const AppointmentPickerContainer({super.key});

  @override
  State<AppointmentPickerContainer> createState() =>
      _AppointmentPickerContainerState();
}

class _AppointmentPickerContainerState extends State<AppointmentPickerContainer> {
  List<String> dateSchedule = [];

  final searchController = TextEditingController();

  _fetchGuidanceDate() async {
    dateSchedule = await fetchGuidanceDate(sharedPrefs.username, sharedPrefs.password);
  }

  @override
  void initState() {
    super.initState();
    _fetchGuidanceDate();
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
        height: 230,
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
                  hintText: 'Search for a Teacher',
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.inversePrimary),
                  ),
                ),
                onTap: selectDate,
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
      setState(() {
        dateSchedule = _fetchGuidanceDate();
        print(dateSchedule);
        searchController.text = selectedDate.toString().split(" ")[0];
      });
    }
  }
}
