import 'dart:collection';

import 'package:flutter/foundation.dart';

class Assignment {
  final String title;
  final LinkedHashMap<String, List<String>> categories;

  Assignment({
    required this.title,
    required this.categories,
  });
}