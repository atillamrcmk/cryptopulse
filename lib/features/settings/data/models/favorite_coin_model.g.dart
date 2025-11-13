// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_coin_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FavoriteCoinModelAdapter extends TypeAdapter<FavoriteCoinModel> {
  @override
  final int typeId = 1;

  @override
  FavoriteCoinModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FavoriteCoinModel(
      coinId: fields[0] as String,
      addedAt: fields[1] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, FavoriteCoinModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.coinId)
      ..writeByte(1)
      ..write(obj.addedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavoriteCoinModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
