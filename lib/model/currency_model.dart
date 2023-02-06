import 'package:equatable/equatable.dart';

class CurrencyModel extends Equatable {
  final String? baseCode;
  final String? targetCode;
  final double? conversionRate;
  final String? lastUpdate;
  const CurrencyModel({
    required this.baseCode,
    required this.targetCode,
    required this.conversionRate,
    required this.lastUpdate,
  });

  CurrencyModel copyWith({
    String? baseCode,
    String? targetCode,
    double? conversionRate,
    String? lastUpdate,
  }) {
    return CurrencyModel(
      baseCode: baseCode ?? this.baseCode,
      targetCode: targetCode ?? this.targetCode,
      conversionRate: conversionRate ?? this.conversionRate,
      lastUpdate: lastUpdate ?? this.lastUpdate,
    );
  }

  factory CurrencyModel.initial() => const CurrencyModel(
      baseCode: '', targetCode: '', conversionRate: 0.0, lastUpdate: '');

  factory CurrencyModel.fromJson(Map<String, dynamic> json) => CurrencyModel(
        baseCode: json['base_code'] ?? '',
        targetCode: json['target_code'] ?? '',
        conversionRate: json['conversion_rate'] ?? 0.0,
        lastUpdate: json['time_last_update_utc'] ?? '',
      );

  @override
  List<Object> get props {
    return [
      baseCode ?? '',
      targetCode ?? '',
      conversionRate ?? 0.0,
      lastUpdate ?? '',
    ];
  }

  @override
  bool get stringify => true;
}
