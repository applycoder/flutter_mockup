import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

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
  int _maxResolutionOfRender;
  Size _constraints = Size.zero;
  GlobalKey widgetKey = GlobalKey();
  bool isBackgroundReadyToRender = false;
  bool isDesignReadyToRender = false;

  MockupController({
    required this.screenshotController,
    required String backgroundUrl,
    Offset? designPosition,
    double? designScale,
    double? designRotationX,
    double? designRotationY,
    double? designRotationZ,
    double? backgroundScale,
    Offset? backgroundSize,
    Offset? backgroundGlobalPosition,
    int? maxResolutionOfRender,
    String? designUrl,
  })  : _backgroundUrl = backgroundUrl,
        _designUrl = designUrl ??
            'https://firebasestorage.googleapis.com/v0/b/freative.appspot.com/o/MockupDesignTemplate%2FlLO6c5AVTpSEIS_4QYnhAw.jpg?alt=media&token=76aa2650-d3e7-4881-acc9-950f563278fc',
        _designPosition = designPosition ?? Offset.zero,
        _designScale = designScale ?? 1.0,
        _designRotationX = designRotationX ?? 0.0,
        _designRotationY = designRotationY ?? 0.0,
        _designRotationZ = designRotationZ ?? 0.0,
        _backgroundScale = backgroundScale ?? 1.0,
        _backgroundSize = backgroundSize ?? Offset.zero,
        _backgroundGlobalPosition = backgroundGlobalPosition ?? Offset.zero,
        _maxResolutionOfRender = maxResolutionOfRender ?? 1000 {
    setBackgroundSize();
    setLogoSize();
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
  Size get constraints => _constraints;

  Offset get designPositionOnWidget => Offset(
        designPosition.dx + backgroundGlobalPosition.dx,
        designPosition.dy + backgroundGlobalPosition.dy,
      );

  Offset get designWidgetSize => Offset(
        designSize.dx * backgroundScale * designScale,
        designSize.dy * backgroundScale * designScale,
      );

  bool get isReadyToRender => isBackgroundReadyToRender && isDesignReadyToRender;

  set backgroundUrl(String value) {
    isBackgroundReadyToRender = false;
    _backgroundUrl = value;
    setBackgroundSize();
  }

  set designUrl(String value) {
    isDesignReadyToRender = false;
    _designUrl = value;
    setLogoSize();
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
    if (constraints != Size.zero) constraintsUpdate();
    isBackgroundReadyToRender = true;
    notifyListeners();
  }

  set backgroundGlobalPosition(Offset value) {
    _backgroundGlobalPosition = value;
    notifyListeners();
  }

  set designSize(Offset value) {
    _designSize = value;
    if (constraints != Size.zero) constraintsUpdate();
    isDesignReadyToRender = true;
    notifyListeners();
  }

  set maxResolutionOfRender(int value) {
    _maxResolutionOfRender = value;
    notifyListeners();
  }

  set constraints(Size value) {
    _constraints = value;
    if (value != Size.zero) constraintsUpdate();
    notifyListeners();
  }

  Size _calculateBackgroundWidgetSize(Size imageSize) {
    final imageAspectRatio = imageSize.width / imageSize.height;
    final screenAspectRatio = _constraints.width / _constraints.height;

    if (imageAspectRatio > screenAspectRatio) {
      final newWidth = _constraints.width;
      final newHeight = newWidth / imageAspectRatio;
      return Size(newWidth, newHeight);
    } else {
      final newHeight = _constraints.height;
      final newWidth = newHeight * imageAspectRatio;
      return Size(newWidth, newHeight);
    }
  }

  void constraintsUpdate() {
    // Get the size of the tshirt
    final backgroundWidgetSize =
        _calculateBackgroundWidgetSize(Size(backgroundSize.dx, backgroundSize.dy));
    backgroundGlobalPosition = Offset(
      (_constraints.width - backgroundWidgetSize.width) / 2,
      (_constraints.height - backgroundWidgetSize.height) / 2,
    );
    // Calculate the scale of the tshirt image
    final newBackgroundImageScale = min(backgroundWidgetSize.width / backgroundSize.dx,
        backgroundWidgetSize.height / backgroundSize.dy);
    _designPosition = Offset(
      designPosition.dx * newBackgroundImageScale / backgroundScale,
      designPosition.dy * newBackgroundImageScale / backgroundScale,
    );
    _backgroundScale = newBackgroundImageScale;
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

    final backgroundImageProvider = NetworkImage(backgroundUrl);
    final backgroundImageCompleter = Completer<ImageInfo>();
    final designImageProvider = NetworkImage(designUrl);
    final designImageCompleter = Completer<ImageInfo>();
    final backgroundImageStream = backgroundImageProvider.resolve(const ImageConfiguration());
    final designImageStream = designImageProvider.resolve(const ImageConfiguration());
    final backgroundImageListener = ImageStreamListener((ImageInfo info, bool _) {
      if (!backgroundImageCompleter.isCompleted) backgroundImageCompleter.complete(info);
    });
    final designImageListener = ImageStreamListener((ImageInfo info, bool _) {
      if (!designImageCompleter.isCompleted) designImageCompleter.complete(info);
    });

    backgroundImageStream.addListener(backgroundImageListener);
    designImageStream.addListener(designImageListener);
    await backgroundImageCompleter.future;
    await designImageCompleter.future;
    backgroundImageStream.removeListener(backgroundImageListener);
    designImageStream.removeListener(designImageListener);

    final image = await screenshotController.captureFromWidget(LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            Image(
              image: backgroundImageProvider,
              width: (backgroundSize.dx * backgroundScale),
              height: (backgroundSize.dy * backgroundScale),
              fit: BoxFit.contain,
              filterQuality: FilterQuality.high,
              isAntiAlias: true,
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
                  alignment: Alignment.center,
                  child: Image(
                    image: designImageProvider,
                    width: designWidgetSize.dx * (550 / designSize.dx),
                    height: designWidgetSize.dy * (550 / designSize.dy),
                    fit: BoxFit.contain,
                    filterQuality: FilterQuality.high,
                    isAntiAlias: true,
                  )),
            ),
          ],
        );
      },
    ), pixelRatio: 1 / backgroundScale * scale, delay: Duration.zero);
    return image;
  }

  void setLogoSize() {
    isDesignReadyToRender = false;
    try {
      Image image = Image.network(designUrl);
      Completer<ui.Image> completer = Completer<ui.Image>();
      image.image
          .resolve(const ImageConfiguration())
          .addListener(ImageStreamListener((ImageInfo info, bool _) {
        completer.complete(info.image);
      }));
      completer.future.then((value) {
        designSize = Offset(value.width.toDouble(), value.height.toDouble());
      });
    } catch (e) {
      print('Hata: $e');
    }
  }

  void setBackgroundSize() {
    isBackgroundReadyToRender = false;
    try {
      Image image = Image.network(backgroundUrl);
      Completer<ui.Image> completer = Completer<ui.Image>();
      image.image
          .resolve(const ImageConfiguration())
          .addListener(ImageStreamListener((ImageInfo info, bool _) {
        completer.complete(info.image);
      }));
      completer.future.then((value) {
        backgroundSize = Offset(value.width.toDouble(), value.height.toDouble());
      });
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

  static MockupController fromMockupSettings(MockupSettingsModel settings) {
    return MockupController(
      screenshotController: ScreenshotController(),
      backgroundUrl: settings.backgroundUrl,
      designPosition: settings.designPosition,
      designScale: settings.designScale,
      designRotationX: settings.designRotationX,
      designRotationY: settings.designRotationY,
      designRotationZ: settings.designRotationZ,
      backgroundScale: settings.backgroundScale,
      backgroundSize: settings.backgroundSize,
      backgroundGlobalPosition: settings.backgroundGlobalPosition,
      maxResolutionOfRender: settings.maxResolutionOfRender,
    );
  }
}
