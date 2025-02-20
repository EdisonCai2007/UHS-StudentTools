import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wolfpackapp/misc/internet_connection.dart';
import 'package:wolfpackapp/misc/page_navigator.dart';
import 'package:wolfpackapp/models_services/uhs_teachers_model.dart';
import 'package:wolfpackapp/screens/user_offline_dialog.dart';

import '../../misc/menu_drawer.dart';


class ContactTeachersScreen extends StatefulWidget {
  const ContactTeachersScreen({super.key});

  @override
  State<ContactTeachersScreen> createState() => _ContactTeachersScreenState();
}

class _ContactTeachersScreenState extends State<ContactTeachersScreen> {
  final searchController = TextEditingController();
  List<Map<String, String>> teachers = UHSTeachersModel.teachers;
  bool online = false;

  @override
  void initState() {
    _checkUserConnection();
    super.initState();
  }

  void _checkUserConnection() async {
    online = await checkUserConnection();
  }

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
          title: Text('Teachers', style: GoogleFonts.roboto(fontSize: 20)),
          foregroundColor: Theme.of(context).colorScheme.onSurface,
          centerTitle: true,
          shape: const Border(
            bottom: BorderSide(color: Colors.transparent),
          ),
        ),

        /*
      #########################
      #=-=-= Menu Drawer =-=-=#
      #########################
      */
        drawer: const MenuDrawer(),

        body: Column(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(20, 20, 20, 30),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: 'Search for a Teacher',
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(context).colorScheme.inversePrimary),
                  ),
                ),
                onChanged: searchBook,
              ),
            ),


            (teachers.isNotEmpty) ? Expanded(
              flex: 1,
              child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: teachers.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 30),
                      child: Container(
                        margin: const EdgeInsets.only(
                        ),
                        height: 160,
                        decoration: BoxDecoration(
                            border: Border.symmetric(
                              horizontal: BorderSide(
                                color: Theme.of(context).colorScheme.secondary,
                                width: 1.5,
                              ),
                            )
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 15, left: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Text("${teachers[index]['First Name']} ${teachers[index]['Last Name']}",
                                        style: GoogleFonts.roboto(
                                            fontSize: 20, fontWeight: FontWeight.w600)
                                    ),
                                  ),

                                  Expanded(
                                      flex: 5,
                                      child: teachers[index]['Departments'] != '' ? Wrap(
                                        children: teachers[index]['Departments']!.split('/').map((label) {
                                          return Padding(
                                            padding: const EdgeInsets.only(right: 10),
                                            child: Chip(
                                              label: Text(label),
                                            ),
                                          );
                                        }).toList(),
                                      ): const SizedBox()
                                  ),

                                  Expanded(
                                    flex: 6,
                                    child: Row(
                                      children: [
                                        const Text('GAPPS'),

                                        GestureDetector(
                                          onTap: () async {
                                            await Clipboard.setData(ClipboardData(text: '${teachers[index]['Email']}'));
                                          },
                                          child: Tooltip(
                                            triggerMode: TooltipTriggerMode.tap,
                                            message: 'Copied!',
                                            child: Padding(
                                              padding: const EdgeInsets.all(5),
                                              child: Icon(Icons.copy),
                                            )
                                          ),
                                        ),

                                        const SizedBox(width: 15),

                                        const Text('YRDSB'),

                                        GestureDetector(
                                          onTap: () async {
                                            await Clipboard.setData(ClipboardData(text: '${teachers[index]['Email']}'.replaceAll('gapps.', '')));
                                          },
                                          child: Tooltip(
                                            triggerMode: TooltipTriggerMode.tap,
                                            message: 'Copied!',
                                            child: Padding(
                                              padding: const EdgeInsets.all(5),
                                              child: Icon(Icons.copy),
                                            )
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
              ),
            ) : online ?
            Text(
              'Filters Result in No Teachers...',
              style: GoogleFonts.roboto(
                fontSize: 20,
                fontWeight: FontWeight.w300,
                fontStyle: FontStyle.italic,
              ),
              overflow: TextOverflow.visible,
            ) : UserOfflineDialog(),
          ],
        ),
      ),
    );
  }

  void searchBook(String query) {
    final searchResults = UHSTeachersModel.teachers.where((teacher) {
      final teacherName = '${teacher["First Name"]} ${teacher["Last Name"]}'.toLowerCase();
      final search = query.toLowerCase();

      return teacherName.contains(search);
    }).toList();

    setState(() => teachers = query == '' ? UHSTeachersModel.teachers : searchResults);
  }
}
