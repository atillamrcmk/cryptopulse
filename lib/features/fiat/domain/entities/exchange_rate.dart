import 'package:equatable/equatable.dart';

/// Döviz kuru entity
class ExchangeRate extends Equatable {
  final String baseCurrency;
  final Map<String, double> rates;
  final DateTime? lastUpdate;

  const ExchangeRate({
    required this.baseCurrency,
    required this.rates,
    this.lastUpdate,
  });

  @override
  List<Object?> get props => [baseCurrency, rates, lastUpdate];
}
