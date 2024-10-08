import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserOfflineDialog extends Container {
  UserOfflineDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top:15, right: 15, left: 15),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.language,
            size: 32,
          ),
          const SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FittedBox(
                fit: BoxFit.contain,
                child: Text('Unable To Connect',
                    style: GoogleFonts.roboto(
                      fontSize: 20,
                      fontWeight: FontWeight.w900)),
              ),
          
              FittedBox(
              fit: BoxFit.contain,
              child: Text('Reconnect For More Features',
                  style: GoogleFonts.roboto(
                  fontSize: 12,
                  fontWeight: FontWeight.w400)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
