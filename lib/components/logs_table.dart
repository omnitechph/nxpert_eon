import 'dart:convert';
import 'dart:io';

import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../services/logs_api_service.dart';
import '../widgets/buttons/custom_flat_button.dart';
import '../widgets/buttons/custom_icon_button.dart';
import 'page_buttons.dart';
import 'pagination_dropdown.dart';
import 'search_table_dialog.dart';

class LogsTable extends StatefulWidget {
  final String pageName;

  const LogsTable({super.key, required this.pageName});

  @override
  State<LogsTable> createState() => _LogsTableState();
}

class _LogsTableState extends State<LogsTable> {
  List<PlutoColumn> _columns = <PlutoColumn>[];
  List<PlutoRow> _rows = <PlutoRow>[];
  late PlutoGridStateManager _stateManager;
  int _rowsPerPage = 10;
  int _currentPage = 1;
  static const List<int> _perPageOptions = <int>[5, 10, 25, 50, 100, 500];
  List<PlutoRow> _checked = <PlutoRow>[];
  bool _isLoading = true;
  String _dateFrom = DateFormat('MM/dd/yyyy').format(DateTime.now());
  String _dateTo = DateFormat('MM/dd/yyyy').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        final List<dynamic> response = await LogsApiService().getLogs(
          widget.pageName == 'ADC'
              ? 'ADC'
              : widget.pageName == 'Machining'
              ? 'MACHINING'
              : 'NG',
          DateTime.now().toString(),
          DateTime.now().toString(),
        );
        final List<Map<String, dynamic>> items = List<Map<String, dynamic>>.from(response);
        setState(() {
          if (items.isNotEmpty) {
            final List<String> keys = items.first.keys.toList();
            _columns =
                keys
                    .map(
                      (String key) => PlutoColumn(
                    backgroundColor: const Color(0xFF00669E),
                    title: key,
                    field: key,
                    type: PlutoColumnType.text(),
                    enableSorting: true,
                    titleTextAlign: PlutoColumnTextAlign.center,
                    textAlign: PlutoColumnTextAlign.center,
                    enableEditingMode: false,
                    enableRowChecked: key == keys.first,
                  ),
                )
                    .toList();
            _rows = items.map((Map<String, dynamic> item) => PlutoRow(cells: <String, PlutoCell>{for (final String key in keys) key: PlutoCell(value: _formatValue(key, item[key]))})).toList();
          }
        });
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.red, content: Text('Error: $e')));
        }
      } finally {
        setState(() => _isLoading = false);
      }
    });
  }

  List<PlutoRow> get _paginatedRows {
    final int start = (_currentPage - 1) * _rowsPerPage;
    return _rows.skip(start).take(_rowsPerPage).toList();
  }

  int get _totalPages => (_rows.length / _rowsPerPage).ceil().clamp(1, double.infinity).toInt();

  int get _startEntry => (_currentPage - 1) * _rowsPerPage;

  int get _endEntry {
    final int end = _startEntry + _rowsPerPage;
    return end > _rows.length ? _rows.length : end;
  }

  String _formatValue(String key, dynamic value) {
    if (value == null) return '';
    final String stringValue = value.toString().trim();
    if (key.toLowerCase().contains('datetime')) {
      try {
        return stringValue.replaceAll('T', ' ').replaceAll('Z', '');
      } catch (_) {
        return stringValue;
      }
    } else if (key.toLowerCase().contains('time')) {
      try {
        return DateFormat('HH:mm:ss').format(DateTime.parse(stringValue));
      } catch (_) {
        return stringValue;
      }
    }
    return stringValue;
  }

  void _updatePaginatedRows() {
    _stateManager.removeAllRows();
    _stateManager.appendRows(_paginatedRows);
  }

  void _changePerPage(int? newSize) {
    if (newSize == null) return;
    _rowsPerPage = newSize;
    _currentPage = 1;
    if (_rows.isNotEmpty) _updatePaginatedRows();
    setState(() {});
  }

  void _prevPage() {
    if (_currentPage > 1) {
      _currentPage--;
      setState(() => _updatePaginatedRows());
    }
  }

  void _nextPage() {
    if (_currentPage < _totalPages) {
      _currentPage++;
      setState(() => _updatePaginatedRows());
    }
  }

  void _goToPage(int page) {
    _currentPage = page;
    setState(() => _updatePaginatedRows());
  }

  void _print() async {
    final List<Map<String, dynamic>> allCheckedData = _checked.map((PlutoRow row) => row.cells.map((String key, PlutoCell cell) => MapEntry<String, dynamic>(key, cell.value))).toList();
    if (allCheckedData.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No rows selected to print.')));
      return;
    }
    final pw.Document pdf = pw.Document();
    final List<String> headers = _columns.map((PlutoColumn c) => c.title).toList();
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.portrait,
        margin: const pw.EdgeInsets.all(20),
        build:
            (pw.Context context) => <pw.Widget>[
          pw.Table(
            border: pw.TableBorder.all(),
            defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
            children: <pw.TableRow>[
              pw.TableRow(
                children:
                headers
                    .map(
                      (String header) =>
                      pw.Container(alignment: pw.Alignment.center, padding: const pw.EdgeInsets.all(3), child: pw.Text(header, textAlign: pw.TextAlign.center, style: pw.TextStyle(fontSize: 6, fontWeight: pw.FontWeight.bold))),
                )
                    .toList(),
              ),
              ...allCheckedData.map((Map<String, dynamic> row) {
                return pw.TableRow(
                  children:
                  (_columns.map((PlutoColumn c) => row[c.field]).toList()).map((dynamic cell) {
                    return pw.Container(alignment: pw.Alignment.center, padding: const pw.EdgeInsets.all(3), child: pw.Text('${cell ?? ''}', textAlign: pw.TextAlign.center, style: const pw.TextStyle(fontSize: 6)));
                  }).toList(),
                );
              }),
            ],
          ),
        ],
      ),
    );
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }

  void _search() async {
    final List<dynamic> result = await showDialog(
      barrierDismissible: false,
      context: context,
      builder:
          (_) => SearchTableDialog(
        title:
        widget.pageName == 'ADC'
            ? 'Search ADC'
            : widget.pageName == 'Machining'
            ? 'Search Machining'
            : 'Search NG',
        dateFrom: _dateFrom,
        dateTo: _dateTo,
      ),
    );
    if (result[0] is List) {
      final List<Map<String, dynamic>> items = List<Map<String, dynamic>>.from(result[0]);
      _dateFrom = result[1];
      _dateTo = result[2];
      _currentPage = 1;
      _checked.clear();
      if (items.isNotEmpty) {
        final List<String> keys = items.first.keys.toList();
        _columns =
            keys
                .map(
                  (String key) => PlutoColumn(
                backgroundColor: const Color(0xFF00669E),
                title: key,
                field: key,
                type: PlutoColumnType.text(),
                enableSorting: true,
                titleTextAlign: PlutoColumnTextAlign.center,
                textAlign: PlutoColumnTextAlign.center,
                enableEditingMode: false,
                enableRowChecked: key == keys.first,
              ),
            )
                .toList();
        _rows = items.map((Map<String, dynamic> item) => PlutoRow(cells: <String, PlutoCell>{for (final String key in keys) key: PlutoCell(value: _formatValue(key, item[key]))})).toList();
      } else {
        _columns = <PlutoColumn>[];
        _rows = <PlutoRow>[];
      }
    }
    setState(() {});
  }

  void _saveToCsv() async {
    final List<PlutoRow> checkedRows = _rows.where((PlutoRow row) => row.checked == true).toList();
    if (checkedRows.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No rows selected to export.')));
      return;
    }
    final List<String> headers = _columns.map((PlutoColumn col) => col.field).toList();
    final StringBuffer csvData = StringBuffer();
    csvData.writeln(headers.join(','));
    for (final PlutoRow row in checkedRows) {
      final String rowValues = headers
          .map((String field) {
        final String value = row.cells[field]?.value.toString() ?? '';
        final String safeValue = value.toString().replaceAll('"', '""');
        return '"$safeValue"';
      })
          .join(',');
      csvData.writeln(rowValues);
    }
    final Uint8List bytes = Uint8List.fromList(utf8.encode(csvData.toString()));
    try {
      if (kIsWeb || Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
        await FileSaver.instance.saveFile(name: '${widget.pageName} Logs ${DateFormat('MMddyyyyhhmm').format(DateTime.now())}', bytes: bytes, ext: 'csv', mimeType: MimeType.csv);
      } else if (Platform.isAndroid || Platform.isIOS) {
        final Directory? directory = await getExternalStorageDirectory();
        final String filePath = '${directory!.path}/${widget.pageName} Logs ${DateFormat('MMddyyyyhhmm').format(DateTime.now())}.csv';
        final File file = File(filePath);
        await file.writeAsBytes(bytes);
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('CSV saved to $filePath')));
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error saving CSV: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Expanded(child: Center(child: CircularProgressIndicator()))
        : Expanded(
      child: Column(
        spacing: 8,
        children: <Widget>[
          LayoutBuilder(
            builder: (_, BoxConstraints constraints) {
              final bool isSmallScreen = constraints.maxWidth < 600;
              if (isSmallScreen) {
                return Column(
                  children: <Widget>[
                    Row(
                      spacing: 8,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        CustomIconButton(onPressed: _search, label: 'Search'),
                        CustomIconButton(onPressed: _rows.isEmpty ? null : _print, label: 'Print'),
                        CustomIconButton(onPressed: _rows.isEmpty ? null : _saveToCsv, label: 'Save'),
                        const SizedBox(width: 8),
                      ],
                    ),
                    PaginationDropdown(value: _rowsPerPage, options: _perPageOptions, onChanged: _changePerPage),
                  ],
                );
              } else {
                return Row(
                  spacing: 8,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    PaginationDropdown(value: _rowsPerPage, options: _perPageOptions, onChanged: _changePerPage),
                    Row(
                      spacing: 8,
                      children: <Widget>[
                        CustomIconButton(onPressed: _search, icon: const Icon(Icons.search, color: Colors.white, size: 18), label: 'Search'),
                        CustomIconButton(onPressed: _rows.isEmpty ? null : _print, icon: const Icon(Icons.print, color: Colors.white, size: 18), label: 'Print'),
                        CustomIconButton(onPressed: _rows.isEmpty ? null : _saveToCsv, icon: const Icon(Icons.save, color: Colors.white, size: 18), label: 'Save to CSV'),
                        const SizedBox(width: 8),
                      ],
                    ),
                  ],
                );
              }
            },
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Stack(
                children: <Widget>[
                  _rows.isNotEmpty
                      ? PlutoGrid(
                    key: ValueKey<int>(
                      _columns.length +
                          _rows.length +
                          DateFormat('MM/dd/yyyy').parse(_dateFrom).month +
                          DateFormat('MM/dd/yyyy').parse(_dateFrom).day +
                          DateFormat('MM/dd/yyyy').parse(_dateFrom).year +
                          DateFormat('MM/dd/yyyy').parse(_dateTo).month +
                          DateFormat('MM/dd/yyyy').parse(_dateTo).day +
                          DateFormat('MM/dd/yyyy').parse(_dateTo).year,
                    ),
                    columns: _columns,
                    rows: _paginatedRows,
                    onLoaded: (PlutoGridOnLoadedEvent event) => _stateManager = event.stateManager,
                    rowColorCallback: (PlutoRowColorContext ctx) => ctx.rowIdx.isEven ? const Color(0xFFD9E5F3) : Colors.white,
                    configuration: PlutoGridConfiguration(
                      scrollbar: const PlutoGridScrollbarConfig(scrollbarThickness: 10, scrollbarThicknessWhileDragging: 10, hoverWidth: 10),
                      style: PlutoGridStyleConfig(
                        activatedColor: Colors.lightGreenAccent.shade100,
                        borderColor: Colors.grey.shade400,
                        enableCellBorderVertical: true,
                        enableColumnBorderVertical: true,
                        columnTextStyle: const TextStyle(color: Colors.white),
                        columnHeight: 50,
                        enableRowColorAnimation: true,
                        rowHeight: 30,
                      ),
                      columnSize: const PlutoGridColumnSizeConfig(autoSizeMode: PlutoAutoSizeMode.equal),
                    ),
                    onRowChecked: (PlutoGridOnRowCheckedEvent event) {
                      _checked.removeWhere(_stateManager.unCheckedRows.toSet().contains);
                      _checked = <PlutoRow>{..._checked, ..._stateManager.checkedRows}.toList();
                    },
                  )
                      : Container(decoration: BoxDecoration(border: Border.all(color: const Color(0xFFA1A5AE)), color: Colors.white), child: const Center(child: Text('No data found.', style: TextStyle(fontSize: 16, color: Colors.grey)))),
                ],
              ),
            ),
          ),
          LayoutBuilder(
            builder: (_, BoxConstraints constraints) {
              final bool isSmallScreen = constraints.maxWidth < 600;
              if (isSmallScreen) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    spacing: 8,
                    children: <Widget>[
                      Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[Text('Showing ${(_rows.isEmpty ? 0 : _startEntry + 1)} to $_endEntry of ${_rows.length} entries')]),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          CustomFlatButton(onPressed: _currentPage > 1 ? () => _goToPage(1) : null, minimumSize: const Size(55, 36), label: 'First'),
                          CustomFlatButton(onPressed: _currentPage > 1 ? _prevPage : null, minimumSize: const Size(75, 36), label: 'Previous'),
                          PageButtons(currentPage: _currentPage, totalPages: _totalPages, onPageSelected: _goToPage),
                          CustomFlatButton(onPressed: _currentPage < _totalPages ? _nextPage : null, minimumSize: const Size(55, 36), label: 'Next'),
                          CustomFlatButton(onPressed: _currentPage < _totalPages ? () => _goToPage(_totalPages) : null, minimumSize: const Size(55, 36), label: 'Last'),
                        ],
                      ),
                    ],
                  ),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Showing ${(_rows.isEmpty ? 0 : _startEntry + 1)} to $_endEntry of ${_rows.length} entries'),
                      Row(
                        children: <Widget>[
                          CustomFlatButton(onPressed: _currentPage > 1 ? () => _goToPage(1) : null, minimumSize: const Size(55, 36), label: 'First'),
                          CustomFlatButton(onPressed: _currentPage > 1 ? _prevPage : null, minimumSize: const Size(75, 36), label: 'Previous'),
                          PageButtons(currentPage: _currentPage, totalPages: _totalPages, onPageSelected: _goToPage),
                          CustomFlatButton(onPressed: _currentPage < _totalPages ? _nextPage : null, minimumSize: const Size(55, 36), label: 'Next'),
                          CustomFlatButton(onPressed: _currentPage < _totalPages ? () => _goToPage(_totalPages) : null, minimumSize: const Size(55, 36), label: 'Last'),
                        ],
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
