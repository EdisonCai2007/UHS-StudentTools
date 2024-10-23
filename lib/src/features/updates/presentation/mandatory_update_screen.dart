import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../misc/app_stores.dart';

class MandatoryUpdateScreen extends StatelessWidget {
  const MandatoryUpdateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'New Update Required',
                style: GoogleFonts.roboto(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 25,
                    fontWeight: FontWeight.w800
                ),

                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 30),

              Icon(
                CupertinoIcons.arrow_up_right_diamond_fill,
                size: 150,
                color: Theme.of(context).colorScheme.secondary,
                shadows: const [
                  Shadow(blurRadius: 5)
                ],
              ),

              const SizedBox(height: 50),

              if (storeUrl != null)
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Theme.of(context).colorScheme.primary),
                  ),
                  onPressed: () {
                    launchUrl(
                      Uri.parse(storeUrl!),
                      mode: LaunchMode.externalApplication,
                    );
                  },
                  child: Text(
                      'Update Now',
                    style: GoogleFonts.roboto(
                        fontSize: 13,
                        fontWeight: FontWeight.w600
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}