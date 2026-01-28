import 'package:flutter/material.dart';
import 'package:github_inspection/api_calls/modal_responses.dart';
import 'package:github_inspection/components/app_header.dart';
import 'package:github_inspection/components/appbar.dart';
import 'package:github_inspection/components/no_internet.dart';
import 'package:github_inspection/components/no_location.dart';
import 'package:github_inspection/components/searchable_drop_down.dart';
import 'package:github_inspection/components/show_data_in_row.dart';
import 'package:github_inspection/providers/providers.dart';
import 'package:provider/provider.dart';

class FirstInspection extends StatefulWidget {
  const FirstInspection({super.key});

  @override
  State<FirstInspection> createState() => _FirstInspectionState();
}

class _FirstInspectionState extends State<FirstInspection> {
  final _formKey = GlobalKey<FormState>();

  bool _showSubmit = false,
      _shouldShow = false,
      loading = true,
      _onLocation = false;
  List<DropdownItem>? bookings, timings;
  DropdownItem? selectedBooking, selectedTiming;
  final List<Map<String, dynamic>> _rows = [];

  @override
  void initState() {
    _loadBookings();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loadBookings() async {
    try {
      final data = {
        "Table": [
          {"ID": 1, "Name": "Safari"},
          {"ID": 2, "Name": "Visitor"},
        ],
      };
      final loadedBookings = (data['Table'] as List)
          .map(
            (item) => DropdownItem(
              id: item["ID"].toString(),
              name: item["Name"] ?? '',
            ),
          )
          .toList();
      setState(() {
        bookings = loadedBookings;
      });
    } catch (e) {
      setState(() {
        bookings = [];
      });
    }
  }

  Future<void> _onBookingSelected(DropdownItem item) async {
    setState(() {
      selectedBooking = item;
    });
    try {
      final data1 = {
        "Table": [
          {"ID": 1, "Name": "8 AM to 4 PM"},
          {"ID": 2, "Name": "4 PM to 12 AM"},
          {"ID": 3, "Name": "12 AM to 8 PM"},
        ],
      };
      final data2 = {
        "Table": [
          {"ID": 1, "Name": "8 AM to 10 AM"},
          {"ID": 2, "Name": "10 AM to 12 PM"},
          {"ID": 3, "Name": "12 PM to 2 PM"},
          {"ID": 4, "Name": "2 PM to 4 PM"},
          {"ID": 5, "Name": "4 PM to 6 PM"},
        ],
      };
      List<DropdownItem> loadedtimings;
      if (selectedBooking!.name == "Safari") {
        loadedtimings = getData(data1);
      } else {
        loadedtimings = getData(data2);
      }
      setState(() {
        timings = loadedtimings;
      });
    } catch (_) {
      setState(() {
        timings = [];
      });
    }
  }

  Future<void> _onTimingSelected(DropdownItem item) async {
    setState(() {
      selectedTiming = item;
    });
  }

  List<DropdownItem> getData(Map<String, List<Map<String, Object>>> dt) {
    return (dt['Table'] as List)
        .map(
          (item) =>
              DropdownItem(id: item["ID"].toString(), name: item["Name"] ?? ''),
        )
        .toList();
  }

  Future<void> _addRowAndConfirm() async {
    if (_formKey.currentState!.validate()) {
      bool isDuplicateData = _rows.any(
        (row) =>
            row["booking"] == selectedBooking!.name &&
            row["timing"] == selectedTiming!.name,
      );
      if (isDuplicateData) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Duplicate entry detected. Please verify & Re Enter"),
          ),
        );
        _shouldShow = false;
        return;
      } else {
        setState(() {
          _rows.add({
            "booking": selectedBooking?.name ?? "",
            "booking_id": selectedBooking?.id ?? "",
            "timing": selectedTiming?.name ?? "",
            "timing_id": selectedTiming?.id ?? "",
          });
          _shouldShow = true;
        });
        if (_shouldShow) {
          final result = await showDialog<String>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text("Add Entry"),
              content: const Text("Do you want to add more?"),
              actions: [
                ElevatedButton(
                  style: ButtonStyle(
                    elevation: WidgetStateProperty.resolveWith<double>((
                      Set<WidgetState> states,
                    ) {
                      if (states.contains(WidgetState.pressed)) {
                        return 10.0;
                      }
                      return 5.0;
                    }),
                  ),
                  onPressed: () => Navigator.pop(ctx, "add_more"),
                  child: Text(
                    "Ok",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                ),
              ],
            ),
          );
          if (result == "add_more") {
            _showSubmit = true;
            _resetInputs();
            _loadBookings();
          }
        }
      }
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select all required values')),
      );
    }
  }

  void _resetInputs() {
    setState(() {
      selectedBooking = selectedTiming = null;
      bookings = timings = null;
      // _manakController.clear();
      // _amanakController.clear();
      // _avikrayaController.clear();
      // _manakMT.clear();
      // _amanakMT.clear();
      // _avikrayaMT.clear();
      // _remarkController.clear();
    });
  }

  Set<String> findDuplicates(List<Map<String, dynamic>> data) {
    final seen = <String>{}, duplicates = <String>{};
    for (var item in data) {
      final key = "${item['booking']}_${item['timing']}";
      if (seen.contains(key)) {
        duplicates.add(key);
      } else {
        seen.add(key);
      }
    }
    return duplicates;
  }

  void _deleteRow(int index) {
    setState(() {
      _rows.removeAt(index);
      if (_rows.isEmpty) _showSubmit = false;
    });
  }

  
  void _submitForm() {
    if (_rows.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("No data to submit")));
      return;
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("$_rows")));
    }
  }


  @override
  Widget build(BuildContext context) {
    final filtered = Provider.of<InspectionProvider>(context).inspection;
    final duplicates = findDuplicates(_rows);

    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    // Responsive paddings and sizes
    double horizontalPadding = deviceWidth * 0.03;
    double verticalPadding = deviceHeight * 0.015;

    final internetStatus = Provider.of<ConnectivityProvider>(
      context,
    ).hasInternetConnection;

    final locationValue = Provider.of<LocationProvider>(context).value;
    if (locationValue == "Yes") {
      setState(() {
        _onLocation = true;
        loading = false;
      });
    } else {
      setState(() {
        _onLocation = false;
        loading = false;
      });
    }

    return Scaffold(
      appBar: AppbarWidget(str: "First Inspection"),
      body: PopScope(
        canPop: false,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              vertical: verticalPadding,
              horizontal: horizontalPadding,
            ),
            child: !internetStatus
                ? NoInternet(pagename: "/fi")
                : !_onLocation
                ? NoLocation(pagename: "/fi")
                : Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        AppHeader(),
                        SizedBox(height: verticalPadding),
                        ShowDataInRow(
                          str1: 'District',
                          str2: filtered["DistName"],
                        ),
                        SizedBox(height: verticalPadding),
                        ShowDataInRow(str1: 'Area', str2: filtered["Name"]),
                        SizedBox(height: verticalPadding),
                        SearchableDropdown(
                          label: 'Booking',
                          items: bookings,
                          selected: selectedBooking,
                          onChanged: _onBookingSelected,
                          hint: 'Choose booking',
                        ),
                        SizedBox(height: verticalPadding),
                        SearchableDropdown(
                          label: 'Timings',
                          items: timings,
                          selected: selectedTiming,
                          onChanged: _onTimingSelected,
                          hint: 'Choose timing',
                        ),
                        SizedBox(height: verticalPadding),
                        SizedBox(height: verticalPadding),
                        FilledButton.icon(
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(
                              Theme.of(context).colorScheme.tertiary,
                            ),
                          ),
                          onPressed: _addRowAndConfirm,
                          label: Text(
                            "Add",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.surface,
                            ),
                          ),
                          icon: Icon(
                            Icons.add,
                            color: Theme.of(context).colorScheme.surface,
                          ),
                        ),
                        SizedBox(height: verticalPadding),
                        if (_rows.isNotEmpty)
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: SizedBox(
                              width: 800,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Card(
                                  elevation: 10.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: DataTable(
                                    border: TableBorder.all(
                                      width: 1,
                                      color: Colors.black45,
                                    ),
                                    columnSpacing: 16.0,
                                    dividerThickness: 1.5,
                                    dataRowMaxHeight: 60.0,
                                    headingRowColor: WidgetStateProperty.all(
                                      Colors.orange,
                                    ),
                                    columns: [
                                      DataColumn(label: _tableHeader("Sr. No")),
                                      DataColumn(
                                        label: _tableHeader("Purpose"),
                                      ),
                                      DataColumn(label: _tableHeader("Timing")),
                                      DataColumn(label: _tableHeader("Delete")),
                                    ],
                                    rows: _rows.asMap().entries.map((entry) {
                                      final idx = entry.key, row = entry.value;
                                      final key =
                                          "${row['booking']}_${row['timing']}";
                                      final isDuplicate = duplicates.contains(
                                        key,
                                      );
                                      return DataRow(
                                        color: WidgetStateProperty.all(
                                          Colors.white,
                                        ),
                                        cells: [
                                          DataCell(
                                            _tableCell(
                                              (idx + 1).toString(),
                                              isDuplicate,
                                            ),
                                          ),
                                          DataCell(
                                            _tableCell(
                                              row["booking"]!,
                                              isDuplicate,
                                            ),
                                          ),
                                          DataCell(
                                            _tableCell(
                                              row["timing"]!,
                                              isDuplicate,
                                            ),
                                          ),
                                          DataCell(
                                            IconButton(
                                              icon: const Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ),
                                              onPressed: () => _deleteRow(idx),
                                            ),
                                          ),
                                        ],
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                                                  SizedBox(height: verticalPadding),
                        if (_showSubmit)
                          FilledButton.icon(
                            onPressed: _submitForm,
                            icon: Icon(Icons.send),
                            label: Text(
                              "Submit",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.surface,
                              ),
                            ),
                            style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(
                                Theme.of(context).colorScheme.tertiary,
                              ),
                            ),
                          ),

                        SizedBox(height: verticalPadding),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _tableHeader(String text) => Expanded(
    child: Container(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        softWrap: true,
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black87,
          fontSize: 14.0,
        ),
      ),
    ),
  );

  Widget _tableCell(String text, bool isDuplicate) => Container(
    padding: const EdgeInsets.all(8.0),
    child: Text(
      softWrap: true,
      text,
      style: TextStyle(color: isDuplicate ? Colors.red : Colors.black),
    ),
  );
}
