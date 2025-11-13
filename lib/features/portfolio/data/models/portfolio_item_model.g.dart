// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'portfolio_item_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PortfolioItemModelAdapter extends TypeAdapter<PortfolioItemModel> {
  @override
  final int typeId = 0;

  @override
  PortfolioItemModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PortfolioItemModel(
      id: fields[0] as String,
      coinId: fields[1] as String,
      coinName: fields[2] as String,
      coinSymbol: fields[3] as String,
      amount: fields[4] as double,
      createdAt: fields[5] as DateTime,
      updatedAt: fields[6] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, PortfolioItemModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.coinId)
      ..writeByte(2)
      ..write(obj.coinName)
      ..writeByte(3)
      ..write(obj.coinSymbol)
      ..writeByte(4)
      ..write(obj.amount)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PortfolioItemModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
