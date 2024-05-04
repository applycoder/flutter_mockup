library flutter_mockup;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mockup/src/mockup_controller.dart';

export 'src/mockup_controller.dart';
export 'src/mockup_settings_model.dart';

class MockupWidget extends StatefulWidget {
  final MockupController controller;

  const MockupWidget({super.key, required this.controller});

  @override
  State<MockupWidget> createState() => _MockupWidgetState();
}

class _MockupWidgetState extends State<MockupWidget> {
  late MockupController controller = widget.controller;
  String previousBackgroundImage = '';
  String previousDesignImage = '';
  Offset pointScale = Offset.zero;
  double previousScale = 1;
  double previousDesignRotation = 0;
  Size previousConstraints = Size.zero;
  double cornersSize = 10;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: controller,
        builder: (context, child) {
          if (controller.backgroundSize == Offset.zero ||
              controller.designSize == Offset.zero ||
              controller.backgroundUrl.isEmpty ||
              controller.designUrl.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return LayoutBuilder(builder: (context, constraints) {
            if (previousConstraints != constraints.biggest) {
              previousConstraints = constraints.biggest;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                controller.constraintsUpdate(constraints.biggest);
              });
            }
            return _buildMockupWidget();
          });
        });
  }

  Widget _buildMockupWidget() {
    return Stack(
      key: controller.widgetKey,
      children: [
        Align(
          alignment: Alignment.center,
          child: Image.network(
            controller.backgroundUrl,
            width: controller.backgroundSize.dx * controller.backgroundScale,
            height: controller.backgroundSize.dy * controller.backgroundScale,
            fit: BoxFit.contain,
          ),
        ),
        Positioned(
          left: controller.designPositionOnWidget.dx,
          top: controller.designPositionOnWidget.dy,
          child: _buildLogo(),
        ),
        Align(
          alignment: Alignment.center,
          child: Image.network(
            controller.backgroundUrl,
            color: Colors.white.withOpacity(.9),
            colorBlendMode: BlendMode.srcOut,
            width: controller.backgroundSize.dx * controller.backgroundScale,
            height: controller.backgroundSize.dy * controller.backgroundScale,
            fit: BoxFit.contain,
          ),
        ),
        Positioned(
          left: controller.designPositionOnWidget.dx,
          top: controller.designPositionOnWidget.dy,
          child: _buildLogo(showLogo: false),
        ),
      ],
    );
  }

  Widget _buildLogo({bool showLogo = true}) {
    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001)
        ..rotateX(controller.designRotationX)
        ..rotateY(controller.designRotationY)
        ..rotateZ(controller.designRotationZ),
      alignment: Alignment.center,
      child: showLogo
          ? Image.network(
              controller.designUrl,
              width: controller.designWidgetSize.dx,
              height: controller.designWidgetSize.dy,
              fit: BoxFit.contain,
            )
          : Listener(
              onPointerSignal: (event) {
                if (event is PointerScrollEvent) {
                  final pointScale = Offset(
                    event.localPosition.dx / controller.designWidgetSize.dx,
                    event.localPosition.dy / controller.designWidgetSize.dy,
                  );
                  final newScale =
                      (controller.designScale - event.scrollDelta.dy / 1000).clamp(0.1, 10.0);
                  final imageSize = Offset(
                      controller.designSize.dx * controller.backgroundScale * newScale,
                      controller.designSize.dy * controller.backgroundScale * newScale);

                  Offset newOffset = event.position -
                      controller.widgetGlobalPosition -
                      controller.backgroundGlobalPosition +
                      Offset(
                        -imageSize.dx * pointScale.dx,
                        -imageSize.dy * pointScale.dy,
                      );

                  controller.resizeAndRotateDesign(newScale, newOffset, previousDesignRotation);
                }
                if (event is PointerScaleEvent) {
                  final newScale = controller.designScale * event.scale;
                  final pointScale = Offset(
                    event.localPosition.dx / controller.designWidgetSize.dx,
                    event.localPosition.dy / controller.designWidgetSize.dy,
                  );
                  final newImageSize = Offset(
                      controller.designSize.dx * controller.backgroundScale * newScale,
                      controller.designSize.dy * controller.backgroundScale * newScale);

                  Offset newOffset = event.position -
                      controller.widgetGlobalPosition -
                      controller.backgroundGlobalPosition +
                      Offset(
                        -newImageSize.dx * pointScale.dx,
                        -newImageSize.dy * pointScale.dy,
                      );
                  controller.resizeDesign(newScale, newOffset);
                }
              },
              child: GestureDetector(
                onScaleStart: (details) {
                  pointScale = Offset(
                    details.localFocalPoint.dx / controller.designWidgetSize.dx,
                    details.localFocalPoint.dy / controller.designWidgetSize.dy,
                  );
                  previousScale = controller.designScale;
                  previousDesignRotation = controller.designRotationZ;
                },
                onScaleUpdate: (details) {
                  final newScale = previousScale * (details.scale);
                  final newImageSize = Offset(
                      controller.designSize.dx * controller.backgroundScale * newScale,
                      controller.designSize.dy * controller.backgroundScale * newScale);
                  Offset newOffset = details.focalPoint -
                      controller.widgetGlobalPosition -
                      controller.backgroundGlobalPosition +
                      Offset(
                        -newImageSize.dx * pointScale.dx,
                        -newImageSize.dy * pointScale.dy,
                      );
                  final newRotation = details.rotation + previousDesignRotation;
                  controller.resizeAndRotateDesign(newScale, newOffset, newRotation);
                },
                child: Container(
                  width: controller.designWidgetSize.dx,
                  height: controller.designWidgetSize.dy,
                  color: Colors.transparent,
                ),
              ),
            ),
    );
  }
}
