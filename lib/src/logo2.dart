import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mockup/flutter_mockup.dart';

class Logo2 extends StatefulWidget {
  final MockupController _controller;
  Logo2({super.key, MockupController? controller})
      : _controller = controller ??
            MockupController(const MockupData(
              tshirtImage: '',
              logoImage: '',
            ));

  @override
  State<Logo2> createState() => _Logo2State();
}

class _Logo2State extends State<Logo2> {
  final ValueNotifier<ImageInfo?> tshirtImageInfo = ValueNotifier(null);
  final ValueNotifier<ImageInfo?> logoImageInfo = ValueNotifier(null);
  final ValueNotifier<Offset> transformOffset = ValueNotifier(Offset.zero);
  final ValueNotifier<double> transformScale = ValueNotifier(1.0);
  final GlobalKey tshirtKey = GlobalKey();
  bool dragStarted = false;
  double cornersSize = 10;
  RenderBox? tshirtRenderBox;
  @override
  void initState() {
    super.initState();

    final tshirtImage = Image.asset(
      widget._controller.value.tshirtImage,
      fit: BoxFit.contain,
    );
    final logoImage = Image.asset(
      widget._controller.value.logoImage,
      fit: BoxFit.contain,
    );
    tshirtImage.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener(
        (info, _) {
          tshirtImageInfo.value = info;
        },
      ),
    );
    logoImage.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener(
        (info, _) {
          logoImageInfo.value = info;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: logoImageInfo,
        builder: (context, logoImageValue, child) {
          return ValueListenableBuilder(
              valueListenable: tshirtImageInfo,
              builder: (context, tshirtImageValue, child) {
                if (tshirtImageValue == null || logoImageValue == null) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return ValueListenableBuilder(
                      valueListenable: widget._controller,
                      builder: (context, controllerValue, child) {
                        return LayoutBuilder(builder: (context, constraints) {
                          Future.delayed(Duration.zero, () {
                            // Get resolution of the tshirt image
                            final tshirtImageSize = Size(tshirtImageValue.image.width.toDouble(),
                                tshirtImageValue.image.height.toDouble());
                            // Get the render box of the tshirt image
                            tshirtRenderBox =
                                tshirtKey.currentContext!.findRenderObject() as RenderBox;
                            // Get the size of the tshirt render box
                            final tshirtRenderSize = tshirtRenderBox!.size;
                            final tshirtGlobalPosition =
                                tshirtRenderBox!.localToGlobal(Offset.zero);
                            // Calculate the scale of the tshirt image
                            final tshirtCurrentScale = min(
                                tshirtRenderSize.width / tshirtImageSize.width,
                                tshirtRenderSize.height / tshirtImageSize.height);
                            // Get the previous scale of the tshirt image
                            final tshirtPreviousScale = controllerValue.tshirtScale;
                            // Get resolution of the logo image
                            final logoImageSize = Size(logoImageValue.image.width.toDouble(),
                                logoImageValue.image.height.toDouble());
                            // Update the controller value
                            if (tshirtPreviousScale != tshirtCurrentScale) {
                              widget._controller.value = controllerValue.copyWith(
                                tshirtScale: tshirtCurrentScale,
                                tshirtImageSize: tshirtImageSize,
                                logoImageSize: logoImageSize,
                                tshirtGlobalPosition: tshirtGlobalPosition,
                                logoPositionOffset: Offset(
                                  controllerValue.logoPositionOffset.dx *
                                      tshirtCurrentScale /
                                      tshirtPreviousScale,
                                  controllerValue.logoPositionOffset.dy *
                                      tshirtCurrentScale /
                                      tshirtPreviousScale,
                                ),
                              );
                            }
                          });
                          return Stack(
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: Image.asset(
                                  controllerValue.tshirtImage,
                                  fit: BoxFit.contain,
                                  key: tshirtKey,
                                ),
                              ),
                              Positioned(
                                left: controllerValue.logoPositionOffset.dx +
                                    controllerValue.tshirtGlobalPosition.dx,
                                top: controllerValue.logoPositionOffset.dy +
                                    controllerValue.tshirtGlobalPosition.dy,
                                child: Draggable(
                                  onDragStarted: () {
                                    setState(() {
                                      dragStarted = true;
                                    });
                                  },
                                  onDragEnd: (details) {
                                    widget._controller.value = controllerValue.copyWith(
                                        logoPositionOffset:
                                            details.offset - controllerValue.tshirtGlobalPosition);
                                    setState(() {
                                      dragStarted = false;
                                    });
                                  },
                                  childWhenDragging: Container(),
                                  feedback: _buildLogo(controllerValue),
                                  child: _buildLogo(controllerValue),
                                ),
                              ),
                            ],
                          );
                        });
                      });
                }
              });
        });
  }

  Widget _buildLogo(MockupData value) {
    return ValueListenableBuilder(
        valueListenable: transformOffset,
        builder: (context, transformOffsetValue, child) {
          return Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateX(transformOffsetValue.dy * pi / 180)
              ..rotateZ(transformOffsetValue.dx * pi / 180),
            alignment: Alignment.center,
            child: Listener(
              onPointerSignal: (event) {
                if (event is PointerScrollEvent) {
                  widget._controller.value = widget._controller.value.copyWith(
                    logoScale: (widget._controller.value.logoScale - event.scrollDelta.dy / 100)
                        .clamp(0.1, 10.0),
                  );
                }
              },
              onPointerPanZoomUpdate: (event) {
                widget._controller.value = widget._controller.value.copyWith(
                  logoScale: (widget._controller.value.logoScale - event.scale).clamp(0.1, 10.0),
                );
              },
              child: GestureDetector(
                onPanUpdate: (details) => transformOffset.value += details.delta,
                child: Image.asset(
                  value.logoImage,
                  fit: BoxFit.contain,
                  width: value.logoImageSize.width * value.tshirtScale * value.logoScale,
                  height: value.logoImageSize.height * value.tshirtScale * value.logoScale,
                ),
              ),
            ),
          );
        });
  }
}
