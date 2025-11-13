// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crypto_coin_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CryptoCoinModel _$CryptoCoinModelFromJson(Map<String, dynamic> json) =>
    CryptoCoinModel(
      id: json['id'] as String,
      name: json['name'] as String,
      symbol: json['symbol'] as String,
      imageUrl: json['image'] as String?,
      currentPrice: (json['current_price'] as num?)?.toDouble(),
      priceChange24h: (json['price_change_24h'] as num?)?.toDouble(),
      priceChangePercentage24h:
          (json['price_change_percentage_24h'] as num?)?.toDouble(),
      marketCap: (json['market_cap'] as num?)?.toDouble(),
      volume24h: (json['total_volume'] as num?)?.toDouble(),
      marketCapRank: (json['market_cap_rank'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CryptoCoinModelToJson(CryptoCoinModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'symbol': instance.symbol,
      'image': instance.imageUrl,
      'current_price': instance.currentPrice,
      'price_change_24h': instance.priceChange24h,
      'price_change_percentage_24h': instance.priceChangePercentage24h,
      'market_cap': instance.marketCap,
      'total_volume': instance.volume24h,
      'market_cap_rank': instance.marketCapRank,
    };

SimplePriceModel _$SimplePriceModelFromJson(Map<String, dynamic> json) =>
    SimplePriceModel(
      prices: json['prices'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$SimplePriceModelToJson(SimplePriceModel instance) =>
    <String, dynamic>{
      'prices': instance.prices,
    };
