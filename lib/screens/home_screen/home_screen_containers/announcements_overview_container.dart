import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wolfpackapp/misc/internet_connection.dart';
import 'package:wolfpackapp/misc/page_navigator.dart';
import 'package:wolfpackapp/models_services/club_announcement.dart';
import 'package:wolfpackapp/models_services/club_announcements_model.dart';
import 'package:wolfpackapp/screens/announcements_screen/announcements_screen.dart';
import 'package:wolfpackapp/screens/user_offline_dialog.dart';

class AnnouncementsOverviewContainer extends StatefulWidget {
  const AnnouncementsOverviewContainer({super.key});

  @override
  State<AnnouncementsOverviewContainer> createState() =>
      _AnnouncementsOverviewContainerState();
}

class _AnnouncementsOverviewContainerState extends State<AnnouncementsOverviewContainer> {
  List<ClubAnnouncement> announcements = [];
  int aIndex = 0; // Announcement Index
  bool online = false;

  @override
  void initState() {
    _checkUserConnection();
    announcements = ClubAnnouncementsModel.announcements;
    aIndex = announcements.length-1;
    super.initState();
  }

  void _checkUserConnection() async {
    var _online = await checkUserConnection();
    setState(() {
      online = _online;
      announcements = ClubAnnouncementsModel.announcements;
      aIndex = announcements.length-1;
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
        left: 30,
        right: 30,
        bottom: 30,
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Container(
                  height: 10,
                  decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(5)
                ),
                ),
              ),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text('📣',style: GoogleFonts.roboto(
                        fontSize: 35, fontWeight: FontWeight.w600)),
                    ),
                  ),

                  IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios_new,
                      color: Theme.of(context).colorScheme.secondary),
                    onPressed: () {
                      setState(() {
                        if (aIndex > 0) aIndex--;
                        else aIndex = announcements.length-1;
                      });
                    }
                  ),
                  Expanded(
                    child: ElevatedButton(
                      style: Theme.of(context).elevatedButtonTheme.style!.copyWith(
                        backgroundColor: MaterialStatePropertyAll(Colors.transparent),
                        elevation: MaterialStatePropertyAll(0),
                        side: MaterialStatePropertyAll(BorderSide(color: Theme.of(context).colorScheme.tertiary,width: 1)),
                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                      ),
                      onPressed: () {
                        PageNavigator.navigatePage(context, const AnnouncementsScreen());
                      },
                      child: Text('View More',
                        style: GoogleFonts.roboto(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 14, fontWeight: FontWeight.w800)),
                    ),
                  ),
                                    
                  IconButton(
                    icon: Icon(
                      Icons.arrow_forward_ios,
                      color: Theme.of(context).colorScheme.secondary),
                    onPressed: () {
                      setState(() {
                        if (aIndex < announcements.length-1) aIndex++;
                        else aIndex = 0;
                      });
                    }
                  ),
                ],
              ),
            ],
          ),

          /*
          ###################
          #=-=-= Title =-=-=#
          ###################
          */
          online ? Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Container(
              alignment: Alignment.topLeft,
              child: Text(announcements[aIndex].title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.roboto(
                      fontSize: 24, fontWeight: FontWeight.w600)),
            ),
          ) : Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Center(
                child: UserOfflineDialog()
              ),
          ),

          online ? Container(
            alignment: Alignment.topLeft,
            child: FittedBox(
              fit: BoxFit.fitHeight,
              child: Text(announcements[aIndex].date,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.roboto(
                      fontSize: 16, fontWeight: FontWeight.w400)),
            ),
          ) : SizedBox.shrink(),

          // Padding(
          //   padding: const EdgeInsets.only(top: 10),
          //   child: Container(
          //     height: 5,
          //     color: Theme.of(context).colorScheme.secondary,
          //   ),
          // ),

          online ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Container(
              alignment: Alignment.topLeft,
              child: Text(announcements[aIndex].body,
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.domine(
                      fontSize: 14, fontWeight: FontWeight.w400, height: 1.5)),
            ),
          ) : SizedBox.shrink(),

          online? Chip(
            label: Text(
              '~ ${announcements[aIndex].clubName}',
              style: GoogleFonts.roboto(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: ThemeData.estimateBrightnessForColor(Color(int.parse(announcements[aIndex].clubColour, radix: 16))) == Brightness.dark ? Colors.white : Colors.black,
              )
            ),
            backgroundColor: Color(int.parse(announcements[aIndex].clubColour, radix: 16)),
          ) : SizedBox.shrink(),
        ],
      ),
    );
  }
}
