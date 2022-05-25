class CurrencyException implements Exception {
  String message;

  CurrencyException([this.message = 'Something went wrong']) {
    message = 'Currency exception $message';
  }

  @override
  String toString() {
    return message;
  }
}
