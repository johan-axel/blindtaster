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

  @HiveField(5)
  String flight;

  @HiveField(6)
  int numberOfWines;

  Tasting({
    required this.id,
    required this.name,
    required this.date,
    required this.details,
    this.flight = '',
    this.numberOfWines = 0,
    List<Wine>? wines,
  }) : wines = wines ?? [];
}
