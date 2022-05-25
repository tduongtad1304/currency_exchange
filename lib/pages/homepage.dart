import 'package:currency_exchange/cubits/currency/currency_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  int? inputValue;

  @override
  void initState() {
    _fetchInitial();
    super.initState();
  }

  Future<dynamic> _fetchInitial() async {
    var currency =
        await context.read<CurrencyCubit>().fetchCurrency('USD', 'VND');
    return currency;
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    } else {
      setState(() {
        autovalidateMode = AutovalidateMode.always;
      });
    }
  }

  final _currency = [
    'USD',
    'EUR',
    'JPY',
    'GBP',
    'CAD',
    'AUD',
    'VND',
    'KRW',
    'SGD',
    'HKD',
  ];

  String? value1;
  String? value2;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Currency Converter'),
          centerTitle: true,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 120.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 100,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey, width: 3),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                            hint: const Text(
                              'USD',
                              style: TextStyle(
                                  fontWeight: FontWeight.w300, fontSize: 20),
                            ),
                            value: value1,
                            items: _currency.map(dropDownItems).toList(),
                            onChanged: (value) {
                              setState(() {
                                value1 = value!;
                              });
                              context
                                  .read<CurrencyCubit>()
                                  .fetchCurrency(value1!, value2!);
                            }),
                      ),
                    ),
                    const SizedBox(width: 20),
                    IconButton(
                      icon: const Icon(Icons.swap_horizontal_circle_sharp,
                          size: 40, color: Colors.grey),
                      onPressed: () {
                        setState(() {
                          isSwapping = !isSwapping;
                          final temp = value1;
                          value1 = value2;
                          value2 = temp;
                        });
                        context
                            .read<CurrencyCubit>()
                            .fetchCurrency(value1!, value2!);
                      },
                    ),
                    const SizedBox(width: 28),
                    Container(
                      width: 100,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey, width: 3),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                            hint: const Text(
                              'VND',
                              style: TextStyle(
                                  fontWeight: FontWeight.w300, fontSize: 20),
                            ),
                            value: value2,
                            items: _currency.map(dropDownItems).toList(),
                            onChanged: (value) {
                              setState(() {
                                value2 = value!;
                              });
                              context
                                  .read<CurrencyCubit>()
                                  .fetchCurrency(value1!, value2!);
                            }),
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
                          child: CircularProgressIndicator(color: Colors.blue));
                    }
                    return Text(showExchangeRate(state.convertValue),
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 20));
                  },
                ),
                const SizedBox(height: 50),
                Form(
                  key: _formKey,
                  autovalidateMode: autovalidateMode,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 100),
                        child: TextFormField(
                          textCapitalization: TextCapitalization.words,
                          style: const TextStyle(fontSize: 18),
                          decoration: InputDecoration(
                            labelText: 'Amount',
                            hintText: 'How much?',
                            prefixIcon: const Icon(Icons.monetization_on),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          validator: (String? input) {
                            if (input!.isEmpty) {
                              return 'Please enter a number';
                            }
                            return null;
                          },
                          onSaved: (String? input) {
                            inputValue = int.parse(input!);
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      SizedBox(
                        height: 50,
                        width: 130,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              _submit();
                            });
                            context
                                .read<CurrencyCubit>()
                                .fetchCurrency(value1!, value2!);
                          },
                          icon: const Icon(Icons.wifi_protected_setup),
                          label: const Text(
                            'Convert',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  DropdownMenuItem<String> dropDownItems(String item) {
    return DropdownMenuItem(
      value: item,
      child: Text(
        item,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
      ),
    );
  }

  String showExchangeRate(dynamic rate) {
    var result = context.watch<CurrencyCubit>().state.convertValue;
    if (inputValue == null) {
      return '0';
    } else {
      return '$inputValue $value1 = ${result * inputValue} $value2';
    }
  }
}
