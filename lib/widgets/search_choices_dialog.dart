import 'package:flutter/material.dart';
import 'package:search_choices/search_choices.dart';

class SearchChoicesDialog extends StatelessWidget {
  const SearchChoicesDialog({
    Key? key,
    required this.items,
    required this.values,
    required this.onChanged,
  }) : super(key: key);

  final Map<String, dynamic> items;
  final String values;
  final void Function(String)? onChanged;
  @override
  Widget build(BuildContext context) {
    return SearchChoices.single(
      autofocus: false,
      displayClearIcon: false,
      items: items
          .map((key, value) => MapEntry(key, _dropDownItems(key, value)))
          .values
          .toList(),
      value: values,
      hint: "Select one",
      searchHint: "Search one",
      closeButton: '',
      doneButton: TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Text('Done'),
      ),
      onChanged: onChanged,
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
    );
  }

  DropdownMenuItem<dynamic> _dropDownItems(dynamic key, dynamic value) {
    return DropdownMenuItem(
      value: key,
      child: Text(
        '$key - $value',
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
      ),
    );
  }
}
