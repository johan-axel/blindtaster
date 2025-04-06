import 'package:hive/hive.dart';
import '../services/storage_provider.dart';
import 'settings.dart';

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

  @HiveField(13)
  String? wineType;

  @HiveField(14)
  String? grapes;

  @HiveField(15)
  String? country;

  @HiveField(16)
  String? region;

  @HiveField(17)
  String? producer;

  @HiveField(18)
  String? year;

  @HiveField(19)
  double? smellQuality;

  @HiveField(20)
  double? tasteQuality;

  @HiveField(21)
  double? aftertasteQuality;

  factory Wine({
    required int wineNumber,
    String name = '',
    String color = '',
    String smell = '',
    String taste = '',
    String? wineType,
    String? grapes,
    String? country,
    String? region,
    String? producer,
    String? year,
    String aftertaste = '',
    String comments = '',
    double acidity = 0.0,
    double body = 0.0,
    double fruit = 0.0,
    double sweetness = 0.0,
    double tannins = 0.0,
    double? rating,
    double? smellQuality = 3.0,
    double? tasteQuality = 3.0,
    double? aftertasteQuality = 3.0,
  }) {
    final settings = StorageProvider.instance.getSettings();
    
    return Wine._(
      wineNumber: wineNumber,
      name: name,
      color: color,
      smell: smell,
      taste: taste,
      wineType: wineType,
      grapes: grapes,
      country: country,
      region: region,
      producer: producer,
      year: year,
      aftertaste: aftertaste,
      comments: comments,
      acidity: acidity,
      body: body,
      fruit: fruit,
      sweetness: sweetness,
      tannins: tannins,
      rating: rating ?? (settings.minRating! + settings.maxRating!) / 2,
      smellQuality: smellQuality,
      tasteQuality: tasteQuality,
      aftertasteQuality: aftertasteQuality,
    );
  }

  Wine._({  
    required this.wineNumber,
    required this.name,
    required this.color,
    required this.smell,
    required this.taste,
    this.wineType,
    this.grapes,
    this.country,
    this.region,
    this.producer,
    this.year,
    required this.aftertaste,
    required this.comments,
    required this.acidity,
    required this.body,
    required this.fruit,
    required this.sweetness,
    required this.tannins,
    required this.rating,
    this.smellQuality,
    this.tasteQuality,
    this.aftertasteQuality,
  });
}
