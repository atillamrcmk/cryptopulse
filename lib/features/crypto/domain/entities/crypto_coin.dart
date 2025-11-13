import 'package:equatable/equatable.dart';

/// Kripto para entity (domain katmanı)
class CryptoCoin extends Equatable {
  final String id;
  final String name;
  final String symbol;
  final String? image;
  final double? currentPrice;
  final double? priceChange24h;
  final double? priceChangePercentage24h;
  final double? marketCap;
  final double? volume24h;
  final int? marketCapRank;
  final Map<String, double>? prices; // vs_currencies için fiyatlar

  const CryptoCoin({
    required this.id,
    required this.name,
    required this.symbol,
    this.image,
    this.currentPrice,
    this.priceChange24h,
    this.priceChangePercentage24h,
    this.marketCap,
    this.volume24h,
    this.marketCapRank,
    this.prices,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    symbol,
    image,
    currentPrice,
    priceChange24h,
    priceChangePercentage24h,
    marketCap,
    volume24h,
    marketCapRank,
    prices,
  ];
}
