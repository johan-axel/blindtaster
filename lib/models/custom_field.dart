import 'package:hive/hive.dart';

part 'custom_field.g.dart';

@HiveType(typeId: 5)
enum CustomFieldType {
  @HiveField(0)
  text,
  @HiveField(1)
  number,
  @HiveField(2)
  slider
}

@HiveType(typeId: 6)
class CustomField {
  @HiveField(0)
  String name;

  @HiveField(1)
  CustomFieldType type;

  @HiveField(2)
  bool required;

  @HiveField(3)
  double? minValue;  // For slider/number types

  @HiveField(4)
  double? maxValue;  // For slider/number types

  @HiveField(5)
  int? divisions;    // For slider type

  CustomField({
    required this.name,
    required this.type,
    this.required = false,
    this.minValue,
    this.maxValue,
    this.divisions,
  });

  factory CustomField.text({
    required String name,
    bool required = false,
  }) {
    return CustomField(
      name: name,
      type: CustomFieldType.text,
      required: required,
    );
  }

  factory CustomField.number({
    required String name,
    bool required = false,
    double? min,
    double? max,
  }) {
    return CustomField(
      name: name,
      type: CustomFieldType.number,
      required: required,
      minValue: min,
      maxValue: max,
    );
  }

  factory CustomField.slider({
    required String name,
    bool required = false,
    double min = 0,
    double max = 5,
    int divisions = 5,
  }) {
    return CustomField(
      name: name,
      type: CustomFieldType.slider,
      required: required,
      minValue: min,
      maxValue: max,
      divisions: divisions,
    );
  }
}
