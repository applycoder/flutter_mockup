# flutter_midi_pro

[![pub package](https://img.shields.io/pub/v/flutter_mockup.svg)](https://pub.dartlang.org/packages/flutter_mockup)[![GitHub stars](https://img.shields.io/github/stars/MelihHakanPektas/flutter_mockup.svg?style=social)](https://github.com/MelihHakanPektas/flutter_mockup)
[![GitHub issues](https://img.shields.io/github/issues/MelihHakanPektas/flutter_mockup.svg)](https://github.com/MelihHakanPektas/flutter_mockup/issues)

The `flutter_mockup` package provides a simple way to create mockups on flat surfaces with your desings and get a photo of it.

## Installation

This package including the screenshot package as a dependency. To use this plugin, add `flutter_mockup` and `screenshot` using terminal or pubspec.yaml file.

```bash
flutter pub add flutter_mockup
flutter pub add screenshot
```

### Usage

To use this package, follow the below steps:

1. Import the package in your Dart code:

```dart
import 'package:flutter_mockup/flutter_mockup.dart';
import 'package:screenshot/screenshot.dart';
```

2. Create a MockupController:

### Load SoundFont File

```dart
final MockupController _controller = MockupController(
  screenshotController: ScreenshotController(),
  backgroundUrl: 'assets/tshirt.png',
  designUrl: 'assets/design2.png',
);
```

3. Use MockupWidget to display your mockup:

```dart
MockupWidget(
  controller: _controller,
)
```

4. Capture and save the image:

```dart
final image = await _controller.screenshotController.capture();
// Your code to save image
```

## Example

Here's an example of how you could use the `flutter_mockup` package to create a mockup of a t-shirt design:

```dart
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
```

## Issues and Feedback

For any issues with the package, or for feedback, please file an issue on our GitHub repository.

## Contributions

Contributions are welcome! Please feel free to submit a PR or open an issue.

### Contact

If you have any questions or suggestions, feel free to contact the package maintainer, [Melih Hakan Pektas](https://github.com/MelihHakanPektas), via email or through GitHub.

![Melih Hakan Pektas](https://avatars.githubusercontent.com/u/108405689?s=100&v=4)

Thank you for contributing to flutter_piano_pro!

## License

This project is licensed under the MIT License. See the [LICENSE](https://github.com/MelihHakanPektas/flutter_mockup/blob/main/LICENSE) file for details.
