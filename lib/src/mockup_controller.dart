import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_mockup/src/mockup_settings_model.dart';
import 'package:screenshot/screenshot.dart';

class MockupController with ChangeNotifier {
  ScreenshotController screenshotController;
  String _backgroundUrl;
  String _designUrl;
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
  GlobalKey widgetKey = GlobalKey();

  MockupController({
    required this.screenshotController,
    required String backgroundUrl,
    String? designUrl,
  })  : _backgroundUrl = backgroundUrl,
        _designUrl =
            designUrl ?? 'https://img001.prntscr.com/file/img001/lLO6c5AVTpSEIS_4QYnhAw.jpg' {
    setLogoAndBackgroundResolutions();
  }

  String get backgroundUrl => _backgroundUrl;
  String get designUrl => _designUrl;
  Offset get designPosition => _designPosition;
  double get designScale => _designScale;
  double get designRotationZ => _designRotationZ;
  double get designRotationX => _designRotationX;
  double get designRotationY => _designRotationY;
  double get backgroundScale => _backgroundScale;
  Offset get backgroundSize => _backgroundSize;
  Offset get designSize => _designSize;
  Offset get widgetGlobalPosition =>
      (widgetKey.currentContext!.findRenderObject() as RenderBox).localToGlobal(Offset.zero);
  Offset get backgroundGlobalPosition => _backgroundGlobalPosition;
  int get maxResolutionOfRender => _maxResolutionOfRender;

  Offset get designPositionOnWidget => Offset(
        designPosition.dx + backgroundGlobalPosition.dx,
        designPosition.dy + backgroundGlobalPosition.dy,
      );

  Offset get designWidgetSize => Offset(
        designSize.dx * backgroundScale * designScale,
        designSize.dy * backgroundScale * designScale,
      );

  set backgroundUrl(String value) {
    _backgroundUrl = value;
    setLogoAndBackgroundResolutions();
    notifyListeners();
  }

  set designUrl(String value) {
    _designUrl = value;
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

  set backgroundGlobalPosition(Offset value) {
    _backgroundGlobalPosition = value;
    notifyListeners();
  }

  set designSize(Offset value) {
    _designSize = value;
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
    backgroundGlobalPosition = Offset(
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
            backgroundUrl,
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
                designUrl,
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

  void setLogoAndBackgroundResolutions() {
    try {
      final tshirtWidget = Image.network(
        backgroundUrl,
        fit: BoxFit.contain,
        errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
          return const Text('Resim yüklenemedi');
        },
      );
      final logoWidget = Image.network(
        designUrl,
        fit: BoxFit.contain,
        errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
          return const Text('Resim yüklenemedi');
        },
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
    } catch (e) {
      print('Hata: $e');
    }
  }

  void reset() {
    _designPosition = Offset.zero;
    _designScale = 1.0;
    _designRotationX = 0.0;
    _designRotationY = 0.0;
    _designRotationZ = 0.0;
    _backgroundScale = 1.0;
    _backgroundSize = Offset.zero;
    _backgroundGlobalPosition = Offset.zero;
    _maxResolutionOfRender = 500;
    notifyListeners();
  }

  MockupSettingsModel toMockupSettings() {
    return MockupSettingsModel(
      backgroundUrl: _backgroundUrl,
      designPosition: _designPosition,
      designScale: _designScale,
      designRotationX: _designRotationX,
      designRotationY: _designRotationY,
      designRotationZ: _designRotationZ,
      backgroundScale: _backgroundScale,
      backgroundSize: _backgroundSize,
      backgroundGlobalPosition: _backgroundGlobalPosition,
      maxResolutionOfRender: _maxResolutionOfRender,
    );
  }

  void fromMockupSettings(MockupSettingsModel settings) {
    _backgroundUrl = settings.backgroundUrl;
    _designPosition = settings.designPosition;
    _designScale = settings.designScale;
    _designRotationX = settings.designRotationX;
    _designRotationY = settings.designRotationY;
    _designRotationZ = settings.designRotationZ;
    _backgroundScale = settings.backgroundScale;
    _backgroundSize = settings.backgroundSize;
    _backgroundGlobalPosition = settings.backgroundGlobalPosition;
    _maxResolutionOfRender = settings.maxResolutionOfRender;
    notifyListeners();
  }
}
