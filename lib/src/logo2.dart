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
  Offset pointScale = Offset.zero;
  double previousScale = 1;
  double previousLogoRotation = 0;
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
                            final tshirtImageSize = Offset(tshirtImageValue.image.width.toDouble(),
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
                                tshirtRenderSize.width / tshirtImageSize.dx,
                                tshirtRenderSize.height / tshirtImageSize.dy);
                            // Get the previous scale of the tshirt image
                            final tshirtPreviousScale = controllerValue.tshirtScale;
                            // Get resolution of the logo image
                            final logoImageSize = Offset(logoImageValue.image.width.toDouble(),
                                logoImageValue.image.height.toDouble());
                            final logoRenderSize = Offset(logoImageSize.dx * tshirtCurrentScale,
                                logoImageSize.dy * tshirtCurrentScale);

                            // Update the controller value
                            if (tshirtPreviousScale != tshirtCurrentScale) {
                              if (controllerValue.logoPosition == Offset.zero) {
                                widget._controller.value = controllerValue.copyWith(
                                  tshirtScale: tshirtCurrentScale,
                                  tshirtImageSize: tshirtImageSize,
                                  logoImageSize: logoImageSize,
                                  tshirtGlobalPosition: tshirtGlobalPosition,
                                  logoPosition: Offset(
                                    (controllerValue.logoPosition.dx *
                                            tshirtCurrentScale /
                                            tshirtPreviousScale) +
                                        (tshirtRenderSize.width - logoRenderSize.dx) / 2,
                                    controllerValue.logoPosition.dy *
                                            tshirtCurrentScale /
                                            tshirtPreviousScale +
                                        (tshirtRenderSize.height - logoRenderSize.dy) / 2,
                                  ),
                                );
                              } else {
                                widget._controller.value = controllerValue.copyWith(
                                  tshirtScale: tshirtCurrentScale,
                                  tshirtImageSize: tshirtImageSize,
                                  logoImageSize: logoImageSize,
                                  tshirtGlobalPosition: tshirtGlobalPosition,
                                  logoPosition: Offset(
                                    (controllerValue.logoPosition.dx *
                                        tshirtCurrentScale /
                                        tshirtPreviousScale),
                                    controllerValue.logoPosition.dy *
                                        tshirtCurrentScale /
                                        tshirtPreviousScale,
                                  ),
                                );
                              }
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
                                left: controllerValue.logoGlobalPosition.dx,
                                top: controllerValue.logoGlobalPosition.dy,
                                child: _buildLogo(controllerValue),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Image.asset(
                                  controllerValue.tshirtImage,
                                  color: Colors.white.withOpacity(.9),
                                  colorBlendMode: BlendMode.srcOut,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              Positioned(
                                left: controllerValue.logoGlobalPosition.dx,
                                top: controllerValue.logoGlobalPosition.dy,
                                child: _buildLogo(controllerValue, showLogo: false),
                              ),
                            ],
                          );
                        });
                      });
                }
              });
        });
  }

  Widget _buildLogo(MockupData value, {bool showLogo = true}) {
    return ValueListenableBuilder(
        valueListenable: transformOffset,
        builder: (context, transformOffsetValue, child) {
          return Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateZ(value.logoRotation),
            alignment: Alignment.center,
            child: showLogo
                ? Image.asset(
                    value.logoImage,
                    fit: BoxFit.contain,
                    width: value.logoWidgetSize.dx,
                    height: value.logoWidgetSize.dy,
                  )
                : Listener(
                    onPointerSignal: (event) {
                      if (event is PointerScrollEvent) {
                        final previousImageSize =
                            Offset(value.logoWidgetSize.dx, value.logoWidgetSize.dy);
                        final newScale =
                            (value.logoScale - event.scrollDelta.dy / 100).clamp(0.1, 10.0);
                        final imageSize = Offset(
                            value.logoImageSize.dx * value.tshirtScale * newScale,
                            value.logoImageSize.dy * value.tshirtScale * newScale);
                        final sizeDifference = (previousImageSize - imageSize) / 2;
                        final newOffset = value.logoPosition + sizeDifference;

                        widget._controller.value = widget._controller.value.copyWith(
                          logoScale: newScale,
                          logoPosition: newOffset,
                        );
                      }
                    },
                    child: GestureDetector(
                      onScaleStart: (details) {
                        Offset pointOffset = details.focalPoint - value.logoGlobalPosition;
                        pointScale = Offset(
                          pointOffset.dx / value.logoWidgetSize.dx,
                          pointOffset.dy / value.logoWidgetSize.dy,
                        );
                        dragStarted = true;
                        previousScale = value.logoScale;
                        previousLogoRotation = value.logoRotation;
                      },
                      onScaleUpdate: (details) {
                        final newScale = previousScale * (details.scale);
                        final newImageSize = Offset(
                            value.logoImageSize.dx * value.tshirtScale * newScale,
                            value.logoImageSize.dy * value.tshirtScale * newScale);

                        Offset newOffset = details.focalPoint -
                            value.tshirtGlobalPosition +
                            Offset(
                                -newImageSize.dx * pointScale.dx, -newImageSize.dy * pointScale.dy);
                        widget._controller.value = widget._controller.value.copyWith(
                          logoScale: newScale,
                          logoPosition: newOffset,
                          logoRotation: details.rotation + previousLogoRotation,
                        );
                      },
                      onScaleEnd: (details) {
                        dragStarted = false;
                        print('ScaleEnd');
                      },
                      child: Container(
                        width: value.logoWidgetSize.dx,
                        height: value.logoWidgetSize.dy,
                        color: Colors.transparent,
                      ),
                    ),
                  ),
          );
        });
  }
}
