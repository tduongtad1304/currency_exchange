import 'package:equatable/equatable.dart';

class CurrencyModel extends Equatable {
  final String baseCode;
  final String targetCode;
  final dynamic conversionRate;
  final dynamic lastUpdate;
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
    dynamic lastUpdate,
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
        baseCode: json['base_code'] as String,
        targetCode: json['target_code'] as String,
        conversionRate: json['conversion_rate'],
        lastUpdate: json['time_last_update_utc'] as String,
      );

  @override
  List<Object> get props {
    return [
      baseCode,
      targetCode,
      conversionRate,
    ];
  }

  @override
  bool get stringify => true;
}
