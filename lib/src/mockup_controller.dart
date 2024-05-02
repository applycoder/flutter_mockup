import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';

class MockupController with ChangeNotifier {
  ScreenshotController screenshotController;
  String _background;
  String _design;
  Offset _designPosition = Offset.zero;
  double _designScale = 1.0;
  double _designRotationZ = 0.0;
  double _designRotationX = 0.0;
  double _designRotationY = 0.0;
  double _backgroundScale = 1.0;
  Offset _backgroundSize = Offset.zero;
  Offset _designSize = Offset.zero;
  Offset _backgroundGlobalPosition = Offset.zero;
  int _maxResolutionOfRender = 500;

  MockupController({
    required this.screenshotController,
    required String background,
    required String design,
  })  : _background = background,
        _design = design {
    setLogoAndBackgroundResolutions();
  }

  String get background => _background;
  String get design => _design;
  Offset get designPosition => _designPosition;
  double get designScale => _designScale;
  double get designRotationZ => _designRotationZ;
  double get designRotationX => _designRotationX;
  double get designRotationY => _designRotationY;
  double get backgroundScale => _backgroundScale;
  Offset get backgroundSize => _backgroundSize;
  Offset get designSize => _designSize;
  Offset get backgroundGlobalPosition => _backgroundGlobalPosition;
  int get maxResolutionOfRender => _maxResolutionOfRender;

  Offset get designGlobalPosition => Offset(
        backgroundGlobalPosition.dx + designPosition.dx,
        backgroundGlobalPosition.dy + designPosition.dy,
      );

  Offset get designWidgetSize => Offset(
        designSize.dx * backgroundScale * designScale,
        designSize.dy * backgroundScale * designScale,
      );

  set background(String value) {
    _background = value;
    setLogoAndBackgroundResolutions();
    notifyListeners();
  }

  set design(String value) {
    _design = value;
    setLogoAndBackgroundResolutions();
    notifyListeners();
  }

  set designPosition(Offset value) {
    _designPosition = value;
    notifyListeners();
  }

  set designScale(double value) {
    _designScale = value;
    notifyListeners();
  }

  set designRotationZ(double value) {
    _designRotationZ = value;
    notifyListeners();
  }

  set designRotationX(double value) {
    _designRotationX = value;
    notifyListeners();
  }

  set designRotationY(double value) {
    _designRotationY = value;
    notifyListeners();
  }

  set backgroundScale(double value) {
    _backgroundScale = value;
    notifyListeners();
  }

  set backgroundSize(Offset value) {
    _backgroundSize = value;
    notifyListeners();
  }

  set designSize(Offset value) {
    _designSize = value;
    notifyListeners();
  }

  set backgroundGlobalPosition(Offset value) {
    _backgroundGlobalPosition = value;
    notifyListeners();
  }

  set maxResolutionOfRender(int value) {
    _maxResolutionOfRender = value;
    notifyListeners();
  }

  Size _calculateNewBackgroundSize(Size imageSize, Size screenSize) {
    final imageAspectRatio = imageSize.width / imageSize.height;
    final screenAspectRatio = screenSize.width / screenSize.height;

    if (imageAspectRatio > screenAspectRatio) {
      final newWidth = screenSize.width;
      final newHeight = newWidth / imageAspectRatio;
      return Size(newWidth, newHeight);
    } else {
      final newHeight = screenSize.height;
      final newWidth = newHeight * imageAspectRatio;
      return Size(newWidth, newHeight);
    }
  }

  void constraintsUpdate(Size constraints) {
    // Get the size of the tshirt
    final backgroundWidgetSize =
        _calculateNewBackgroundSize(Size(backgroundSize.dx, backgroundSize.dy), constraints);
    final backgroundGlobalPosition = Offset(
      (constraints.width - backgroundWidgetSize.width) / 2,
      (constraints.height - backgroundWidgetSize.height) / 2,
    );
    // Calculate the scale of the tshirt image
    final newBackgroundImageScale = min(backgroundWidgetSize.width / backgroundSize.dx,
        backgroundWidgetSize.height / backgroundSize.dy);
    _designPosition = Offset(
      designPosition.dx * newBackgroundImageScale / backgroundScale,
      designPosition.dy * newBackgroundImageScale / backgroundScale,
    );
    _backgroundScale = newBackgroundImageScale;
    _backgroundGlobalPosition = backgroundGlobalPosition;
    _designSize = designSize;
    notifyListeners();
  }

  void resizeDesign(double newScale, Offset newOffset) {
    _designScale = newScale;
    _designPosition = newOffset;
    notifyListeners();
  }

  void resizeAndRotateDesign(double newScale, Offset newOffset, double newRotation) {
    _designScale = newScale;
    _designPosition = newOffset;
    _designRotationZ = newRotation;
    notifyListeners();
  }

  Future<Uint8List?> generateMockedUpImage() async {
    final maxPx = max(backgroundSize.dx, backgroundSize.dy);
    final scale = _maxResolutionOfRender / maxPx;
    final image = await screenshotController.captureFromWidget(
      Stack(
        children: [
          Image.asset(
            background,
          ),
          Positioned(
            left: designPosition.dx,
            top: designPosition.dy,
            child: Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateX(designRotationX)
                ..rotateY(designRotationY)
                ..rotateZ(designRotationZ),
              child: Image.asset(
                design,
                width: designSize.dx * backgroundScale * designScale,
                height: designSize.dy * backgroundScale * designScale,
              ),
            ),
          ),
        ],
      ),
      pixelRatio: 1 / backgroundScale * scale,
    );
    return image;
  }

  void reset() {
    _designPosition = Offset.zero;
    _designScale = 1.0;
    _designRotationZ = 0.0;
    _backgroundScale = 1.0;
    _backgroundSize = Offset.zero;
    _designSize = Offset.zero;
    _backgroundGlobalPosition = Offset.zero;
    notifyListeners();
  }

  void setLogoAndBackgroundResolutions() {
    final tshirtWidget = Image.asset(
      background,
      fit: BoxFit.contain,
    );
    final logoWidget = Image.asset(
      design,
      fit: BoxFit.contain,
    );
    tshirtWidget.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener(
        (info, _) {
          backgroundSize = Offset(
            info.image.width.toDouble(),
            info.image.height.toDouble(),
          );
        },
      ),
    );
    logoWidget.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener(
        (info, _) {
          designSize = Offset(
            info.image.width.toDouble(),
            info.image.height.toDouble(),
          );
        },
      ),
    );
  }
}
