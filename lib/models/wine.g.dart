// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wine.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WineAdapter extends TypeAdapter<Wine> {
  @override
  final int typeId = 1;

  @override
  Wine read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Wine(
      wineNumber: fields[0] as int,
      name: fields[1] as String,
      color: fields[2] as String,
      smell: fields[3] as String,
      taste: fields[4] as String,
      aftertaste: fields[5] as String,
      comments: fields[6] as String,
      acidity: fields[7] as double,
      body: fields[8] as double,
      fruit: fields[9] as double,
      sweetness: fields[10] as double,
      tannins: fields[11] as double,
      rating: fields[12] as double,
    );
  }

  @override
  void write(BinaryWriter writer, Wine obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.wineNumber)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.color)
      ..writeByte(3)
      ..write(obj.smell)
      ..writeByte(4)
      ..write(obj.taste)
      ..writeByte(5)
      ..write(obj.aftertaste)
      ..writeByte(6)
      ..write(obj.comments)
      ..writeByte(7)
      ..write(obj.acidity)
      ..writeByte(8)
      ..write(obj.body)
      ..writeByte(9)
      ..write(obj.fruit)
      ..writeByte(10)
      ..write(obj.sweetness)
      ..writeByte(11)
      ..write(obj.tannins)
      ..writeByte(12)
      ..write(obj.rating);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WineAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
