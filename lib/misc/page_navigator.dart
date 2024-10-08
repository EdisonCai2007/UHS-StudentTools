import 'dart:collection';

import 'package:flutter/material.dart';
import '../screens/home_screen/home_screen.dart';

class PageNavigator {
  static const _pageHistoryLimit = 10;
  static final Queue<Widget> pageHistory = Queue();
  static Widget? nextPage;

  static void changePage(BuildContext context, Widget newPage) {
    Navigator.pushReplacement(context, PageRouteBuilder(
      pageBuilder: (context, animation1, animation2) => newPage,
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
    ));
  }

  static void navigatePage(BuildContext context, Widget newPage) {
    print('navigatePage PAGE HISTORY: $pageHistory');

    if (nextPage != null) {
      if (pageHistory.isEmpty || (pageHistory.isNotEmpty && pageHistory.first != newPage)) {
        pageHistory.addFirst(nextPage!);

        if (pageHistory.length > _pageHistoryLimit) {
          pageHistory.removeLast();
        }
      }
    }

    nextPage = newPage;
    changePage(context, newPage);
  }

  static void backButton(BuildContext context) {
    if (pageHistory.isEmpty && context.widget is! HomeScreen) {
      changePage(context, const HomeScreen());
    } else {
      changePage(context, pageHistory.first);
      pageHistory.removeFirst();
    }

    nextPage = null;
  }
}