import 'dart:ui';

class MockupSettingsModel {
  final String backgroundUrl;
  final Offset designPosition;
  final double designScale;
  final double designRotationX;
  final double designRotationY;
  final double designRotationZ;
  final double backgroundScale;
  final Offset backgroundSize;
  final Offset backgroundGlobalPosition;
  final int maxResolutionOfRender;

  MockupSettingsModel({
    required this.backgroundUrl,
    required this.designPosition,
    required this.designScale,
    required this.designRotationX,
    required this.designRotationY,
    required this.designRotationZ,
    required this.backgroundScale,
    required this.backgroundSize,
    required this.backgroundGlobalPosition,
    required this.maxResolutionOfRender,
  });

  Map<String, dynamic> toMap() {
    return {
      'backgroundUrl': backgroundUrl,
      'designPositionDx': designPosition.dx,
      'designPositionDy': designPosition.dy,
      'designScale': designScale,
      'designRotationX': designRotationX,
      'designRotationY': designRotationY,
      'designRotationZ': designRotationZ,
      'backgroundScale': backgroundScale,
      'backgroundSizeDx': backgroundSize.dx,
      'backgroundSizeDy': backgroundSize.dy,
      'backgroundGlobalPositionDx': backgroundGlobalPosition.dx,
      'backgroundGlobalPositionDy': backgroundGlobalPosition.dy,
      'maxResolutionOfRender': maxResolutionOfRender,
    };
  }

  factory MockupSettingsModel.fromMap(Map<String, dynamic> map) {
    return MockupSettingsModel(
      backgroundUrl: map['backgroundUrl'],
      designPosition: Offset(map['designPositionDx'], map['designPositionDy']),
      designScale: map['designScale'],
      designRotationX: map['designRotationX'],
      designRotationY: map['designRotationY'],
      designRotationZ: map['designRotationZ'],
      backgroundScale: map['backgroundScale'],
      backgroundSize: Offset(map['backgroundSizeDx'], map['backgroundSizeDy']),
      backgroundGlobalPosition:
          Offset(map['backgroundGlobalPositionDx'], map['backgroundGlobalPositionDy']),
      maxResolutionOfRender: map['maxResolutionOfRender'],
    );
  }
}
