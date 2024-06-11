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

  MockupSettingsModel copyWith({
    String? backgroundUrl,
    Offset? designPosition,
    double? designScale,
    double? designRotationX,
    double? designRotationY,
    double? designRotationZ,
    double? backgroundScale,
    Offset? backgroundSize,
    Offset? backgroundGlobalPosition,
    int? maxResolutionOfRender,
  }) {
    return MockupSettingsModel(
      backgroundUrl: backgroundUrl ?? this.backgroundUrl,
      designPosition: designPosition ?? this.designPosition,
      designScale: designScale ?? this.designScale,
      designRotationX: designRotationX ?? this.designRotationX,
      designRotationY: designRotationY ?? this.designRotationY,
      designRotationZ: designRotationZ ?? this.designRotationZ,
      backgroundScale: backgroundScale ?? this.backgroundScale,
      backgroundSize: backgroundSize ?? this.backgroundSize,
      backgroundGlobalPosition: backgroundGlobalPosition ?? this.backgroundGlobalPosition,
      maxResolutionOfRender: maxResolutionOfRender ?? this.maxResolutionOfRender,
    );
  }

  @override
  String toString() {
    return 'MockupSettingsModel(backgroundUrl: $backgroundUrl, designPosition: $designPosition, designScale: $designScale, designRotationX: $designRotationX, designRotationY: $designRotationY, designRotationZ: $designRotationZ, backgroundScale: $backgroundScale, backgroundSize: $backgroundSize, backgroundGlobalPosition: $backgroundGlobalPosition, maxResolutionOfRender: $maxResolutionOfRender)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MockupSettingsModel &&
        other.backgroundUrl == backgroundUrl &&
        other.designPosition == designPosition &&
        other.designScale == designScale &&
        other.designRotationX == designRotationX &&
        other.designRotationY == designRotationY &&
        other.designRotationZ == designRotationZ &&
        other.backgroundScale == backgroundScale &&
        other.backgroundSize == backgroundSize &&
        other.backgroundGlobalPosition == backgroundGlobalPosition &&
        other.maxResolutionOfRender == maxResolutionOfRender;
  }

  @override
  int get hashCode {
    return backgroundUrl.hashCode ^
        designPosition.hashCode ^
        designScale.hashCode ^
        designRotationX.hashCode ^
        designRotationY.hashCode ^
        designRotationZ.hashCode ^
        backgroundScale.hashCode ^
        backgroundSize.hashCode ^
        backgroundGlobalPosition.hashCode ^
        maxResolutionOfRender.hashCode;
  }
}
