import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/exchange_rate.dart';

part 'exchange_rate_model.g.dart';

/// Döviz kuru model
@JsonSerializable()
class ExchangeRateModel {
  final String base;
  final Map<String, double> rates;
  @JsonKey(name: 'time_last_update_unix')
  final int? lastUpdateUnix;

  ExchangeRateModel({
    required this.base,
    required this.rates,
    this.lastUpdateUnix,
  });

  factory ExchangeRateModel.fromJson(Map<String, dynamic> json) =>
      _$ExchangeRateModelFromJson(json);

  Map<String, dynamic> toJson() => _$ExchangeRateModelToJson(this);

  /// Entity'ye dönüştür
  ExchangeRate toEntity() {
    return ExchangeRate(
      baseCurrency: base,
      rates: rates,
      lastUpdate: lastUpdateUnix != null
          ? DateTime.fromMillisecondsSinceEpoch(lastUpdateUnix! * 1000)
          : null,
    );
  }
}
