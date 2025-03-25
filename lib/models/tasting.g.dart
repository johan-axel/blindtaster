// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tasting.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TastingAdapter extends TypeAdapter<Tasting> {
  @override
  final int typeId = 0;

  @override
  Tasting read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Tasting(
      name: fields[0] as String,
      date: fields[1] as String,
      details: fields[2] as String,
      wines: (fields[3] as List?)?.cast<Wine>(),
    );
  }

  @override
  void write(BinaryWriter writer, Tasting obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.details)
      ..writeByte(3)
      ..write(obj.wines);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TastingAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
