part of 'currency_cubit.dart';

enum FetchStatus {
  initial,
  loading,
  loaded,
  error,
}

class CurrencyState extends Equatable {
  final FetchStatus fetchStatus;
  final String currency1;
  final String currency2;
  final dynamic convertValue;
  final CustomError error;

  const CurrencyState({
    required this.fetchStatus,
    required this.currency1,
    required this.currency2,
    required this.convertValue,
    required this.error,
  });
  factory CurrencyState.initial() => const CurrencyState(
        fetchStatus: FetchStatus.initial,
        currency1: 'USD',
        currency2: 'VND',
        convertValue: 0,
        error: CustomError(),
      );
  @override
  List<Object> get props => [
        fetchStatus,
        currency1,
        currency2,
        convertValue,
        error,
      ];

  CurrencyState copyWith({
    FetchStatus? fetchStatus,
    String? currency1,
    String? currency2,
    dynamic convertValue,
    CustomError? error,
  }) {
    return CurrencyState(
      fetchStatus: fetchStatus ?? this.fetchStatus,
      currency1: currency1 ?? this.currency1,
      currency2: currency2 ?? this.currency2,
      convertValue: convertValue ?? this.convertValue,
      error: error ?? this.error,
    );
  }

  @override
  String toString() =>
      'CurrencyState(currency1: $currency1, currency2: $currency2 , fetchStatus: $fetchStatus, convertValue: $convertValue, error: $error)';

  @override
  bool? get stringify => true;
}
