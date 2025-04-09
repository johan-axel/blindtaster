import 'package:hive/hive.dart';
import 'custom_field.dart';

part 'settings.g.dart';

@HiveType(typeId: 3)
class Settings extends HiveObject {
  @HiveField(16)
  double minRating;

  @HiveField(17)
  double maxRating;

  @HiveField(18)
  int ratingSteps;

  @HiveField(0)
  bool showWineType;

  @HiveField(1)
  bool showGrapes;

  @HiveField(2)
  bool showCountry;

  @HiveField(3)
  bool showRegion;

  @HiveField(4)
  bool showProducer;

  @HiveField(5)
  bool showYear;

  @HiveField(6)
  bool showColor;

  @HiveField(7)
  bool showSmell;

  @HiveField(8)
  bool showSmellQuality;

  @HiveField(9)
  bool showTaste;

  @HiveField(10)
  bool showTasteQuality;

  @HiveField(11)
  bool showAftertaste;

  @HiveField(12)
  bool showAftertasteQuality;

  @HiveField(13)
  bool showCharacteristics;

  @HiveField(14)
  bool showRating;

  @HiveField(15)
  bool showComments;

  @HiveField(20)
  bool newSettings;

  @HiveField(19)
  List<CustomField> customFields;

  Settings({
    this.minRating = 1.0,
    this.maxRating = 5.0,
    this.ratingSteps = 80,
    this.showWineType = true,
    this.showGrapes = true,
    this.showCountry = true,
    this.showRegion = true,
    this.showProducer = true,
    this.showYear = true,
    this.showColor = true,
    this.showSmell = true,
    this.showSmellQuality = true,
    this.showTaste = true,
    this.showTasteQuality = true,
    this.showAftertaste = true,
    this.showAftertasteQuality = true,
    this.showCharacteristics = true,
    this.showRating = true,
    this.showComments = true,
    this.newSettings = true,
    List<CustomField>? customFields,
  }) : customFields = customFields ?? [];
}
