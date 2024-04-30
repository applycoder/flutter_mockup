library flutter_mockup;

import 'package:flutter/material.dart';
import 'package:flutter_mockup/src/editor_screen.dart';
import 'package:flutter_mockup/src/mockup_controller.dart';

export 'src/mockup_controller.dart';

class MockupWidget extends StatefulWidget {
  final MockupController controller;

  const MockupWidget({super.key, required this.controller});

  @override
  State<MockupWidget> createState() => _MockupWidgetState();
}

class _MockupWidgetState extends State<MockupWidget> {
  @override
  Widget build(BuildContext context) {
    return EditorScreen(controller: widget.controller);
  }
}
