import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wolfpackapp/misc/internet_connection.dart';
import 'package:wolfpackapp/misc/page_navigator.dart';
import 'package:wolfpackapp/models_services/club_announcement.dart';
import 'package:wolfpackapp/models_services/club_announcements_model.dart';
import 'package:wolfpackapp/models_services/uhs_teachers_model.dart';
import 'package:wolfpackapp/screens/user_offline_dialog.dart';

import '../../misc/menu_drawer.dart';


class AnnouncementsScreen extends StatefulWidget {
  const AnnouncementsScreen({super.key});

  @override
  State<AnnouncementsScreen> createState() => _AnnouncementsScreenState();
}

class _AnnouncementsScreenState extends State<AnnouncementsScreen> {
  final searchController = TextEditingController();
  List<ClubAnnouncement> announcements = ClubAnnouncementsModel.announcements;
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
          title: Text('Club Announcements', style: GoogleFonts.roboto(fontSize: 20)),
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
                onChanged: searchAnnouncements,
              ),
            ),


            (announcements.isNotEmpty) ? Expanded(
              flex: 1,
              child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: announcements.length,
                  itemBuilder: (BuildContext context, int index) {
                    index = announcements.length-index-1;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 30),
                      child: Container(
                        margin: const EdgeInsets.only(
                        ),
                        decoration: BoxDecoration(
                            border: Border.symmetric(
                              horizontal: BorderSide(
                                color: Theme.of(context).colorScheme.secondary,
                                width: 1.5,
                              ),
                            )
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15, left: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FittedBox(
                                child: Text(announcements[index].title,
                                      style: GoogleFonts.roboto(
                                          fontSize: 24, fontWeight: FontWeight.w600),
                                ),
                              ),

                              Container(
                                alignment: Alignment.topLeft,
                                child: FittedBox(
                                  fit: BoxFit.fitHeight,
                                  child: Text(announcements[index].date,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.roboto(
                                          fontSize: 16, fontWeight: FontWeight.w400)),
                                ),
                              ),
                        
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: Text(announcements[index].body,
                                  softWrap: true,
                                  style: GoogleFonts.domine(
                                      fontSize: 14, fontWeight: FontWeight.w400, height: 1.5)),
                              ),
                        
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Chip(
                                  label: Text(
                                    '~ ${announcements[index].clubName}',
                                    style: GoogleFonts.roboto(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: ThemeData.estimateBrightnessForColor(Color(int.parse(announcements[index].clubColour, radix: 16))) == Brightness.dark ? Colors.white : Colors.black,
                                    )
                                  ),
                                  backgroundColor: Color(int.parse(announcements[index].clubColour, radix: 16)),
                                ),
                              ),
                        
                              // Expanded(
                              //   flex: 6,
                              //   child: Row(
                              //     children: [
                              //       const Text('GAPPS'),
                        
                              //       GestureDetector(
                              //         onTap: () async {
                              //           await Clipboard.setData(ClipboardData(text: '${teachers[index]['Email']}'));
                              //         },
                              //         child: Tooltip(
                              //           triggerMode: TooltipTriggerMode.tap,
                              //           message: 'Copied!',
                              //           child: Padding(
                              //             padding: const EdgeInsets.all(5),
                              //             child: Icon(Icons.copy),
                              //           )
                              //         ),
                              //       ),
                        
                              //       const SizedBox(width: 15),
                        
                              //       const Text('YRDSB'),
                        
                              //       GestureDetector(
                              //         onTap: () async {
                              //           await Clipboard.setData(ClipboardData(text: '${teachers[index]['Email']}'.replaceAll('gapps.', '')));
                              //         },
                              //         child: Tooltip(
                              //           triggerMode: TooltipTriggerMode.tap,
                              //           message: 'Copied!',
                              //           child: Padding(
                              //             padding: const EdgeInsets.all(5),
                              //             child: Icon(Icons.copy),
                              //           )
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
              ),
            ) : online ?
            Text(
              'Filters Result in No Announcements...',
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

  void searchAnnouncements(String query) {
    final searchResults = ClubAnnouncementsModel.announcements.where((announcement) {
      final title = announcement.title.toLowerCase();
      final body = announcement.body.toLowerCase();
      final club = announcement.clubName.toLowerCase();
      final search = query.toLowerCase();

      return title.contains(search) || body.contains(search) || club.contains(search);
    }).toList();

    setState(() => announcements = query == '' ? ClubAnnouncementsModel.announcements : searchResults);
  }
}
