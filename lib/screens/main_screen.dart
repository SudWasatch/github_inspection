import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:github_inspection/components/app_header.dart';
import 'package:github_inspection/components/appbar.dart';
import 'package:github_inspection/components/customized_progress_bar.dart';
import 'package:github_inspection/components/dialogs.dart';
import 'package:github_inspection/providers/providers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Map<int, bool> proximityMap = {};
  bool loading = true;
  Map<String, dynamic> allinspections = {};

  @override
  void initState() {
    super.initState();
    checkAllLocations(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> checkAllLocations(BuildContext context) async {
    allinspections = (Provider.of<ALLInspectionProvider>(
      context,
      listen: false,
    ).allinspections);
    final position = await Geolocator.getCurrentPosition(
      locationSettings: AndroidSettings(accuracy: LocationAccuracy.high),
    );

    final data = allinspections["Data"] as List<dynamic>?;
    if (data != null) {
      for (int i = 0; i < data.length; i++) {
        final item = data[i] as Map<String, dynamic>;
        double dist = Geolocator.distanceBetween(
          (item["latitude"] as num).toDouble(),
          (item["longitude"] as num).toDouble(),
          position.latitude,
          position.longitude,
        );

        proximityMap[i] = dist <= 200;
      }
    }
    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  String formateDate(String serverDateStr) {
    String sanitizedStr = serverDateStr.replaceFirstMapped(
      // ignore: deprecated_member_use
      RegExp(r'\.\d{7}'),
      (match) => '.000000',
    );

    DateTime parsedDate = DateTime.parse(sanitizedStr).toLocal();

    return DateFormat('dd-MM-yyyy').format(parsedDate);
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    double horizontalPadding = deviceWidth * 0.03;
    double verticalPadding = deviceHeight * 0.015;

    final anyCardValid = proximityMap.values.any((allowed) => allowed);
    final item = allinspections;

    if (loading ||
        item.isEmpty ||
        item["Data"] == null ||
        item["Data"].isEmpty) {
      return CustomizedProgressBar();
    }

    final String name = item["Data"][0]["incharge"] ?? "N/A";
    final String designation = item["Data"][0]["designation"] ?? "N/A";
    final String mobileNo = item["Data"][0]["mobileNo"] ?? "N/A";
    final String showDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

    return Scaffold(
      appBar: AppbarWidget(str: "Inspections"),
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          try {
            if (!didPop) {
              final shouldExit = await showExitDialog(
                context,
                "Do you want to return to Login Page?",
              );
              if (shouldExit) {
                // ignore: use_build_context_synchronously
                Navigator.pushNamed(context, "/ls");
              }
            }
          } catch (e) {
            debugPrint(e.toString());
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(horizontalPadding),
            child: Column(
              children: [
                AppHeader(),
                SizedBox(height: verticalPadding),
                Container(
                  decoration: BoxDecoration(),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Welcome: ${name.toUpperCase()}',
                          style: GoogleFonts.poppins(
                            shadows: [
                              Shadow(
                                color: Colors.blueGrey.withValues(alpha: 0.5),
                                offset: Offset(3, 3),
                                blurRadius: 10,
                              ),
                            ],
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                            wordSpacing: 2.0,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Designation: ${designation.toUpperCase()}',
                          style: GoogleFonts.poppins(
                            shadows: [
                              Shadow(
                                color: Colors.blueGrey.withValues(alpha: 0.5),
                                offset: Offset(3, 3),
                                blurRadius: 10,
                              ),
                            ],
                            // fontSize: 17.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                            wordSpacing: 2.0,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Mobile No: $mobileNo',
                          style: GoogleFonts.poppins(
                            shadows: [
                              Shadow(
                                color: Colors.blueGrey.withValues(alpha: 0.5),
                                offset: Offset(3, 3),
                                blurRadius: 10,
                              ),
                            ],
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                            wordSpacing: 2.0,
                          ),
                        ),
                        SizedBox(height: 8),
                        // Date Text
                        Text(
                          'Date: $showDate',
                          style: GoogleFonts.poppins(
                            shadows: [
                              Shadow(
                                color: Colors.blueGrey.withValues(alpha: 0.5),
                                offset: Offset(3, 3),
                                blurRadius: 10,
                              ),
                            ],
                            // fontSize: 17.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                            wordSpacing: 2.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: verticalPadding),
                if (!anyCardValid)
                  Container(
                    padding: const EdgeInsets.all(12),
                    color: Colors.red.shade100,
                    child: Column(
                      children: [
                        Text(
                          "आप लोकेशन से दूर है।",
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "You are away from location",
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pushNamed(
                              // ignore: use_build_context_synchronously
                              context,
                              "/gs",
                            );
                          },
                          icon: Icon(
                            Icons.refresh,
                            color: Theme.of(context).colorScheme.surface,
                          ),
                          label: Text(
                            "Retry",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.surface,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.tertiary,
                            iconColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                Column(
                  children: allinspections["Data"].asMap().entries.map<Widget>((
                    entry,
                  ) {
                    final index = entry.key;
                    final item = entry.value;
                    debugPrint(index.toString());
                    // debugPrint(item);
                    final isNearby = proximityMap[index] ?? false;

                    return GestureDetector(
                      onTap: isNearby
                          ? () {
                              Provider.of<InspectionProvider>(
                                // ignore: use_build_context_synchronously
                                context,
                                listen: false,
                              ).setInspection(item);

                              Provider.of<LatProvider>(
                                // ignore: use_build_context_synchronously
                                context,
                                listen: false,
                              ).setLatitude(item["latitude"]);
                              Provider.of<LongProvider>(
                                // ignore: use_build_context_synchronously
                                context,
                                listen: false,
                              ).setLongitude(item["longitude"]);
                              Navigator.pushNamed(context, "/hs");
                            }
                          : null,
                      child: Card(
                        elevation: 10,
                        color: Theme.of(context).colorScheme.surface,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: BorderSide(
                            color: isNearby ? Colors.green : Colors.red,
                            width: 2,
                          ),
                        ),
                        margin: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 4,
                        ),
                        child: ListTile(
                          enabled: isNearby,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          leading: CircleAvatar(
                            backgroundColor: isNearby
                                ? Theme.of(context).colorScheme.tertiary
                                : Colors.red,
                            child: const Icon(Icons.assignment),
                          ),
                          title: Padding(
                            padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "District : ${item["DistName"].toUpperCase()}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Area : ${item["Name"]}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "InsId : ${item["inspectionID"]}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 6),
                                Text(
                                  "From Date : ${formateDate(item["FromDate"])}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "To Date      : ${formateDate(item["ToDate"])}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (!isNearby)
                                  const Padding(
                                    padding: EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      "You are out of range",
                                      style: TextStyle(
                                        color: Colors.redAccent,
                                        fontWeight: FontWeight.bold,
                                        // fontSize: 16,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
