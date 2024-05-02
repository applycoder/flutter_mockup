import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mockup/flutter_mockup.dart';

class EditorScreen extends StatefulWidget {
  final MockupController controller;
  const EditorScreen({super.key, required this.controller});

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  late final MockupController controller = widget.controller;
  String previousTshirtImage = '';
  String previousLogoImage = '';
  Offset pointScale = Offset.zero;
  double previousScale = 1;
  double previousLogoRotation = 0;
  Size previousConstraints = Size.zero;
  double cornersSize = 10;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: controller,
        builder: (context, child) {
          if (controller.backgroundSize == Offset.zero ||
              controller.designSize == Offset.zero ||
              controller.background.isEmpty ||
              controller.design.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return LayoutBuilder(builder: (context, constraints) {
            if (previousConstraints != constraints.biggest) {
              previousConstraints = constraints.biggest;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                controller.constraintsUpdate(
                  constraints.biggest,
                );
              });
            }
            return _buildMockupWidget();
          });
        });
  }

  Widget _buildMockupWidget() {
    return Stack(
      children: [
        Positioned(
          left: controller.backgroundGlobalPosition.dx,
          top: controller.backgroundGlobalPosition.dy,
          child: Image.asset(
            controller.background,
            width: controller.backgroundSize.dx * controller.backgroundScale,
            height: controller.backgroundSize.dy * controller.backgroundScale,
          ),
        ),
        Positioned(
          left: controller.designGlobalPosition.dx,
          top: controller.designGlobalPosition.dy,
          child: _buildLogo(),
        ),
        Positioned(
          left: controller.backgroundGlobalPosition.dx,
          top: controller.backgroundGlobalPosition.dy,
          child: Image.asset(
            controller.background,
            color: Colors.white.withOpacity(.9),
            colorBlendMode: BlendMode.srcOut,
            width: controller.backgroundSize.dx * controller.backgroundScale,
            height: controller.backgroundSize.dy * controller.backgroundScale,
          ),
        ),
        Positioned(
          left: controller.designGlobalPosition.dx,
          top: controller.designGlobalPosition.dy,
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
          ? Image.asset(
              controller.design,
              fit: BoxFit.contain,
              width: controller.designWidgetSize.dx,
              height: controller.designWidgetSize.dy,
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
                      controller.backgroundGlobalPosition +
                      Offset(
                        -imageSize.dx * pointScale.dx,
                        -imageSize.dy * pointScale.dy,
                      );

                  controller.resizeAndRotateDesign(newScale, newOffset, previousLogoRotation);
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
                  previousLogoRotation = controller.designRotationZ;
                },
                onScaleUpdate: (details) {
                  final newScale = previousScale * (details.scale);
                  final newImageSize = Offset(
                      controller.designSize.dx * controller.backgroundScale * newScale,
                      controller.designSize.dy * controller.backgroundScale * newScale);

                  Offset newOffset = details.focalPoint -
                      controller.backgroundGlobalPosition +
                      Offset(
                        -newImageSize.dx * pointScale.dx,
                        -newImageSize.dy * pointScale.dy,
                      );
                  final newRotation = details.rotation + previousLogoRotation;
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
