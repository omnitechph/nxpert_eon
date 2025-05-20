import 'package:flutter/material.dart';

class PaginationDropdown extends StatelessWidget {
  final int value;
  final List<int> options;
  final Function(int?) onChanged;

  const PaginationDropdown({
    super.key,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        const SizedBox(width: 16),
        const Text('Show '),
        FocusScope(
          child: DropdownButton<int>(
            alignment: Alignment.center,
            value: value,
            items: options.map((int n) => DropdownMenuItem<int>(value: n, child: Center(child: Text('$n')))).toList(),
            onChanged: (int? newSize) {
              onChanged(newSize);
              FocusScope.of(context).nextFocus();
            },
          ),
        ),
        const Text(' entries'),
      ],
    );
  }
}
