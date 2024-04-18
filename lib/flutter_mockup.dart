library flutter_mockup;

import 'package:flutter/material.dart';
import 'package:flutter_mockup/src/mockup_controller.dart';

export 'src/mockup_controller.dart';

class MockupWidget extends StatefulWidget {
  final MockupController _controller;

  const MockupWidget({super.key, required MockupController controller}) : _controller = controller;

  @override
  State<MockupWidget> createState() => _MockupWidgetState();
}

class _MockupWidgetState extends State<MockupWidget> {
  final ValueNotifier<ImageInfo?> _image = ValueNotifier(null);
  @override
  void initState() {
    super.initState();

    final tshirtImage = Image.asset(widget._controller.value.tshirtImage);
    tshirtImage.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener(
        (info, _) {
          _image.value = info;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: _image,
        builder: (context, value, child) {
          if (value == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ValueListenableBuilder(
                valueListenable: widget._controller,
                builder: (context, value, child) {
                  return LayoutBuilder(builder: (context, constraints) {
                    return Stack(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Image.asset(
                            value.tshirtImage,
                            fit: BoxFit.contain,
                          ),
                        ),
                        Positioned(
                          left: value.logoPositionOffset.dx,
                          top: value.logoPositionOffset.dy,
                          child: Draggable(
                            onDragEnd: (details) {
                              widget._controller.value = value.copyWith(
                                logoPositionOffset: details.offset,
                              );
                            },
                            childWhenDragging: Container(),
                            feedback: _buildLogo(value),
                            child: _buildLogo(value),
                          ),
                        ),
                      ],
                    );
                  });
                });
          }
        });
  }

  Widget _buildLogo(MockupData value) {
    return Transform.scale(
      scale: value.logoScale,
      child: Transform.rotate(
        angle: value.logoRotation,
        child: Opacity(
          opacity: value.logoOpacity,
          child: Stack(
            children: [
              Positioned(
                  left: 0,
                  top: 0,
                  child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: value.logoBorderColor,
                          width: value.logoBorderWidth,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(value.logoShadow),
                            blurRadius: 10,
                          ),
                        ],
                      ))),
              Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: value.logoBorderColor,
                          width: value.logoBorderWidth,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(value.logoShadow),
                            blurRadius: 10,
                          ),
                        ],
                      ))),
              Positioned(
                  left: 0,
                  bottom: 0,
                  child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: value.logoBorderColor,
                          width: value.logoBorderWidth,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(value.logoShadow),
                            blurRadius: 10,
                          ),
                        ],
                      ))),
              Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: value.logoBorderColor,
                          width: value.logoBorderWidth,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(value.logoShadow),
                            blurRadius: 10,
                          ),
                        ],
                      ))),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Image.asset(
                  value.logoImage,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
