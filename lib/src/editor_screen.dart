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
          if (controller.tshirtImageSize == Offset.zero ||
              controller.logoImageSize == Offset.zero ||
              controller.tshirtImage.isEmpty ||
              controller.logoImage.isEmpty) {
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
          left: controller.tshirtGlobalPosition.dx,
          top: controller.tshirtGlobalPosition.dy,
          child: Image.asset(
            controller.tshirtImage,
            width: controller.tshirtImageSize.dx * controller.tshirtScale,
            height: controller.tshirtImageSize.dy * controller.tshirtScale,
          ),
        ),
        Positioned(
          left: controller.logoGlobalPosition.dx,
          top: controller.logoGlobalPosition.dy,
          child: _buildLogo(),
        ),
        Positioned(
          left: controller.tshirtGlobalPosition.dx,
          top: controller.tshirtGlobalPosition.dy,
          child: Image.asset(
            controller.tshirtImage,
            color: Colors.white.withOpacity(.9),
            colorBlendMode: BlendMode.srcOut,
            width: controller.tshirtImageSize.dx * controller.tshirtScale,
            height: controller.tshirtImageSize.dy * controller.tshirtScale,
          ),
        ),
        Positioned(
          left: controller.logoGlobalPosition.dx,
          top: controller.logoGlobalPosition.dy,
          child: _buildLogo(showLogo: false),
        ),
      ],
    );
  }

  Widget _buildLogo({bool showLogo = true}) {
    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001)
        ..rotateX(controller.logoRotationX)
        ..rotateY(controller.logoRotationY)
        ..rotateZ(controller.logoRotationZ),
      alignment: Alignment.center,
      child: showLogo
          ? Image.asset(
              controller.logoImage,
              fit: BoxFit.contain,
              width: controller.logoWidgetSize.dx,
              height: controller.logoWidgetSize.dy,
            )
          : Listener(
              onPointerSignal: (event) {
                if (event is PointerScrollEvent) {
                  final pointScale = Offset(
                    event.localPosition.dx / controller.logoWidgetSize.dx,
                    event.localPosition.dy / controller.logoWidgetSize.dy,
                  );
                  final newScale =
                      (controller.logoScale - event.scrollDelta.dy / 1000).clamp(0.1, 10.0);
                  final imageSize = Offset(
                      controller.logoImageSize.dx * controller.tshirtScale * newScale,
                      controller.logoImageSize.dy * controller.tshirtScale * newScale);

                  Offset newOffset = event.position -
                      controller.tshirtGlobalPosition +
                      Offset(
                        -imageSize.dx * pointScale.dx,
                        -imageSize.dy * pointScale.dy,
                      );

                  controller.resizeAndRotateLogo(newScale, newOffset, previousLogoRotation);
                }
                if (event is PointerScaleEvent) {
                  final newScale = controller.logoScale * event.scale;
                  final pointScale = Offset(
                    event.localPosition.dx / controller.logoWidgetSize.dx,
                    event.localPosition.dy / controller.logoWidgetSize.dy,
                  );
                  final newImageSize = Offset(
                      controller.logoImageSize.dx * controller.tshirtScale * newScale,
                      controller.logoImageSize.dy * controller.tshirtScale * newScale);

                  Offset newOffset = event.position -
                      controller.tshirtGlobalPosition +
                      Offset(
                        -newImageSize.dx * pointScale.dx,
                        -newImageSize.dy * pointScale.dy,
                      );
                  controller.resizeLogo(newScale, newOffset);
                }
              },
              child: GestureDetector(
                onScaleStart: (details) {
                  pointScale = Offset(
                    details.localFocalPoint.dx / controller.logoWidgetSize.dx,
                    details.localFocalPoint.dy / controller.logoWidgetSize.dy,
                  );
                  previousScale = controller.logoScale;
                  previousLogoRotation = controller.logoRotationZ;
                },
                onScaleUpdate: (details) {
                  final newScale = previousScale * (details.scale);
                  final newImageSize = Offset(
                      controller.logoImageSize.dx * controller.tshirtScale * newScale,
                      controller.logoImageSize.dy * controller.tshirtScale * newScale);

                  Offset newOffset = details.focalPoint -
                      controller.tshirtGlobalPosition +
                      Offset(
                        -newImageSize.dx * pointScale.dx,
                        -newImageSize.dy * pointScale.dy,
                      );
                  final newRotation = details.rotation + previousLogoRotation;
                  controller.resizeAndRotateLogo(newScale, newOffset, newRotation);
                },
                child: Container(
                  width: controller.logoWidgetSize.dx,
                  height: controller.logoWidgetSize.dy,
                  color: Colors.transparent,
                ),
              ),
            ),
    );
  }
}
