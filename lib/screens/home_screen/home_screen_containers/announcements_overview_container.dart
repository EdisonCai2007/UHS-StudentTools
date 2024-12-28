import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wolfpackapp/models_services/club_announcement.dart';
import 'package:wolfpackapp/models_services/club_announcements_model.dart';

class AnnouncementsOverviewContainer extends StatefulWidget {
  const AnnouncementsOverviewContainer({super.key});

  @override
  State<AnnouncementsOverviewContainer> createState() =>
      _AnnouncementsOverviewContainerState();
}

class _AnnouncementsOverviewContainerState extends State<AnnouncementsOverviewContainer> {
  List<ClubAnnouncement> announcements = [];
  int aIndex = 0; // Announcement Index

  @override
  void initState() {
    super.initState();
    announcements = ClubAnnouncementsModel.announcements;
    aIndex = announcements.length-1;
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

          /*
          ###################
          #=-=-= Title =-=-=#
          ###################
          */
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Container(
              alignment: Alignment.topLeft,
              child: Text(announcements[aIndex].title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.roboto(
                      fontSize: 24, fontWeight: FontWeight.w600)),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Container(
              alignment: Alignment.topLeft,
              child: FittedBox(
                fit: BoxFit.fitHeight,
                child: Text(announcements[aIndex].date,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.roboto(
                        fontSize: 16, fontWeight: FontWeight.w400)),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Container(
              alignment: Alignment.topLeft,
              child: Text(announcements[aIndex].body,
                  maxLines: 6,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.roboto(
                      fontSize: 14, fontWeight: FontWeight.w400)),
            ),
          ),

          Chip(
            label: Text('~ ${announcements[aIndex].clubName}'),
          ),

          Row(
            children: [
              IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
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
                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))
                  ),
                  onPressed: () {

                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: FittedBox(
                      fit: BoxFit.fitHeight,
                      child: Text('View More',
                          style: GoogleFonts.roboto(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 14, fontWeight: FontWeight.w800)),
                    ),
                  ),
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
          )
        ],
      ),
    );
  }
}
