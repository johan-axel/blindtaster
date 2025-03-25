import 'package:hive/hive.dart';

part 'wine.g.dart';

@HiveType(typeId: 1)
class Wine extends HiveObject {
  @HiveField(0)
  int wineNumber;

  @HiveField(1)
  String name;

  @HiveField(2)
  String color;

  @HiveField(3)
  String smell;

  @HiveField(4)
  String taste;

  @HiveField(5)
  String aftertaste;

  @HiveField(6)
  String comments;

  @HiveField(7)
  double acidity;

  @HiveField(8)
  double body;

  @HiveField(9)
  double fruit;

  @HiveField(10)
  double sweetness;

  @HiveField(11)
  double tannins;

  @HiveField(12)
  double rating;

  Wine({
    required this.wineNumber,
    this.name = '',
    this.color = '',
    this.smell = '',
    this.taste = '',
    this.aftertaste = '',
    this.comments = '',
    this.acidity = 0.0,
    this.body = 0.0,
    this.fruit = 0.0,
    this.sweetness = 0.0,
    this.tannins = 0.0,
    this.rating = 3.0,
  });
}
