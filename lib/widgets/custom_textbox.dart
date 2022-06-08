import 'package:flutter/material.dart';

class CustomTextBox extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPress;
  final String? value;
  const CustomTextBox(
      {Key? key,
      required this.child,
      required this.onPress,
      required this.value})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (_) {
            return Center(
              child: AlertDialog(
                title: const Text('Supported Currencies'),
                content: SizedBox(height: 70, width: 100, child: child),
                actions: [
                  TextButton(
                    onPressed: onPress,
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
            value!,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
