import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_mockup/flutter_mockup.dart';
import 'package:screenshot/screenshot.dart';

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
    screenshotController: ScreenshotController(),
    backgroundUrl: 'assets/tshirt.png',
    designUrl: 'assets/design2.png',
  );

  getBytesOfMockup() async {
    final image = await _controller.screenshotController.capture();
    return image;
  }

  Future saveImage(Uint8List image) async {
    final bytes = getBytesOfMockup();
    //TODO: Your code to save image
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: Center(
                child: MockupWidget(
                  controller: _controller,
                ),
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  final image = await _controller.screenshotController.capture();
                  saveImage(image!);
                },
                child: const Text('Save Image'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
