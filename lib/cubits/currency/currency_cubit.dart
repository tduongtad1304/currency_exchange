import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:currency_exchange/model/currency_model.dart';
import 'package:currency_exchange/model/custom_error.dart';
import 'package:currency_exchange/repositories/currency_repository.dart';
import 'package:equatable/equatable.dart';

part 'currency_state.dart';

class CurrencyCubit extends Cubit<CurrencyState> {
  final CurrencyRepository currencyRepository;
  CurrencyCubit({required this.currencyRepository})
      : super(CurrencyState.initial());

  Future<List<String>> getCodesAndCountryName(int? codeOrName) async {
    try {
      final codes = await currencyRepository.getCodesAndCountryName(codeOrName);
      if (codeOrName == 0) {
        emit(state.copyWith(
          fetchStatus: FetchStatus.loaded,
          codes: codes,
        ));
      } else if (codeOrName == 1) {
        emit(state.copyWith(
          fetchStatus: FetchStatus.loaded,
          countryName: codes,
        ));
      }
      log('List currency: ${state.fullCodeAndName}');
      return codes;
    } on CustomError catch (e) {
      emit(state.copyWith(
        fetchStatus: FetchStatus.error,
        error: e,
      ));
    } catch (e) {
      emit(state.copyWith(
        fetchStatus: FetchStatus.error,
        error: CustomError(errMsg: e.toString()),
      ));
    }
    return [];
  }

  Future<CurrencyModel> exchangeCurrency(
      String firstCurrencyUnit, String secondCurrencyUnit) async {
    emit(state.copyWith(fetchStatus: FetchStatus.loading));
    try {
      await currencyRepository
          .exchangeCurrency(firstCurrencyUnit, secondCurrencyUnit)
          .then((currency) {
        emit(state.copyWith(
          fetchStatus: FetchStatus.loaded,
          currencyModel: currency,
        ));
      });
    } on CustomError catch (e) {
      emit(state.copyWith(
        fetchStatus: FetchStatus.error,
        error: e,
      ));
    }
    log(state.toString());
    return state.currencyModel;
  }
}
