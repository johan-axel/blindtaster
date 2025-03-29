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

  @HiveField(7)
  String? wineType;

  @HiveField(8)
  String? grapes;

  @HiveField(9)
  String? country;

  @HiveField(10)
  String? region;

  @HiveField(11)
  String? producer;

  @HiveField(12)
  String? year;

  @HiveField(13, defaultValue: false)
  bool isRevealed;

  Tasting({
    required this.id,
    required this.name,
    required this.date,
    required this.details,
    this.flight = '',
    this.numberOfWines = 0,
    this.wineType,
    this.grapes,
    this.country,
    this.region,
    this.producer,
    this.year,
    required this.isRevealed,
    List<Wine>? wines,
  }) : wines = wines ?? [];
}
