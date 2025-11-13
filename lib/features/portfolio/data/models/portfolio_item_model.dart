import 'package:hive/hive.dart';
import '../../domain/entities/portfolio_item.dart';

part 'portfolio_item_model.g.dart';

/// Portföy öğesi Hive modeli
@HiveType(typeId: 0)
class PortfolioItemModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String coinId;

  @HiveField(2)
  String coinName;

  @HiveField(3)
  String coinSymbol;

  @HiveField(4)
  double amount;

  @HiveField(5)
  DateTime createdAt;

  @HiveField(6)
  DateTime updatedAt;

  PortfolioItemModel({
    required this.id,
    required this.coinId,
    required this.coinName,
    required this.coinSymbol,
    required this.amount,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Entity'den model oluştur
  factory PortfolioItemModel.fromEntity(PortfolioItem item) {
    return PortfolioItemModel(
      id: item.id,
      coinId: item.coinId,
      coinName: item.coinName,
      coinSymbol: item.coinSymbol,
      amount: item.amount,
      createdAt: item.createdAt,
      updatedAt: item.updatedAt,
    );
  }

  /// Entity'ye dönüştür
  PortfolioItem toEntity() {
    return PortfolioItem(
      id: id,
      coinId: coinId,
      coinName: coinName,
      coinSymbol: coinSymbol,
      amount: amount,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
