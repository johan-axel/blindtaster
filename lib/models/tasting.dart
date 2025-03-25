import 'package:hive/hive.dart';
import 'wine.dart';

part 'tasting.g.dart';

@HiveType(typeId: 0)
class Tasting extends HiveObject {

  @HiveField(0)
  int id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String date;

  @HiveField(3)
  String details;

  @HiveField(4)
  List<Wine> wines;

  Tasting({
    required this.id,
    required this.name,
    required this.date,
    required this.details,
    List<Wine>? wines,
  }) : wines = wines ?? [];
}
