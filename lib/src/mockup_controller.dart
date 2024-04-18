import 'package:flutter/material.dart';

class MockupController extends ValueNotifier<MockupData> {
  MockupController(super.value);
}

class MockupData {
  String tshirtImage;
  String logoImage;
  Offset logoPositionOffset = Offset.zero;
  Offset logoTopLeftCornerOffset = Offset.zero;
  Offset logoTopRightCornerOffset = Offset.zero;
  Offset logoBottomLeftCornerOffset = Offset.zero;
  Offset logoBottomRightCornerOffset = Offset.zero;
  double logoScale = 1.0;
  double logoRotation = 0.0;
  double logoOpacity = 1.0;
  double logoShadow = 0.0;
  Color logoBorderColor = Colors.transparent;
  double logoBorderWidth = 0.0;
  double logoBorderRadius = 0.0;
  double tshirtScale = 1.0;

  MockupData({
    required this.tshirtImage,
    required this.logoImage,
    Offset? logoPositionOffset,
    Offset? logoTopLeftCornerOffset,
    Offset? logoTopRightCornerOffset,
    Offset? logoBottomLeftCornerOffset,
    Offset? logoBottomRightCornerOffset,
    double? logoScale,
    double? logoRotation,
    double? logoOpacity,
    double? logoShadow,
    Color? logoBorderColor,
    double? logoBorderWidth,
    double? logoBorderRadius,
    double? tshirtScale,
  }) {
    this.logoPositionOffset = logoPositionOffset ?? this.logoPositionOffset;
    this.logoTopLeftCornerOffset = logoTopLeftCornerOffset ?? this.logoTopLeftCornerOffset;
    this.logoTopRightCornerOffset = logoTopRightCornerOffset ?? this.logoTopRightCornerOffset;
    this.logoBottomLeftCornerOffset = logoBottomLeftCornerOffset ?? this.logoBottomLeftCornerOffset;
    this.logoBottomRightCornerOffset =
        logoBottomRightCornerOffset ?? this.logoBottomRightCornerOffset;
    this.logoScale = logoScale ?? this.logoScale;
    this.logoRotation = logoRotation ?? this.logoRotation;
    this.logoOpacity = logoOpacity ?? this.logoOpacity;
    this.logoShadow = logoShadow ?? this.logoShadow;
    this.logoBorderColor = logoBorderColor ?? this.logoBorderColor;
    this.logoBorderWidth = logoBorderWidth ?? this.logoBorderWidth;
    this.logoBorderRadius = logoBorderRadius ?? this.logoBorderRadius;
    this.tshirtScale = tshirtScale ?? this.tshirtScale;
  }

  MockupData copyWith({
    String? tshirtImage,
    String? logoImage,
    Offset? logoPositionOffset,
    Offset? logoTopLeftCornerOffset,
    Offset? logoTopRightCornerOffset,
    Offset? logoBottomLeftCornerOffset,
    Offset? logoBottomRightCornerOffset,
    double? logoScale,
    double? logoRotation,
    double? logoOpacity,
    double? logoShadow,
    Color? logoBorderColor,
    double? logoBorderWidth,
    double? logoBorderRadius,
    double? tshirtScale,
  }) {
    return MockupData(
      tshirtImage: tshirtImage ?? this.tshirtImage,
      logoImage: logoImage ?? this.logoImage,
      logoPositionOffset: logoPositionOffset ?? this.logoPositionOffset,
      logoTopLeftCornerOffset: logoTopLeftCornerOffset ?? this.logoTopLeftCornerOffset,
      logoTopRightCornerOffset: logoTopRightCornerOffset ?? this.logoTopRightCornerOffset,
      logoBottomLeftCornerOffset: logoBottomLeftCornerOffset ?? this.logoBottomLeftCornerOffset,
      logoBottomRightCornerOffset: logoBottomRightCornerOffset ?? this.logoBottomRightCornerOffset,
      logoScale: logoScale ?? this.logoScale,
      logoRotation: logoRotation ?? this.logoRotation,
      logoOpacity: logoOpacity ?? this.logoOpacity,
      logoShadow: logoShadow ?? this.logoShadow,
      logoBorderColor: logoBorderColor ?? this.logoBorderColor,
      logoBorderWidth: logoBorderWidth ?? this.logoBorderWidth,
      logoBorderRadius: logoBorderRadius ?? this.logoBorderRadius,
      tshirtScale: tshirtScale ?? this.tshirtScale,
    );
  }
}
