import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:currency_exchange/model/custom_error.dart';
import 'package:currency_exchange/repositories/currency_repository.dart';
import 'package:equatable/equatable.dart';

part 'currency_state.dart';

class CurrencyCubit extends Cubit<CurrencyState> {
  final CurrencyRepository currencyRepository;
  CurrencyCubit({required this.currencyRepository})
      : super(CurrencyState.initial());

  Future<dynamic> fetchCurrency(String currency1, String currency2) async {
    emit(state.copyWith(fetchStatus: FetchStatus.loading));
    try {
      await currencyRepository
          .fetchCurrency(currency1, currency2)
          .then((currency) {
        emit(state.copyWith(
          fetchStatus: FetchStatus.loaded,
          convertValue: currency,
        ));
      });
    } on CustomError catch (e) {
      emit(state.copyWith(
        fetchStatus: FetchStatus.error,
        error: e,
      ));
    }
    log(state.toString());
  }
}
