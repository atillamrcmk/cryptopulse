import 'package:equatable/equatable.dart';

/// Portföy öğesi entity
class PortfolioItem extends Equatable {
  final String id;
  final String coinId;
  final String coinName;
  final String coinSymbol;
  final double amount;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PortfolioItem({
    required this.id,
    required this.coinId,
    required this.coinName,
    required this.coinSymbol,
    required this.amount,
    required this.createdAt,
    required this.updatedAt,
  });

  PortfolioItem copyWith({
    String? id,
    String? coinId,
    String? coinName,
    String? coinSymbol,
    double? amount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PortfolioItem(
      id: id ?? this.id,
      coinId: coinId ?? this.coinId,
      coinName: coinName ?? this.coinName,
      coinSymbol: coinSymbol ?? this.coinSymbol,
      amount: amount ?? this.amount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    coinId,
    coinName,
    coinSymbol,
    amount,
    createdAt,
    updatedAt,
  ];
}
