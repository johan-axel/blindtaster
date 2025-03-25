import 'package:hive/hive.dart';
import 'wine.dart';

part 'tasting.g.dart';

@HiveType(typeId: 0)
class Tasting extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String date;

  @HiveField(2)
  String details;

  @HiveField(3)
  List<Wine> wines;

  Tasting({
    required this.name,
    required this.date,
    required this.details,
    List<Wine>? wines,
  }) : wines = wines ?? [];
}
