// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tasting_session.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TastingSessionAdapter extends TypeAdapter<TastingSession> {
  @override
  final int typeId = 0;

  @override
  TastingSession read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TastingSession(
      name: fields[0] as String,
      date: fields[1] as String,
      details: fields[2] as String,
      wines: (fields[3] as List?)?.cast<Wine>(),
    );
  }

  @override
  void write(BinaryWriter writer, TastingSession obj) {
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
      other is TastingSessionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
