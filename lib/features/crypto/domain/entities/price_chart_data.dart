import 'package:equatable/equatable.dart';

/// Fiyat grafik verisi entity
class PriceChartData extends Equatable {
  final List<PricePoint> prices;
  final List<PricePoint> marketCaps;
  final List<PricePoint> volumes;

  const PriceChartData({
    required this.prices,
    required this.marketCaps,
    required this.volumes,
  });

  @override
  List<Object?> get props => [prices, marketCaps, volumes];
}

/// Grafik noktası
class PricePoint extends Equatable {
  final DateTime timestamp;
  final double value;

  const PricePoint({required this.timestamp, required this.value});

  @override
  List<Object?> get props => [timestamp, value];
}
