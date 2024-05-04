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
      'designPosition': designPosition,
      'designScale': designScale,
      'designRotationX': designRotationX,
      'designRotationY': designRotationY,
      'designRotationZ': designRotationZ,
      'backgroundScale': backgroundScale,
      'backgroundSize': backgroundSize,
      'backgroundGlobalPosition': backgroundGlobalPosition,
      'maxResolutionOfRender': maxResolutionOfRender,
    };
  }

  factory MockupSettingsModel.fromMap(Map<String, dynamic> map) {
    return MockupSettingsModel(
      backgroundUrl: map['backgroundUrl'],
      designPosition: Offset(map['designPosition']['dx'], map['designPosition']['dy']),
      designScale: map['designScale'],
      designRotationX: map['designRotationX'],
      designRotationY: map['designRotationY'],
      designRotationZ: map['designRotationZ'],
      backgroundScale: map['backgroundScale'],
      backgroundSize: Offset(map['backgroundSize']['dx'], map['backgroundSize']['dy']),
      backgroundGlobalPosition:
          Offset(map['backgroundGlobalPosition']['dx'], map['backgroundGlobalPosition']['dy']),
      maxResolutionOfRender: map['maxResolutionOfRender'],
    );
  }
}
