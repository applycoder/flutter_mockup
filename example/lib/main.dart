import 'dart:html' as html;
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
    tshirtImage: 'assets/tshirt.png',
    logoImage: 'assets/design2.png',
  );

  void saveImage(Uint8List image) {
    final blob = html.Blob([image]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    html.AnchorElement(href: url)
      ..setAttribute('download', 'mockup.png')
      ..click();
    html.Url.revokeObjectUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Row(
            children: [
              Expanded(
                child: MockupWidget(
                  controller: _controller,
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  final image = await _controller.screenshotController.capture();
                  saveImage(image!);
                },
                child: const Text('Save Image'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
