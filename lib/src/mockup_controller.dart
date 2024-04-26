import 'package:flutter/material.dart';

class MockupController extends ValueNotifier<MockupData> {
  MockupController(super.value);
}

class MockupData {
  final String tshirtImage;
  final String logoImage;
  final Offset logoPosition;
  final double logoScale;
  final double logoRotation;
  final double tshirtScale;
  final Offset tshirtImageSize;
  final Offset logoImageSize;
  final Offset tshirtGlobalPosition;

  const MockupData({
    required this.tshirtImage,
    required this.logoImage,
    Offset? logoPosition,
    double? logoScale,
    double? logoRotation,
    double? tshirtScale,
    Offset? tshirtImageSize,
    Offset? logoImageSize,
    Offset? tshirtGlobalPosition,
  })  : logoPosition = logoPosition ?? Offset.zero,
        logoScale = logoScale ?? 1.0,
        logoRotation = logoRotation ?? 0.0,
        tshirtScale = tshirtScale ?? 1.0,
        tshirtImageSize = tshirtImageSize ?? Offset.zero,
        logoImageSize = logoImageSize ?? Offset.zero,
        tshirtGlobalPosition = tshirtGlobalPosition ?? Offset.zero;

  Offset get logoWidgetSize => logoImageSize * tshirtScale * logoScale;
  Offset get logoGlobalPosition => tshirtGlobalPosition + logoPosition;

  MockupData copyWith({
    String? tshirtImage,
    String? logoImage,
    Offset? logoPosition,
    double? logoScale,
    double? logoRotation,
    double? tshirtScale,
    Offset? tshirtImageSize,
    Offset? logoImageSize,
    Offset? tshirtGlobalPosition,
  }) {
    return MockupData(
      tshirtImage: tshirtImage ?? this.tshirtImage,
      logoImage: logoImage ?? this.logoImage,
      logoPosition: logoPosition ?? this.logoPosition,
      logoScale: logoScale ?? this.logoScale,
      logoRotation: logoRotation ?? this.logoRotation,
      tshirtScale: tshirtScale ?? this.tshirtScale,
      tshirtImageSize: tshirtImageSize ?? this.tshirtImageSize,
      logoImageSize: logoImageSize ?? this.logoImageSize,
      tshirtGlobalPosition: tshirtGlobalPosition ?? this.tshirtGlobalPosition,
    );
  }
}
