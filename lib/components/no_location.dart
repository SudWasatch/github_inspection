import 'package:flutter/material.dart';
import 'package:github_inspection/providers/providers.dart';
import 'package:provider/provider.dart';

class NoLocation extends StatefulWidget {
  final String pagename;
  const NoLocation({super.key, required this.pagename});

  @override
  State<NoLocation> createState() => _NoLocationState();
}

class _NoLocationState extends State<NoLocation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool loading = true, _onLocation = false;

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

    return Center(
      child: SizedBox(
        height: deviceHeight * 0.6,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _onLocation ? Icons.location_on : Icons.location_off,
              color: _onLocation ? Colors.green : Colors.red,
              size: 50,
            ),
            Text(
              "You are out of location range",
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
