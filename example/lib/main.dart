import 'package:flutter/material.dart';
import 'package:flutter_mockup/flutter_mockup.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final MockupController _controller = MockupController(
    tshirtImage: 'assets/tshirt.png',
    logoImage: 'assets/design2.png',
  );
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: MockupWidget(
            controller: _controller,
          ),
        ),
      ),
    );
  }
}
