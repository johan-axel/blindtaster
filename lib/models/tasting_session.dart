import 'wine.dart';

class TastingSession {
  String name;
  String date;
  String details;
  List<Wine> wines;

  TastingSession({
    required this.name,
    required this.date,
    required this.details,
    List<Wine>? wines,
  }) : wines = wines ?? [];
}
