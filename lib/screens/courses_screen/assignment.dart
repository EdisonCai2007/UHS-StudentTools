import 'dart:collection';

class Assignment {
  final String title;
  final LinkedHashMap<String, List<dynamic>> categories;

  Assignment({
    required this.title,
    required this.categories,
  });
}