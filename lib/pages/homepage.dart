import 'package:currency_exchange/cubits/currency/currency_cubit.dart';
import 'package:currency_exchange/widgets/custom_textbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:search_choices/search_choices.dart';

import '../widgets/error_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  bool isValidating = false;
  bool isSwapping = true;
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  double? inputValue;
  String firstUnit = '';
  String secondUnit = '';

  @override
  void initState() {
    _getCodesAndCountryName(0);
    firstUnit = 'USD';
    secondUnit = 'VND';
    _exchangeInitial(firstUnit, secondUnit);
    _getCodesAndCountryName(1);
    super.initState();
  }

  /// Exchange currency in the beginning
  Future<dynamic> _exchangeInitial(
      String firstCurrencyUnit, String secondCurrencyUnit) async {
    var currency = await context
        .read<CurrencyCubit>()
        .exchangeCurrency(firstUnit, secondUnit);
    return currency;
  }

  /// Get currency code and country name, 0 for code, 1 for country name
  Future<List<String>> _getCodesAndCountryName(int? codeOrName) async {
    var codes =
        await context.read<CurrencyCubit>().getCodesAndCountryName(codeOrName);
    return codes;
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white.withOpacity(0.95),
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Currency Converter'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 120.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomTextBox(
                        onPressed: () {
                          if (firstUnit == '' || secondUnit == '') {
                            errorDialog(
                                context, 'Please select a valid currency.');
                          } else {
                            Navigator.of(context).pop();
                            firstUnit != secondUnit
                                ? context
                                    .read<CurrencyCubit>()
                                    .exchangeCurrency(firstUnit, secondUnit)
                                : null;
                          }
                        },
                        value: firstUnit,
                        child: SearchChoices.single(
                          autofocus: false,
                          displayClearIcon: false,
                          items: context
                              .read<CurrencyCubit>()
                              .state
                              .fullCodeAndName
                              .map((key, value) =>
                                  MapEntry(key, dropDownItems(key, value)))
                              .values
                              .toList(),
                          value: firstUnit,
                          hint: "Select one",
                          searchHint: "Search one",
                          closeButton: '',
                          doneButton: TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Done')),
                          onChanged: (String? value) {
                            if (value?.compareTo(firstUnit) == 0) {
                              return;
                            } else {
                              setState(() {
                                firstUnit = value?.toString() ?? '';
                              });
                            }
                          },
                          displayItem: (item, selected) {
                            return Row(
                              children: [
                                selected
                                    ? const Icon(
                                        Icons.radio_button_checked,
                                        color: Colors.grey,
                                      )
                                    : const Icon(
                                        Icons.radio_button_unchecked,
                                        color: Colors.grey,
                                      ),
                                const SizedBox(width: 7),
                                Expanded(child: item),
                              ],
                            );
                          },
                          underline: const SizedBox.shrink(),
                          isExpanded: true,
                          padding: EdgeInsets.zero,
                          dropDownDialogPadding: const EdgeInsets.all(25),
                        ),
                      ),
                      const SizedBox(width: 20),
                      IconButton(
                        hoverColor: Colors.blue,
                        icon: const Icon(Icons.swap_horizontal_circle_sharp,
                            size: 40, color: Colors.grey),
                        onPressed: () {
                          setState(() {
                            isSwapping = !isSwapping;
                            final temp = firstUnit;
                            firstUnit = secondUnit;
                            secondUnit = temp;
                          });
                          firstUnit != secondUnit
                              ? context
                                  .read<CurrencyCubit>()
                                  .exchangeCurrency(firstUnit, secondUnit)
                              : null;
                        },
                      ),
                      const SizedBox(width: 20),
                      CustomTextBox(
                        onPressed: () {
                          if (firstUnit == '' || secondUnit == '') {
                            errorDialog(
                                context, 'Please select a valid currency.');
                          } else {
                            Navigator.of(context).pop();
                            firstUnit != secondUnit
                                ? context
                                    .read<CurrencyCubit>()
                                    .exchangeCurrency(firstUnit, secondUnit)
                                : null;
                          }
                        },
                        value: secondUnit,
                        child: SearchChoices.single(
                          autofocus: false,
                          displayClearIcon: false,
                          items: context
                              .read<CurrencyCubit>()
                              .state
                              .fullCodeAndName
                              .map((key, value) =>
                                  MapEntry(key, dropDownItems(key, value)))
                              .values
                              .toList(),
                          value: secondUnit,
                          hint: "Select one",
                          searchHint: "Search one",
                          closeButton: '',
                          doneButton: TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Done')),
                          onChanged: (String? value) {
                            if (value?.compareTo(secondUnit) == 0) {
                              return;
                            } else {
                              setState(() {
                                secondUnit = value?.toString() ?? '';
                              });
                            }
                          },
                          displayItem: (item, selected) {
                            return Row(
                              children: [
                                selected
                                    ? const Icon(
                                        Icons.radio_button_checked,
                                        color: Colors.grey,
                                      )
                                    : const Icon(
                                        Icons.radio_button_unchecked,
                                        color: Colors.grey,
                                      ),
                                const SizedBox(width: 7),
                                Expanded(child: item),
                              ],
                            );
                          },
                          underline: const SizedBox.shrink(),
                          isExpanded: true,
                          padding: EdgeInsets.zero,
                          dropDownDialogPadding: const EdgeInsets.all(25),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  const Text('Exchange rate: ',
                      style:
                          TextStyle(fontWeight: FontWeight.w400, fontSize: 20)),
                  const SizedBox(height: 20),
                  BlocConsumer<CurrencyCubit, CurrencyState>(
                    listener: (context, state) {
                      if (state.fetchStatus == FetchStatus.error) {
                        errorDialog(context, state.error.errMsg);
                      }
                    },
                    builder: (context, state) {
                      if (state.fetchStatus == FetchStatus.loading) {
                        return const Center(
                            child: SizedBox(
                                height: 25,
                                width: 25,
                                child: CircularProgressIndicator(
                                    color: Colors.blue)));
                      }
                      return Text(
                          firstUnit != secondUnit
                              ? showExchangeRate(
                                  state.currencyModel.conversionRate ?? 0)
                              : showExchangeRate(1),
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 20));
                    },
                  ),
                  const SizedBox(height: 27),
                  Text(
                      'Last update: ${context.watch<CurrencyCubit>().state.currencyModel.lastUpdate}'),
                  const SizedBox(height: 30),
                  Form(
                    key: _formKey,
                    autovalidateMode: autovalidateMode,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 100),
                          child: Container(
                            width: 200,
                            height: 80,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey, width: 3),
                            ),
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              textCapitalization: TextCapitalization.words,
                              style: const TextStyle(fontSize: 18),
                              decoration: const InputDecoration(
                                labelText: 'Amount',
                                prefixIcon: Icon(Icons.monetization_on),
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                              ),
                              validator: (String? input) {
                                if (input!.isEmpty) {
                                  return 'Please enter a valid amount';
                                }
                                return null;
                              },
                              onChanged: (_) {
                                setState(() {
                                  autovalidateMode =
                                      AutovalidateMode.onUserInteraction;
                                });
                              },
                              onSaved: (String? input) {
                                inputValue = double.parse(input!);
                              },
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        SizedBox(
                          height: 50,
                          width: 180,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              setState(() {
                                _submit();
                              });
                            },
                            icon: const Icon(Icons.wifi_protected_setup),
                            label: const Text(
                              'Convert',
                              style: TextStyle(fontSize: 18),
                            ),
                            style: ElevatedButton.styleFrom(elevation: 7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  DropdownMenuItem<dynamic> dropDownItems(dynamic key, dynamic value) {
    return DropdownMenuItem(
      value: key,
      child: Text(
        '$key - $value',
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
      ),
    );
  }

  String showExchangeRate(double rate) {
    if (rate == 1) {
      return '1 $firstUnit = 1 $secondUnit';
    }
    if (inputValue == null) {
      return '1 $firstUnit = $rate $secondUnit';
    }
    var exchangeRate = rate * (inputValue ?? 0);
    if (exchangeRate.toString().length > 16) {
      return '$inputValue $firstUnit = ${exchangeRate.toStringAsPrecision(3)} $secondUnit';
    } else {
      return '$inputValue $firstUnit = ${exchangeRate.toStringAsFixed(3)} $secondUnit';
    }
  }
}
