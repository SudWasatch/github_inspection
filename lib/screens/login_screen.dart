import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:github_inspection/api_calls/modal_responses.dart';
import 'package:github_inspection/components/dialogs.dart';
import 'package:github_inspection/providers/providers.dart';
import 'package:github_inspection/providers/theme_state.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  late final data = {
    "Data": [
      {
        "inspectionID": "IND 1",
        "incharge": "Jhon Doe",
        "designation": "Incharge",
        "mobileNo": phoneController.text,
        "DistName": "Bhopal",
        "Name": "Van Vihar",
        "Address":
            "Van Vihar National Park Bhopal",
        "latitude": 23.2290,
        "longitude": 77.3640,
        "FromDate": "2026-01-12T00:00:00.0000000+05:30",
        "ToDate": "2026-01-31T00:00:00.0000000+05:30",
      },
      {
        "inspectionID": "IND 2",
        "incharge": "Jhon Doe",
        "designation": "Incharge",
        "mobileNo": phoneController.text,
        "DistName": "Bhopal",
        "Name": "Kerwa Dam",
        "Address": "Kerwa Dam Bhopal",
        "latitude": 23.16647,
        "longitude": 77.3721,
        "FromDate": "2026-01-12T00:00:00.0000000+05:30",
        "ToDate": "2026-01-31T00:00:00.0000000+05:30",
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    double horizontalPadding = deviceWidth * 0.03;
    double verticalPadding = deviceHeight * 0.015;
    double imageScale = deviceWidth < 400 ? 3 : 2;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        try {
          if (!didPop) {
            final shouldExit = await showExitDialog(
              context,
              "Are you sure you want to exit the app?",
            );
            if (shouldExit) {
              exit(0);
            }
          }
        } catch (e) {
          debugPrint(e.toString());
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: ThemeStateApp(),
          centerTitle: true,
          title: Text("Login"),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(horizontalPadding),
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(horizontalPadding),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    SizedBox(height: verticalPadding),
                    Image.asset("assets/img.png", scale: imageScale),
                    SizedBox(height: verticalPadding),
                    Center(
                      child: TextField(
                        autofocus: true,
                        controller: phoneController,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          labelStyle: TextStyle(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                          hintText: 'Enter your phone number here',
                          hintStyle: TextStyle(color: Colors.red),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.outline,
                              width: 2.0,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                          ),
                          prefixIcon: const Icon(Icons.phone),
                        ),
                      ),
                    ),
                    SizedBox(height: verticalPadding),
                    Center(
                      child: ElevatedButton.icon(
                        icon: Icon(
                          Icons.login,
                          color: Theme.of(context).colorScheme.surface,
                        ),
                        label: Text(
                          'Login',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.surface,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.tertiary,
                        ),
                        onPressed: () async {
                          try {
                            if (phoneController.text.isNotEmpty) {
                              if (phoneController.text.length < 10) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Please enter valid 10 digit phone number",
                                    ),
                                  ),
                                );
                                return;
                              }
                              final response = UserData(data: data);

                              setState(() {
                                Provider.of<ALLInspectionProvider>(
                                  // ignore: use_build_context_synchronously
                                  context,
                                  listen: false,
                                ).setInspections(response.data);
                                Provider.of<ALLInspectionProvider>(
                                  // ignore: use_build_context_synchronously
                                  context,
                                  listen: false,
                                ).setMobileNumber(phoneController.text);
                              });
                              Navigator.pushNamed(
                                // ignore: use_build_context_synchronously
                                context,
                                "/gs",
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Please Enter Registered Phone Number",
                                  ),
                                ),
                              );
                            }
                          } catch (e) {
                            debugPrint(e.toString());
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
