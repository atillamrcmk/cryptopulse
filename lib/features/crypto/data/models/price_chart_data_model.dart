import '../../domain/entities/price_chart_data.dart';

/// Fiyat grafik verisi model (DTO)
class PriceChartDataModel {
  final List<List<num>> prices;
  final List<List<num>> marketCaps;
  final List<List<num>> volumes;

  PriceChartDataModel({
    required this.prices,
    required this.marketCaps,
    required this.volumes,
  });

  factory PriceChartDataModel.fromJson(Map<String, dynamic> json) {
    return PriceChartDataModel(
      prices:
          (json['prices'] as List<dynamic>?)
              ?.map((e) => (e as List<dynamic>).map((n) => n as num).toList())
              .toList() ??
          [],
      marketCaps:
          (json['market_caps'] as List<dynamic>?)
              ?.map((e) => (e as List<dynamic>).map((n) => n as num).toList())
              .toList() ??
          [],
      volumes:
          (json['total_volumes'] as List<dynamic>?)
              ?.map((e) => (e as List<dynamic>).map((n) => n as num).toList())
              .toList() ??
          [],
    );
  }

  PriceChartData toEntity() {
    return PriceChartData(
      prices: prices
          .map(
            (p) => PricePoint(
              timestamp: DateTime.fromMillisecondsSinceEpoch(p[0].toInt()),
              value: p[1].toDouble(),
            ),
          )
          .toList(),
      marketCaps: marketCaps
          .map(
            (p) => PricePoint(
              timestamp: DateTime.fromMillisecondsSinceEpoch(p[0].toInt()),
              value: p[1].toDouble(),
            ),
          )
          .toList(),
      volumes: volumes
          .map(
            (p) => PricePoint(
              timestamp: DateTime.fromMillisecondsSinceEpoch(p[0].toInt()),
              value: p[1].toDouble(),
            ),
          )
          .toList(),
    );
  }
}
