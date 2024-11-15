import 'dart:collection';

class Assignment {
  String title;
  final int id;
  final LinkedHashMap<String, List<dynamic>> categories;

  Assignment({
    required this.title,
    required this.id,
    required this.categories,
  });
}