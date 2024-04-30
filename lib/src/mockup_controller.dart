import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';

class MockupController with ChangeNotifier {
  ScreenshotController screenshotController;
  String _tshirtImage;
  String _logoImage;
  Offset _logoPosition = Offset.zero;
  double _logoScale = 1.0;
  double _logoRotationZ = 0.0;
  double _logoRotationX = 0.0;
  double _logoRotationY = 0.0;
  double _tshirtScale = 1.0;
  Offset _tshirtImageSize = Offset.zero;
  Offset _logoImageSize = Offset.zero;
  Offset _tshirtGlobalPosition = Offset.zero;
  int _maxResolutionOfRender = 500;

  MockupController({
    required this.screenshotController,
    required String tshirtImage,
    required String logoImage,
  })  : _tshirtImage = tshirtImage,
        _logoImage = logoImage {
    setLogoAndTshirtResolutions();
  }

  String get tshirtImage => _tshirtImage;
  String get logoImage => _logoImage;
  Offset get logoPosition => _logoPosition;
  double get logoScale => _logoScale;
  double get logoRotationZ => _logoRotationZ;
  double get logoRotationX => _logoRotationX;
  double get logoRotationY => _logoRotationY;
  double get tshirtScale => _tshirtScale;
  Offset get tshirtImageSize => _tshirtImageSize;
  Offset get logoImageSize => _logoImageSize;
  Offset get tshirtGlobalPosition => _tshirtGlobalPosition;
  int get maxResolutionOfRender => _maxResolutionOfRender;

  Offset get logoGlobalPosition => Offset(
        tshirtGlobalPosition.dx + logoPosition.dx,
        tshirtGlobalPosition.dy + logoPosition.dy,
      );

  Offset get logoWidgetSize => Offset(
        logoImageSize.dx * tshirtScale * logoScale,
        logoImageSize.dy * tshirtScale * logoScale,
      );

  set tshirtImage(String value) {
    _tshirtImage = value;
    setLogoAndTshirtResolutions();
    notifyListeners();
  }

  set logoImage(String value) {
    _logoImage = value;
    setLogoAndTshirtResolutions();
    notifyListeners();
  }

  set logoPosition(Offset value) {
    _logoPosition = value;
    notifyListeners();
  }

  set logoScale(double value) {
    _logoScale = value;
    notifyListeners();
  }

  set logoRotationZ(double value) {
    _logoRotationZ = value;
    notifyListeners();
  }

  set logoRotationX(double value) {
    _logoRotationX = value;
    notifyListeners();
  }

  set logoRotationY(double value) {
    _logoRotationY = value;
    notifyListeners();
  }

  set tshirtScale(double value) {
    _tshirtScale = value;
    notifyListeners();
  }

  set tshirtImageSize(Offset value) {
    _tshirtImageSize = value;
    notifyListeners();
  }

  set logoImageSize(Offset value) {
    _logoImageSize = value;
    notifyListeners();
  }

  set tshirtGlobalPosition(Offset value) {
    _tshirtGlobalPosition = value;
    notifyListeners();
  }

  set maxResolutionOfRender(int value) {
    _maxResolutionOfRender = value;
    notifyListeners();
  }

  Size _calculateNewImageSize(Size imageSize, Size screenSize) {
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
    // Get the size of the tshirt image
    final tshirtWidgetSize =
        _calculateNewImageSize(Size(tshirtImageSize.dx, tshirtImageSize.dy), constraints);
    final tshirtGlobalPosition = Offset(
      (constraints.width - tshirtWidgetSize.width) / 2,
      (constraints.height - tshirtWidgetSize.height) / 2,
    );
    // Calculate the scale of the tshirt image
    final tshirtCurrentScale = min(
        tshirtWidgetSize.width / tshirtImageSize.dx, tshirtWidgetSize.height / tshirtImageSize.dy);
    _logoPosition = Offset(
      logoPosition.dx * tshirtCurrentScale / tshirtScale,
      logoPosition.dy * tshirtCurrentScale / tshirtScale,
    );
    _tshirtScale = tshirtCurrentScale;
    _tshirtGlobalPosition = tshirtGlobalPosition;
    _logoImageSize = logoImageSize;
    notifyListeners();
  }

  void resizeLogo(double newScale, Offset newOffset) {
    _logoScale = newScale;
    _logoPosition = newOffset;
    notifyListeners();
  }

  void resizeAndRotateLogo(double newScale, Offset newOffset, double newRotation) {
    _logoScale = newScale;
    _logoPosition = newOffset;
    _logoRotationZ = newRotation;
    notifyListeners();
  }

  Future<Uint8List?> generateMockupImage() async {
    final maxPx = max(tshirtImageSize.dx, tshirtImageSize.dy);
    final scale = _maxResolutionOfRender / maxPx;
    final image = await screenshotController.captureFromWidget(
      Stack(
        children: [
          Image.asset(
            tshirtImage,
          ),
          Positioned(
            left: logoPosition.dx,
            top: logoPosition.dy,
            child: Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateX(logoRotationX)
                ..rotateY(logoRotationY)
                ..rotateZ(logoRotationZ),
              child: Image.asset(
                logoImage,
                width: logoImageSize.dx * tshirtScale * logoScale,
                height: logoImageSize.dy * tshirtScale * logoScale,
              ),
            ),
          ),
        ],
      ),
      pixelRatio: 1 / tshirtScale * scale,
    );
    return image;
  }

  void reset() {
    _logoPosition = Offset.zero;
    _logoScale = 1.0;
    _logoRotationZ = 0.0;
    _tshirtScale = 1.0;
    _tshirtImageSize = Offset.zero;
    _logoImageSize = Offset.zero;
    _tshirtGlobalPosition = Offset.zero;
    notifyListeners();
  }

  void setLogoAndTshirtResolutions() {
    final tshirtWidget = Image.asset(
      tshirtImage,
      fit: BoxFit.contain,
    );
    final logoWidget = Image.asset(
      logoImage,
      fit: BoxFit.contain,
    );
    tshirtWidget.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener(
        (info, _) {
          tshirtImageSize = Offset(
            info.image.width.toDouble(),
            info.image.height.toDouble(),
          );
        },
      ),
    );
    logoWidget.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener(
        (info, _) {
          logoImageSize = Offset(
            info.image.width.toDouble(),
            info.image.height.toDouble(),
          );
        },
      ),
    );
  }
}
