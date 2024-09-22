import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class PageNavigator {
  static void changePage(BuildContext context, Widget newPage) {
    Navigator.pushReplacement(context, PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => newPage,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }
}