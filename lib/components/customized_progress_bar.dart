import 'package:circular_progress_stack/circular_progress_stack.dart';
import 'package:flutter/material.dart';

class CustomizedProgressBar extends StatelessWidget {
  const CustomizedProgressBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: SingleAnimatedStackCircularProgressBar(
                size: 200,
                progressStrokeWidth: 15,
                backStrokeWidth: 15,
                startAngle: 0,
                backColor: Color(0xffD7DEE7),
                barColor: Colors.blue,
                barValue: 99,
                textStyle: TextStyle(
                  color: Theme.of(context).colorScheme.tertiary,
                  fontSize: 20
                ),
                animationDuration: Duration(seconds: 5),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
              child: Text("Loading..."),
            ),
            Text("Please Wait"),
          ],
        ),
      ),
    );
  }
}
