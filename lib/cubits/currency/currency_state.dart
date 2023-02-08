part of 'currency_cubit.dart';

enum FetchStatus {
  initial,
  loading,
  loaded,
  error,
}

class CurrencyState extends Equatable {
  final FetchStatus fetchStatus;
  final CurrencyModel currencyModel;
  final List<String> codes;
  final List<String> countryName;
  final CustomError error;
  const CurrencyState({
    required this.fetchStatus,
    required this.currencyModel,
    required this.codes,
    required this.countryName,
    required this.error,
  });

  Map<String, String> get fullCodeAndName => Map.fromEntries(
        codes.asMap().entries.map(
              (e) => MapEntry(
                e.value,
                countryName.length > e.key ? countryName[e.key] : '',
              ),
            ),
      );
  @override
  List<Object?> get props =>
      [fetchStatus, currencyModel, codes, countryName, fullCodeAndName, error];

  CurrencyState copyWith({
    FetchStatus? fetchStatus,
    CurrencyModel? currencyModel,
    List<String>? codes,
    List<String>? countryName,
    Map<String, String>? fullCodeAndName,
    CustomError? error,
  }) {
    return CurrencyState(
      fetchStatus: fetchStatus ?? this.fetchStatus,
      currencyModel: currencyModel ?? this.currencyModel,
      codes: codes ?? this.codes,
      countryName: countryName ?? this.countryName,
      error: error ?? this.error,
    );
  }

  @override
  bool? get stringify => true;

  factory CurrencyState.initial() => CurrencyState(
        fetchStatus: FetchStatus.initial,
        currencyModel: CurrencyModel.initial(),
        codes: const [],
        countryName: const [],
        error: const CustomError(),
      );
}
