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
  Offset dragdifference = Offset.zero;
  double previousScale = 1;
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
                            final logoRenderSize = Size(logoImageSize.width * tshirtCurrentScale,
                                logoImageSize.height * tshirtCurrentScale);

                            // Update the controller value
                            if (tshirtPreviousScale != tshirtCurrentScale) {
                              if (controllerValue.logoPositionOffset == Offset.zero) {
                                widget._controller.value = controllerValue.copyWith(
                                  tshirtScale: tshirtCurrentScale,
                                  tshirtImageSize: tshirtImageSize,
                                  logoImageSize: logoImageSize,
                                  tshirtGlobalPosition: tshirtGlobalPosition,
                                  logoPositionOffset: Offset(
                                    (controllerValue.logoPositionOffset.dx *
                                            tshirtCurrentScale /
                                            tshirtPreviousScale) +
                                        (tshirtRenderSize.width - logoRenderSize.width) / 2,
                                    controllerValue.logoPositionOffset.dy *
                                            tshirtCurrentScale /
                                            tshirtPreviousScale +
                                        (tshirtRenderSize.height - logoRenderSize.height) / 2,
                                  ),
                                );
                              } else {
                                widget._controller.value = controllerValue.copyWith(
                                  tshirtScale: tshirtCurrentScale,
                                  tshirtImageSize: tshirtImageSize,
                                  logoImageSize: logoImageSize,
                                  tshirtGlobalPosition: tshirtGlobalPosition,
                                  logoPositionOffset: Offset(
                                    (controllerValue.logoPositionOffset.dx *
                                        tshirtCurrentScale /
                                        tshirtPreviousScale),
                                    controllerValue.logoPositionOffset.dy *
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
                                left: controllerValue.logoPositionOffset.dx +
                                    controllerValue.tshirtGlobalPosition.dx,
                                top: controllerValue.logoPositionOffset.dy +
                                    controllerValue.tshirtGlobalPosition.dy,
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
                                left: controllerValue.logoPositionOffset.dx +
                                    controllerValue.tshirtGlobalPosition.dx,
                                top: controllerValue.logoPositionOffset.dy +
                                    controllerValue.tshirtGlobalPosition.dy,
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
              ..rotateX(transformOffsetValue.dy * pi / 180)
              ..rotateZ(transformOffsetValue.dx * pi / 180),
            alignment: Alignment.center,
            child: showLogo
                ? Image.asset(
                    value.logoImage,
                    fit: BoxFit.contain,
                    width: value.logoImageSize.width * value.tshirtScale * value.logoScale,
                    height: value.logoImageSize.height * value.tshirtScale * value.logoScale,
                  )
                : Listener(
                    onPointerSignal: (event) {
                      if (event is PointerScrollEvent) {
                        final previousImageSize = Offset(
                            value.logoImageSize.width * value.tshirtScale * value.logoScale,
                            value.logoImageSize.height * value.tshirtScale * value.logoScale);
                        final newScale =
                            (value.logoScale - event.scrollDelta.dy / 100).clamp(0.1, 10.0);
                        final imageSize = Offset(
                            value.logoImageSize.width * value.tshirtScale * newScale,
                            value.logoImageSize.height * value.tshirtScale * newScale);
                        final additionOffset = (previousImageSize - imageSize) / 2;
                        final newOffset = value.logoPositionOffset + additionOffset;
                        widget._controller.value = widget._controller.value.copyWith(
                          logoScale: newScale,
                          logoPositionOffset: newOffset,
                        );
                        if (event is PointerPanZoomStartEvent) {
                          print('PointerPanZoomStartEvent');
                        }
                      }
                    },
                    child: GestureDetector(
                      onScaleStart: (details) {
                        dragdifference = details.focalPoint - value.logoPositionOffset;
                        dragStarted = true;
                        previousScale = value.logoScale;
                      },
                      onScaleUpdate: (details) {
                        final previousImageSize = Offset(
                            value.logoImageSize.width * value.tshirtScale * value.logoScale,
                            value.logoImageSize.height * value.tshirtScale * value.logoScale);
                        final newScale = previousScale * (details.scale);
                        final newImageSize = Offset(
                            value.logoImageSize.width * value.tshirtScale * newScale,
                            value.logoImageSize.height * value.tshirtScale * newScale);
                        final additionOffset = (previousImageSize - newImageSize) / 2;
                        Offset newOffset = Offset.zero;
                        if (newScale == value.logoScale) {
                          newOffset = details.focalPoint - dragdifference + additionOffset;
                        } else {
                          newOffset = value.logoPositionOffset + additionOffset;
                        }
                        widget._controller.value = widget._controller.value.copyWith(
                          logoScale: newScale,
                          logoPositionOffset: newOffset,
                        );
                      },
                      onScaleEnd: (details) {
                        dragStarted = false;
                        print('ScaleEnd');
                      },
                      child: Container(
                        width: value.logoImageSize.width * value.tshirtScale * value.logoScale,
                        height: value.logoImageSize.height * value.tshirtScale * value.logoScale,
                        color: Colors.transparent,
                      ),
                    ),
                  ),
          );
        });
  }
}
