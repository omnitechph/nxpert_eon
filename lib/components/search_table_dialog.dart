import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/logs_api_service.dart';
import '../widgets/buttons/custom_icon_button.dart';

class SearchTableDialog extends StatefulWidget {
  final String title;
  final String dateFrom;
  final String dateTo;

  const SearchTableDialog({super.key, required this.title, required this.dateFrom, required this.dateTo});

  @override
  State<SearchTableDialog> createState() => _SearchTableDialogState();
}

class _SearchTableDialogState extends State<SearchTableDialog> {
  late final TextEditingController _dateFromController = TextEditingController();
  late final TextEditingController _dateToController = TextEditingController();
  bool _isLoading = false;

  Future<void> _selectDate(BuildContext context, TextEditingController date) async {
    final List<String> dateParts = date.text.split('/');
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(int.parse(dateParts[2]), int.parse(dateParts[0]), int.parse(dateParts[1])),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF0099FC), onPrimary: Colors.white, onSurface: Colors.black),
            textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(textStyle: const TextStyle(fontWeight: FontWeight.bold), foregroundColor: Colors.black, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero))),
            datePickerTheme: const DatePickerThemeData(shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero), backgroundColor: Colors.white, surfaceTintColor: Colors.transparent),
            dialogTheme: const DialogThemeData(backgroundColor: Colors.white),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      setState(() => date.text = DateFormat('MM/dd/yyyy').format(pickedDate));
    }
  }

  @override
  void initState() {
    super.initState();
    _dateFromController.text = widget.dateFrom;
    _dateToController.text = widget.dateTo;
  }

  @override
  void dispose() {
    _dateFromController.dispose();
    _dateToController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Stack(
        children: <Widget>[
          Container(
            width: 600,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(12),
                  color: const Color(0xFF0099FC),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[Text(widget.title, style: const TextStyle(color: Colors.white, fontSize: 18)), IconButton(icon: const Icon(Icons.close, color: Colors.white), onPressed: () => Navigator.pop(context))],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: _dateFromController,
                          readOnly: true,
                          decoration: const InputDecoration(labelText: 'Date From (MM/dd/yyyy)'),
                          onTap: () {
                            if (_dateFromController.text.isEmpty) _dateFromController.text = DateFormat('MM/dd/yyyy').format(DateTime.now());
                            _selectDate(context, _dateFromController);
                          },
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: TextField(
                          controller: _dateToController,
                          readOnly: true,
                          decoration: const InputDecoration(labelText: 'Date To (MM/dd/yyyy)'),
                          onTap: () {
                            if (_dateToController.text.isEmpty) _dateToController.text = DateFormat('MM/dd/yyyy').format(DateTime.now());
                            _selectDate(context, _dateToController);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  color: const Color(0xFF0099FC),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      CustomIconButton(
                        onPressed: () {
                          _dateFromController.clear();
                          _dateToController.clear();
                        },
                        label: 'Reset',
                        backgroundColor: const Color(0xFFDD4B39),
                        borderRadius: 4,
                      ),
                      CustomIconButton(
                        onPressed: () async {
                          if (_dateFromController.text.isNotEmpty && _dateToController.text.isNotEmpty) {
                            setState(() => _isLoading = true);
                            try {
                              final List<dynamic> response = await LogsApiService().getLogs(
                                widget.title.contains('ADC')
                                    ? 'ADC'
                                    : widget.title.contains('Machining')
                                    ? 'MACHINING'
                                    : 'NG',
                                _dateFromController.text,
                                _dateToController.text,
                              );
                              if (context.mounted) {
                                Navigator.pop(context, <Object>[response, _dateFromController.text, _dateToController.text]);
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.red, content: Text('Error: $e')));
                              }
                            } finally {
                              setState(() => _isLoading = false);
                            }
                          }
                        },
                        label: 'Search',
                        backgroundColor: const Color(0xFF3C8DBC),
                        borderRadius: 4,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (_isLoading) Positioned.fill(child: Container(color: Colors.black.withValues(alpha: 0.4), child: const Center(child: CircularProgressIndicator()))),
        ],
      ),
    );
  }
}
