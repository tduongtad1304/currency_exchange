import 'package:currency_exchange/model/currency_model.dart';

import '../exceptions/currency_exception.dart';
import '../model/custom_error.dart';
import '../services/currency_api_services.dart';

class CurrencyRepository {
  final CurrencyApiServices currencyApiServices;
  CurrencyRepository({
    required this.currencyApiServices,
  });

  Future<List<String>> getCodesAndCountryName(int codeOrName) async {
    try {
      final codes =
          await currencyApiServices.getCodesAndCountryName(codeOrName);
      // if (kDebugMode) {
      //   log('exchange rate information: $codes');
      // }

      return codes;
    } on CurrencyException catch (e) {
      throw CustomError(errMsg: e.message);
    } catch (e) {
      throw CustomError(errMsg: e.toString());
    }
  }

  Future<CurrencyModel> exchangeCurrency(
      String firstCurrencyUnit, String secondCurrencyUnit) async {
    try {
      final currency = await currencyApiServices.exchangeCurrency(
          firstCurrencyUnit, secondCurrencyUnit);
      // if (kDebugMode) {
      //   log('exchange rate information: $currency');
      // }

      return currency;
    } on CurrencyException catch (e) {
      throw CustomError(errMsg: e.message);
    } catch (e) {
      throw CustomError(errMsg: e.toString());
    }
  }
}
