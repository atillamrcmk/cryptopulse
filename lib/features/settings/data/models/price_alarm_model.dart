import 'package:hive/hive.dart';

part 'price_alarm_model.g.dart';

/// Fiyat alarmı Hive modeli
@HiveType(typeId: 2)
class PriceAlarmModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String coinId;

  @HiveField(2)
  String coinName;

  @HiveField(3)
  String coinSymbol;

  @HiveField(4)
  double targetPrice;

  @HiveField(5)
  bool isAbove; // true: yukarı kırınca, false: aşağı kırınca

  @HiveField(6)
  bool isActive;

  @HiveField(7)
  DateTime createdAt;

  PriceAlarmModel({
    required this.id,
    required this.coinId,
    required this.coinName,
    required this.coinSymbol,
    required this.targetPrice,
    required this.isAbove,
    this.isActive = true,
    required this.createdAt,
  });
}
