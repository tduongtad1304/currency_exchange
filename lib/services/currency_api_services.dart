import 'dart:convert';
import 'dart:developer';

import 'package:currency_exchange/constants/constants.dart';
import 'package:http/http.dart' as http;

import '../exceptions/currency_exception.dart';
import 'http_error_handler.dart';

class CurrencyApiServices {
  Future<dynamic> getCurrency(
      String firstCurrency, String secondCurrency) async {
    final uri = Uri.parse(
        'https://free.currconv.com/api/v7/convert?q=${firstCurrency}_$secondCurrency, ${secondCurrency}_$firstCurrency&compact=ultra&apiKey=$kApi1');
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

        return responseBody['${firstCurrency}_$secondCurrency'];
      }
    } catch (e) {
      rethrow;
    }
  }
}
