library flutter_mockup;

import 'package:flutter/material.dart';
import 'package:flutter_mockup/src/logo2.dart';
import 'package:flutter_mockup/src/mockup_controller.dart';

export 'src/mockup_controller.dart';

class MockupWidget extends StatefulWidget {
  final MockupController _controller;

  MockupWidget({super.key, MockupController? controller})
      : _controller = controller ??
            MockupController(
              tshirtImage: '',
              logoImage: '',
            );

  @override
  State<MockupWidget> createState() => _MockupWidgetState();
}

class _MockupWidgetState extends State<MockupWidget> {
  @override
  Widget build(BuildContext context) {
    return Logo2(controller: widget._controller);
  }
}
