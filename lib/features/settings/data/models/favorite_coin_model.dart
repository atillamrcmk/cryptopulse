import 'package:hive/hive.dart';

part 'favorite_coin_model.g.dart';

/// Favori coin Hive modeli
@HiveType(typeId: 1)
class FavoriteCoinModel extends HiveObject {
  @HiveField(0)
  String coinId;

  @HiveField(1)
  DateTime addedAt;

  FavoriteCoinModel({required this.coinId, required this.addedAt});
}
