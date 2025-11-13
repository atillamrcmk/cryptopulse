import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/crypto_coin.dart';

part 'crypto_coin_model.g.dart';

/// Kripto para model (data katmanı - JSON serialization için)
@JsonSerializable()
class CryptoCoinModel {
  final String id;
  final String name;
  final String symbol;
  @JsonKey(name: 'image')
  final String? imageUrl;
  @JsonKey(name: 'current_price')
  final double? currentPrice;
  @JsonKey(name: 'price_change_24h')
  final double? priceChange24h;
  @JsonKey(name: 'price_change_percentage_24h')
  final double? priceChangePercentage24h;
  @JsonKey(name: 'market_cap')
  final double? marketCap;
  @JsonKey(name: 'total_volume')
  final double? volume24h;
  @JsonKey(name: 'market_cap_rank')
  final int? marketCapRank;

  CryptoCoinModel({
    required this.id,
    required this.name,
    required this.symbol,
    this.imageUrl,
    this.currentPrice,
    this.priceChange24h,
    this.priceChangePercentage24h,
    this.marketCap,
    this.volume24h,
    this.marketCapRank,
  });

  factory CryptoCoinModel.fromJson(Map<String, dynamic> json) =>
      _$CryptoCoinModelFromJson(json);

  Map<String, dynamic> toJson() => _$CryptoCoinModelToJson(this);

  /// Entity'ye dönüştür
  CryptoCoin toEntity({Map<String, double>? prices}) {
    return CryptoCoin(
      id: id,
      name: name,
      symbol: symbol,
      image: imageUrl,
      currentPrice: currentPrice,
      priceChange24h: priceChange24h,
      priceChangePercentage24h: priceChangePercentage24h,
      marketCap: marketCap,
      volume24h: volume24h,
      marketCapRank: marketCapRank,
      prices: prices,
    );
  }
}

/// Simple price response model (CoinGecko simple/price endpoint için)
@JsonSerializable()
class SimplePriceModel {
  final Map<String, dynamic> prices;

  SimplePriceModel({required this.prices});

  factory SimplePriceModel.fromJson(Map<String, dynamic> json) {
    return SimplePriceModel(prices: json);
  }

  Map<String, dynamic> toJson() => prices;
}
