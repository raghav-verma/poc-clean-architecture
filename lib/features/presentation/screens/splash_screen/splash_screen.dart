import 'package:flutter/material.dart';

/// Minimal splash screen for projects that want a startup route.
class SplashScreen extends StatelessWidget {
  final String message;

  const SplashScreen({super.key, this.message = 'Loading...'});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 12),
            Text(message),
          ],
        ),
      ),
    );
  }
}
