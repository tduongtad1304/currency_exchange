import 'package:currency_exchange/cubits/currency/currency_cubit.dart';
import 'package:currency_exchange/widgets/currency_box.dart';
import 'package:currency_exchange/widgets/exchange_rate_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/error_dialog.dart';

enum AppSession {
  currencyRow,
  exchangeRateDisplay,
  exchangeRateInput,
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  bool isValidating = false;
  bool isScaffoldRefresh = false;
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  double? inputValue;
  String firstUnit = '';
  String secondUnit = '';

  @override
  void initState() {
    _getCodesAndCountryName(0);
    firstUnit = 'USD';
    secondUnit = 'VND';
    _exchangeCurrency(firstUnit, secondUnit);
    _getCodesAndCountryName(1);
    super.initState();
  }

  /// Exchange currency in the beginning.
  Future<dynamic> _exchangeCurrency(
      String firstCurrencyUnit, String secondCurrencyUnit) async {
    if (firstCurrencyUnit != secondCurrencyUnit) {
      var currency = await context
          .read<CurrencyCubit>()
          .exchangeCurrency(firstCurrencyUnit, secondCurrencyUnit);
      return currency;
    }
  }

  /// Get currency code and country name, 0 for code, 1 for country name.
  Future<List<String>> _getCodesAndCountryName(int codeOrName) async {
    var codes =
        await context.read<CurrencyCubit>().getCodesAndCountryName(codeOrName);
    return codes;
  }

  ///Submit form when user click on the button.
  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      displacement: 90,
      color: Colors.blue,
      strokeWidth: 2.7,
      onRefresh: () async {
        setState(() => isScaffoldRefresh = true);
        await _exchangeCurrency(firstUnit, secondUnit)
            .whenComplete(() => setState(() => isScaffoldRefresh = false));
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Currency Converter'),
          centerTitle: true,
        ),
        body: ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 120),
          itemCount: AppSession.values.length,
          separatorBuilder: (context, index) => const SizedBox(height: 30),
          itemBuilder: _itemBuilder,
        ),
      ),
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    switch (AppSession.values[index]) {
      case AppSession.currencyRow:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _currencyBox(
                unit: firstUnit,
                onChanged: (value) => setState(() => firstUnit = value ?? ''),
                onConfirmed: () =>
                    _chooseCurrency(context, firstUnit, secondUnit),
              ),
              const SizedBox(width: 20),
              IconButton(
                icon: const Icon(Icons.swap_horizontal_circle_sharp,
                    size: 40, color: Colors.grey),
                onPressed: () {
                  setState(() {
                    final temp = firstUnit;
                    firstUnit = secondUnit;
                    secondUnit = temp;
                  });
                  _exchangeCurrency(firstUnit, secondUnit);
                },
              ),
              const SizedBox(width: 20),
              _currencyBox(
                unit: secondUnit,
                onChanged: (value) => setState(() => secondUnit = value ?? ''),
                onConfirmed: () =>
                    _chooseCurrency(context, firstUnit, secondUnit),
              ),
            ],
          ),
        );
      case AppSession.exchangeRateDisplay:
        return BlocConsumer<CurrencyCubit, CurrencyState>(
          listener: (context, state) {
            if (state.fetchStatus == FetchStatus.error) {
              errorDialog(context, state.error.errMsg);
            }
          },
          builder: (context, state) => _buildExchangeRate(state),
        );
      case AppSession.exchangeRateInput:
        return Form(
          key: _formKey,
          autovalidateMode: autovalidateMode,
          child: ExchangeRateInput(
            onChanged: (_) => setState(() {
              autovalidateMode = AutovalidateMode.always;
            }),
            onSaved: (String? value) => setState(() {
              inputValue = double.tryParse(value ?? '');
            }),
            onSubmitted: _submit,
          ),
        );
    }
  }

  ///Helper method to return the CurrencyBox for easier to read.
  CurrencyBox _currencyBox({
    required String unit,
    required ValueChanged<String?> onChanged,
    required VoidCallback onConfirmed,
  }) {
    final fullCodeAndCountryName =
        context.watch<CurrencyCubit>().state.fullCodeAndName;
    return CurrencyBox(
      items: fullCodeAndCountryName,
      onConfirmed: onConfirmed,
      value: unit,
      onChanged: onChanged,
    );
  }

  ///Helper method to build exchange rate according to state.
  Widget _buildExchangeRate(CurrencyState state) {
    switch (state.fetchStatus) {
      case FetchStatus.loading:
        return Center(
          child: !isScaffoldRefresh
              ? const SizedBox(
                  height: 25,
                  width: 25,
                  child: CircularProgressIndicator(color: Colors.blue))
              : const Text(
                  'Refreshing...',
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
                ),
        );
      case FetchStatus.loaded:
        return Column(
          children: [
            const Text(
              'Exchange rate:',
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
            ),
            const SizedBox(height: 20),
            Text(
              _showExchangeRate(
                state.currencyModel.conversionRate ?? 0,
                firstUnit,
                secondUnit,
              ),
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
            ),
            const SizedBox(height: 27),
            Text(
              'Last update: ${state.currencyModel.lastUpdate}',
            ),
          ],
        );
      case FetchStatus.error:
        return const Center(
          child: Text(
            'N/A',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 20,
            ),
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  ///Helper method to exchange currency and close the menu dialog.
  void _chooseCurrency(BuildContext context, String first, String second) {
    Navigator.of(context).pop();
    _exchangeCurrency(first, second);
  }

  ///Helper method to show the exchange rate value.
  String _showExchangeRate(double rate, String unit1, String unit2) {
    if (unit1 == unit2) {
      return '1 $unit1 = 1 $unit2';
    } else {
      if (inputValue == null) {
        return '1 $unit1 = $rate $unit2';
      }
      var exchangeRate = rate * (inputValue ?? 0);
      if (exchangeRate.toString().length > 16) {
        return '$inputValue $unit1 = ${exchangeRate.toStringAsPrecision(3)} $unit2';
      } else {
        return '$inputValue $unit1 = ${exchangeRate.toStringAsFixed(3)} $unit2';
      }
    }
  }
}
