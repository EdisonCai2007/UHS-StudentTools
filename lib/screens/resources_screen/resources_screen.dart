import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../menu_drawer.dart';

class ResourcesScreen extends StatefulWidget {
  const ResourcesScreen({super.key});

  @override
  State<ResourcesScreen> createState() => _ResourcesScreenState();
}

class _ResourcesScreenState extends State<ResourcesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      /*
      ####################
      #=-=-= AppBar =-=-=#
      ####################
      */
      appBar: AppBar(
        title: Text('Resources', style: GoogleFonts.roboto(fontSize: 20)),
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        centerTitle: true,
      ),

      /*
      #########################
      #=-=-= Menu Drawer =-=-=#
      #########################
      */
      drawer: const MenuDrawer(),

      body: ListView(
        children: [

          Padding(
            padding: const EdgeInsets.all(30),
            child: Text('Student Life',
                style: GoogleFonts.roboto(
                fontSize: 20, fontWeight: FontWeight.w900)
            ),
          ),

          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 30),
            leading: const Icon(Icons.assignment),
            title: Text('TeachAssist',
              style: GoogleFonts.roboto(
              fontSize: 16, fontWeight: FontWeight.w400)
            ),
            trailing: const Icon(Icons.keyboard_arrow_right),
            tileColor: Theme.of(context).colorScheme.primaryContainer,
            onTap: () {
              launchUrl(Uri.parse('https://ta.yrdsb.ca/'));
            },
          ),

          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 30),
            leading: const Icon(Icons.backpack),
            title: Text('My Pathway Planner',
              style: GoogleFonts.roboto(
              fontSize: 16, fontWeight: FontWeight.w400)
            ),
            trailing: const Icon(Icons.keyboard_arrow_right),
            tileColor: Theme.of(context).colorScheme.primaryContainer,
            onTap: () {
              launchUrl(Uri.parse('https://mypathwayplanner.yrdsb.ca/'));
            },
          ),

          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 30),
            leading: const Icon(Icons.payment),
            title: Text('School Cash Online',
              style: GoogleFonts.roboto(
              fontSize: 16, fontWeight: FontWeight.w400)
            ),
            trailing: const Icon(Icons.keyboard_arrow_right),
            tileColor: Theme.of(context).colorScheme.primaryContainer,
            onTap: () {
              launchUrl(Uri.parse('https://yrdsb.schoolcashonline.com/Home/SignIn/'));
            },
          ),

          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 30),
            leading: const Icon(Icons.school),
            title: Text('OUAC',
              style: GoogleFonts.roboto(
              fontSize: 16, fontWeight: FontWeight.w400)
            ),
            trailing: const Icon(Icons.keyboard_arrow_right),
            tileColor: Theme.of(context).colorScheme.primaryContainer,
            onTap: () {
              launchUrl(Uri.parse('https://www.ouac.on.ca/'));
            },
          ),

          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 30),
            leading: const Icon(Icons.school),
            title: Text('OCAS',
              style: GoogleFonts.roboto(
              fontSize: 16, fontWeight: FontWeight.w400)
            ),
            trailing: const Icon(Icons.keyboard_arrow_right),
            tileColor: Theme.of(context).colorScheme.primaryContainer,
            onTap: () {
              launchUrl(Uri.parse('https://www.ontariocolleges.ca/en'));
            },
          ),

          Padding(
            padding: const EdgeInsets.all(30),
            child: Text('Other',
                style: GoogleFonts.roboto(
                fontSize: 20, fontWeight: FontWeight.w900)
            ),
          ),

          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 30),
            leading: const Icon(Icons.link),
            title: Text('YRDSB',
              style: GoogleFonts.roboto(
              fontSize: 16, fontWeight: FontWeight.w400)
            ),
            trailing: const Icon(Icons.keyboard_arrow_right),
            tileColor: Theme.of(context).colorScheme.primaryContainer,
            onTap: () {
              launchUrl(Uri.parse('https://www2.yrdsb.ca/'));
            },
          ),

          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 30),
            leading: const Icon(Icons.link),
            title: Text('Unionville High School',
              style: GoogleFonts.roboto(
              fontSize: 16, fontWeight: FontWeight.w400)
            ),
            trailing: const Icon(Icons.keyboard_arrow_right),
            tileColor: Theme.of(context).colorScheme.primaryContainer,
            onTap: () {
              launchUrl(Uri.parse('http://www.yrdsb.ca/schools/unionville.hs'));
            },
          ),

          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 30),
            leading: const Icon(Icons.announcement),
            title: Text('Report It',
              style: GoogleFonts.roboto(
              fontSize: 16, fontWeight: FontWeight.w400)
            ),
            trailing: const Icon(Icons.keyboard_arrow_right),
            tileColor: Theme.of(context).colorScheme.primaryContainer,
            onTap: () {
              launchUrl(Uri.parse('https://secure.yrdsb.ca/Forms/ReportIt/_layouts/FormServer.aspx?XsnLocation=https://secure.yrdsb.ca/FormServerTemplates/ReportItv2.xsn'));
            },
          ),

          Padding(
            padding: const EdgeInsets.all(30),
            child: Text('User Experience',
                style: GoogleFonts.roboto(
                fontSize: 20, fontWeight: FontWeight.w900)
            ),
          ),

          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 30),
            leading: const Icon(Icons.assignment),
            title: Text('Feedback & Bug Form',
              style: GoogleFonts.roboto(
              fontSize: 16, fontWeight: FontWeight.w400)
            ),
            trailing: const Icon(Icons.keyboard_arrow_right),
            tileColor: Theme.of(context).colorScheme.primaryContainer,
            onTap: () {
              launchUrl(Uri.parse('https://docs.google.com/forms/d/e/1FAIpQLSeg1JpslRNHNROuVORrgH4ghHk8IDLyrhgYMRRUNvqBBs37qw/viewform?usp=sf_link'));
            },
          ),

        ],
      ),
    );
  }
}
