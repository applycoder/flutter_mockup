import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mockup/flutter_mockup.dart';

class Logo2 extends StatefulWidget {
  final MockupController controller;
  const Logo2({super.key, required this.controller});

  @override
  State<Logo2> createState() => _Logo2State();
}

class _Logo2State extends State<Logo2> {
  late final MockupController controller = widget.controller;
  final ValueNotifier<Offset> transformOffset = ValueNotifier(Offset.zero);
  final ValueNotifier<double> transformScale = ValueNotifier(1.0);
  Offset pointScale = Offset.zero;
  double previousScale = 1;
  double previousLogoRotation = 0;
  Size previousConstraints = Size.zero;
  double cornersSize = 10;
  @override
  void initState() {
    super.initState();

    final tshirtImage = Image.asset(
      widget.controller.tshirtImage,
      fit: BoxFit.contain,
    );
    final logoImage = Image.asset(
      controller.logoImage,
      fit: BoxFit.contain,
    );
    tshirtImage.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener(
        (info, _) {
          controller.tshirtImageSize = Offset(
            info.image.width.toDouble(),
            info.image.height.toDouble(),
          );
        },
      ),
    );
    logoImage.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener(
        (info, _) {
          controller.logoImageSize = Offset(
            info.image.width.toDouble(),
            info.image.height.toDouble(),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: controller,
        builder: (context, child) {
          if (controller.tshirtImageSize == Offset.zero ||
              controller.logoImageSize == Offset.zero) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return LayoutBuilder(builder: (context, constraints) {
            if (previousConstraints != constraints.biggest) {
              previousConstraints = constraints.biggest;
              controller.constraintsUpdate(
                constraints.biggest,
              );
            }
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
          });
        });
  }

  Widget _buildLogo({bool showLogo = true}) {
    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001)
        ..rotateZ(controller.logoRotation),
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
                  final previousImageSize = controller.logoWidgetSize;
                  final newScale =
                      (controller.logoScale - event.scrollDelta.dy / 1000).clamp(0.1, 10.0);
                  final imageSize = Offset(
                      controller.logoImageSize.dx * controller.tshirtScale * newScale,
                      controller.logoImageSize.dy * controller.tshirtScale * newScale);
                  final sizeDifference = (previousImageSize - imageSize) / 2;
                  final newOffset = controller.logoPosition + sizeDifference;

                  controller.resizeLogoUsingScroll(newScale, newOffset);
                }
              },
              child: GestureDetector(
                onScaleStart: (details) {
                  Offset pointOffset = details.focalPoint - controller.logoGlobalPosition;
                  pointScale = Offset(
                    pointOffset.dx / controller.logoWidgetSize.dx,
                    pointOffset.dy / controller.logoWidgetSize.dy,
                  );
                  previousScale = controller.logoScale;
                  previousLogoRotation = controller.logoRotation;
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
