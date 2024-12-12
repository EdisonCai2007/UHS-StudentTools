import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wolfpackapp/misc/menu_drawer.dart';
import 'package:wolfpackapp/misc/page_navigator.dart';
import 'package:wolfpackapp/screens/guidance_screen/appointment_list.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({super.key});

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) => PageNavigator.backButton(context),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        /*
      ####################
      #=-=-= AppBar =-=-=#
      ####################
      */
        appBar: AppBar(
          title: Text('Appointments', style: GoogleFonts.roboto(fontSize: 20)),
          foregroundColor: Theme.of(context).colorScheme.onSurface,
          centerTitle: true,
          shape: const Border(
            bottom: BorderSide(color: Colors.transparent),
          ),
        ),

        /*
      ###################################
      #=-=-= Bottom Navigation Bar =-=-=#
      ###################################
      */
        // bottomNavigationBar: BottomAppBar(
        //   shadowColor: Colors.black,
        //   child: Center(
        //     child: Text(
        //       'Nav Bar Placeholder Text',
        //       style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        //     ),
        //   ),
        // ),

        /*
      #########################
      #=-=-= Menu Drawer =-=-=#
      #########################
      */
        drawer: const MenuDrawer(),

        /*
      #######################
      #=-=-=-=-=-=-=-=-=-=-=#
      #=-=-= Main Body =-=-=#
      #=-=-=-=-=-=-=-=-=-=-=#
      #######################
      */
        body: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          clipBehavior: Clip.none,

          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(20),
                child: buildAppointmentList()
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAppointmentList() {
    if (appointmentList.isNotEmpty) {
      return Column(
        children: <Widget>[
          for (final appointment in appointmentList) Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: const BorderRadius.all(Radius.elliptical(10, 10)),
              boxShadow: const [BoxShadow(blurRadius: 5)],
            ),
            padding: const EdgeInsets.all(15),
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: FittedBox (
                      fit: BoxFit.scaleDown,
                      child: Text(appointment['Name']!,
                        style: GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.w500)),
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
                        child: Text(appointment['Date']!,
                          style: GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.w500)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top:8),
                        child: FittedBox (
                          fit: BoxFit.scaleDown,
                          child: Text('See More',
                            style: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.w500)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    } else {
      return FittedBox (
        fit: BoxFit.scaleDown,
        child: Text('You have no appointments this month',
          style: GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.w500)),
      );
    }
  }
}
