import 'package:flutter/material.dart';

class MockupController extends ValueNotifier<MockupData> {
  MockupController(super.value);
}

class MockupData {
  final String tshirtImage;
  final String logoImage;
  final Offset logoPositionOffset;
  final Offset logoTopLeftCornerOffset;
  final Offset logoTopRightCornerOffset;
  final Offset logoBottomLeftCornerOffset;
  final Offset logoBottomRightCornerOffset;
  final double logoScale;
  final double logoRotation;
  final double logoOpacity;
  final double logoShadow;
  final Color logoBorderColor;
  final double logoBorderWidth;
  final double logoBorderRadius;
  final double tshirtScale;
  final Size tshirtImageSize;
  final Size logoImageSize;
  final Offset tshirtGlobalPosition;

  const MockupData({
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
    Size? tshirtImageSize,
    Size? logoImageSize,
    Offset? tshirtGlobalPosition,
  })  : logoPositionOffset = logoPositionOffset ?? Offset.zero,
        logoTopLeftCornerOffset = logoTopLeftCornerOffset ?? Offset.zero,
        logoTopRightCornerOffset = logoTopRightCornerOffset ?? Offset.zero,
        logoBottomLeftCornerOffset = logoBottomLeftCornerOffset ?? Offset.zero,
        logoBottomRightCornerOffset = logoBottomRightCornerOffset ?? Offset.zero,
        logoScale = logoScale ?? 1.0,
        logoRotation = logoRotation ?? 0.0,
        logoOpacity = logoOpacity ?? 1.0,
        logoShadow = logoShadow ?? 0.0,
        logoBorderColor = logoBorderColor ?? Colors.transparent,
        logoBorderWidth = logoBorderWidth ?? 0.0,
        logoBorderRadius = logoBorderRadius ?? 0.0,
        tshirtScale = tshirtScale ?? 1.0,
        tshirtImageSize = tshirtImageSize ?? Size.zero,
        logoImageSize = logoImageSize ?? Size.zero,
        tshirtGlobalPosition = tshirtGlobalPosition ?? Offset.zero;

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
    Size? tshirtImageSize,
    Size? logoImageSize,
    Offset? tshirtGlobalPosition,
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
      tshirtImageSize: tshirtImageSize ?? this.tshirtImageSize,
      logoImageSize: logoImageSize ?? this.logoImageSize,
      tshirtGlobalPosition: tshirtGlobalPosition ?? this.tshirtGlobalPosition,
    );
  }
}
