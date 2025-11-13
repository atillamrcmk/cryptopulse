// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exchange_rate_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExchangeRateModel _$ExchangeRateModelFromJson(Map<String, dynamic> json) =>
    ExchangeRateModel(
      base: json['base'] as String,
      rates: (json['rates'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      lastUpdateUnix: (json['time_last_update_unix'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ExchangeRateModelToJson(ExchangeRateModel instance) =>
    <String, dynamic>{
      'base': instance.base,
      'rates': instance.rates,
      'time_last_update_unix': instance.lastUpdateUnix,
    };
