import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

void showSettingsDialog(BuildContext context, String txt1, String txt2) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment
            .center,
        children: [
          Image.asset('assets/img.png', scale: 7),
          SizedBox(width: 10),
          Text(
            "Inspection Mobile-App",
            style: TextStyle(overflow: TextOverflow.clip),
          ),
        ],
      ),
      content: Text(
        "$txt1 access has been permanently denied. "
        "To continue, please enable $txt2 permission in your app settings.",
        style: TextStyle(fontSize: 15, height: 1.4),
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text("Cancel", style: TextStyle(color: Colors.red)),
        ),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () async {
            Navigator.of(context).pop();
            await openAppSettings();
          },
          icon: const Icon(Icons.settings, size: 18, color: Colors.white),
          label: const Text(
            "Open Settings",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    ),
  );
}

Future<bool> showExitDialog(BuildContext context, String val) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.surface,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment
            .center,
        children: [
          Image.asset('assets/img.png', scale: 7),
          SizedBox(width: 10),
          Text(
            "Inspection Mobile-App",
            style: TextStyle(overflow: TextOverflow.clip),
          ),
        ],
      ),
      content: Text(val, textAlign: TextAlign.start),
      actions: [
        Container(
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(15),
          ),
          child: TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("Cancel", style: TextStyle(color: Colors.white)),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(15),
          ),
          child: TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text("Yes", style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    ),
  );
  return result ?? false;
}

void showMismatchDialog(
  BuildContext context,
  String txt1,
  String txt2,
  String screenName,
) {
  showDialog(
    context: context,
    builder: (context) => Center(
      child: AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        icon: Icon(Icons.warning, color: Colors.amber, size: 80.0),
        title: Row(
        crossAxisAlignment: CrossAxisAlignment
            .center,
        children: [
          Image.asset('assets/img.png', scale: 7),
          SizedBox(width: 10),
          Text(
            "Inspection Mobile-App",
            style: TextStyle(overflow: TextOverflow.clip),
          ),
        ],
      ),
        actions: [
          Center(
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              onPressed: () {
                Navigator.pushNamed(context, screenName);
              },
              child: const Text("OK", style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    ),
  );
}

void dismissLoadingDialog(BuildContext context) {
  Navigator.of(context, rootNavigator: true).pop();
}

void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return const Dialog(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text("Please wait \n Do not press any button \n Saving..."),
            ],
          ),
        ),
      );
    },
  );
}

void showInfoDialog(BuildContext context, String title, String message) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.surface,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment
            .center,
        children: [
          Image.asset('assets/img.png', scale: 7),
          SizedBox(width: 10),
          Text(
            "Inspection Mobile-App",
            style: TextStyle(overflow: TextOverflow.clip),
          ),
        ],
      ),
      content: Text(message, textAlign: TextAlign.center),
      actions: [
        TextButton(
          onPressed: () => Navigator.pushNamed(context, "/hs"),
          child: const Text("OK"),
        ),
      ],
    ),
  );
}
