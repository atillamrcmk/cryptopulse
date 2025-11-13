import 'package:equatable/equatable.dart';

/// Portföy özeti (toplam değer vb.)
class PortfolioSummary extends Equatable {
  final double totalValue;
  final double totalValueChange24h;
  final double totalValueChangePercentage24h;
  final int itemCount;

  const PortfolioSummary({
    required this.totalValue,
    required this.totalValueChange24h,
    required this.totalValueChangePercentage24h,
    required this.itemCount,
  });

  @override
  List<Object?> get props => [
    totalValue,
    totalValueChange24h,
    totalValueChangePercentage24h,
    itemCount,
  ];
}
