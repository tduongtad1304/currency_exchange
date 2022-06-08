import 'dart:convert';
import 'dart:developer';

import 'package:currency_exchange/constants/constants.dart';
import 'package:currency_exchange/model/currency_model.dart';
import 'package:http/http.dart' as http;

import '../exceptions/currency_exception.dart';
import 'http_error_handler.dart';

class CurrencyApiServices {
  Future<List<String>> getCodes(int? codeOrName) async {
    final uri = Uri.parse('https://v6.exchangerate-api.com/v6/$kApi/codes');
    int i;
    final List<String> result = [];
    if (codeOrName == 0) {
      try {
        final response = await http.get(uri);

        if (response.statusCode != 200) {
          throw Exception(httpErrorHandler(response));
        } else {
          late final responseBody = json.decode(response.body);

          if (responseBody.isEmpty) {
            throw CurrencyException('Cannot get the currency exchange rate');
          } else {
            for (i = 0; i < responseBody['supported_codes'].length; i++) {
              result.add(responseBody['supported_codes'][i][0]);
            }
          }
        }
      } catch (e) {
        rethrow;
      }
    }

    if (codeOrName == 1) {
      try {
        final response = await http.get(uri);

        if (response.statusCode != 200) {
          throw Exception(httpErrorHandler(response));
        } else {
          late final responseBody = json.decode(response.body);

          if (responseBody.isEmpty) {
            throw CurrencyException('Cannot get the currency exchange rate');
          } else {
            for (i = 0; i < responseBody['supported_codes'].length; i++) {
              result.add(responseBody['supported_codes'][i][1]);
            }
          }
        }
      } catch (e) {
        rethrow;
      }
    }
    return result;
  }

  Future<CurrencyModel> getCurrency(
      String firstCurrency, String secondCurrency) async {
    final uri = Uri.parse(
        'https://v6.exchangerate-api.com/v6/$kApi/pair/$firstCurrency/$secondCurrency');
    try {
      final response = await http.get(uri);
      if (response.statusCode != 200) {
        throw Exception(httpErrorHandler(response));
      } else {
        log(response.body);
        late final responseBody = json.decode(response.body);

        if (responseBody.isEmpty) {
          throw CurrencyException('Cannot get the currency exchange rate');
        }

        return CurrencyModel.fromJson(responseBody);
      }
    } catch (e) {
      rethrow;
    }
  }
}
