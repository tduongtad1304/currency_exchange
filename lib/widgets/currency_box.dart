import 'package:currency_exchange/widgets/search_choices_dialog.dart';
import 'package:flutter/material.dart';

class CurrencyBox extends StatelessWidget {
  final VoidCallback? onConfirmed;
  final String value;
  final Map<String, dynamic> items;
  final void Function(String?) onChanged;
  const CurrencyBox({
    Key? key,
    required this.onConfirmed,
    required this.value,
    required this.items,
    required this.onChanged,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (_) {
            return Center(
              child: AlertDialog(
                titlePadding:
                    const EdgeInsets.only(top: 20, left: 30, right: 20),
                title: const Text(
                  'Supported Currencies',
                  style: TextStyle(fontSize: 18),
                ),
                content: SizedBox(
                  height: 80,
                  width: 100,
                  child: SearchChoicesDialog(
                    items: items,
                    values: value,
                    onChanged: onChanged,
                  ),
                ),
                contentPadding:
                    const EdgeInsets.only(top: 20, left: 30, right: 20),
                actions: [
                  TextButton(
                    onPressed: onConfirmed,
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          },
        );
      },
      child: Container(
        width: 110,
        height: 55,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey, width: 3),
        ),
        child: Center(
          child: Text(
            value.toString(),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
