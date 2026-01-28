import 'package:flutter/material.dart';
import 'package:github_inspection/providers/providers.dart';
import 'package:provider/provider.dart';

class NoInternet extends StatefulWidget {
  final String pagename;
  const NoInternet({super.key, required this.pagename});

  @override
  State<NoInternet> createState() => _NoInternetState();
}

class _NoInternetState extends State<NoInternet>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void refreshPage(String pgName) {
    Navigator.pushNamed(context, pgName);
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;

    final internetStatus = Provider.of<ConnectivityProvider>(
      context,
    ).hasInternetConnection;

    return Center(
      child: SizedBox(
        height: deviceHeight * 0.6,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              internetStatus ? Icons.wifi : Icons.wifi_off,
              color: internetStatus ? Colors.green : Colors.red,
              size: 50,
            ),
            Text(
              "No internet connectivity",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 10),
            FilledButton.icon(
              onPressed: () {
                refreshPage(widget.pagename);
              },
              icon: const Icon(Icons.refresh),
              label: Text(
                "Retry",
                style: TextStyle(color: Theme.of(context).colorScheme.surface),
              ),
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(
                  Theme.of(context).colorScheme.tertiary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
