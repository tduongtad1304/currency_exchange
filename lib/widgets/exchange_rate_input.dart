import 'package:flutter/material.dart';

class ExchangeRateInput extends StatelessWidget {
  const ExchangeRateInput({
    Key? key,
    this.onChanged,
    required this.onSubmitted,
    required this.onSaved,
  }) : super(key: key);
  final void Function(String)? onChanged;
  final void Function()? onSubmitted;
  final void Function(String?)? onSaved;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 100),
          child: Container(
            width: 200,
            height: 80,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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
                if (input?.isEmpty ?? true) {
                  return 'Please enter a valid amount';
                }
                return null;
              },
              onChanged: onChanged,
              onSaved: onSaved,
            ),
          ),
        ),
        const SizedBox(height: 40),
        SizedBox(
          height: 50,
          width: 180,
          child: ElevatedButton.icon(
            onPressed: onSubmitted,
            icon: const Icon(Icons.wifi_protected_setup),
            label: const Text(
              'Convert',
              style: TextStyle(fontSize: 18),
            ),
            style: ElevatedButton.styleFrom(elevation: 7),
          ),
        ),
      ],
    );
  }
}
