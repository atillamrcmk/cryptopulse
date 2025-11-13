// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'price_alarm_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PriceAlarmModelAdapter extends TypeAdapter<PriceAlarmModel> {
  @override
  final int typeId = 2;

  @override
  PriceAlarmModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PriceAlarmModel(
      id: fields[0] as String,
      coinId: fields[1] as String,
      coinName: fields[2] as String,
      coinSymbol: fields[3] as String,
      targetPrice: fields[4] as double,
      isAbove: fields[5] as bool,
      isActive: fields[6] as bool,
      createdAt: fields[7] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, PriceAlarmModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.coinId)
      ..writeByte(2)
      ..write(obj.coinName)
      ..writeByte(3)
      ..write(obj.coinSymbol)
      ..writeByte(4)
      ..write(obj.targetPrice)
      ..writeByte(5)
      ..write(obj.isAbove)
      ..writeByte(6)
      ..write(obj.isActive)
      ..writeByte(7)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PriceAlarmModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
