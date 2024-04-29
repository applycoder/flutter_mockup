// import 'dart:math';

// import 'package:flutter/material.dart';
// import 'package:flutter_mockup/flutter_mockup.dart';

// class Logo1 extends StatefulWidget {
//   final MockupController _controller;
//   Logo1({super.key, MockupController? controller})
//       : _controller = controller ??
//             MockupController(const MockupData(
//               tshirtImage: '',
//               logoImage: '',
//             ));

//   @override
//   State<Logo1> createState() => _Logo1State();
// }

// class _Logo1State extends State<Logo1> {
//   final ValueNotifier<ImageInfo?> tshirtImageInfo = ValueNotifier(null);
//   final ValueNotifier<ImageInfo?> logoImageInfo = ValueNotifier(null);
//   final GlobalKey tshirtKey = GlobalKey();
//   bool dragStarted = false;
//   double cornersSize = 10;
//   RenderBox? tshirtRenderBox;
//   @override
//   void initState() {
//     super.initState();

//     final tshirtImage = Image.asset(
//       widget._controller.value.tshirtImage,
//       fit: BoxFit.contain,
//     );
//     final logoImage = Image.asset(
//       widget._controller.value.logoImage,
//       fit: BoxFit.contain,
//     );
//     tshirtImage.image.resolve(const ImageConfiguration()).addListener(
//       ImageStreamListener(
//         (info, _) {
//           tshirtImageInfo.value = info;
//         },
//       ),
//     );
//     logoImage.image.resolve(const ImageConfiguration()).addListener(
//       ImageStreamListener(
//         (info, _) {
//           logoImageInfo.value = info;
//         },
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ValueListenableBuilder(
//         valueListenable: logoImageInfo,
//         builder: (context, logoImageValue, child) {
//           return ValueListenableBuilder(
//               valueListenable: tshirtImageInfo,
//               builder: (context, tshirtImageValue, child) {
//                 if (tshirtImageValue == null || logoImageValue == null) {
//                   return const Center(
//                     child: CircularProgressIndicator(),
//                   );
//                 } else {
//                   return ValueListenableBuilder(
//                       valueListenable: widget._controller,
//                       builder: (context, controllerValue, child) {
//                         return LayoutBuilder(builder: (context, constraints) {
//                           Future.delayed(Duration.zero, () {
//                             // Get resolution of the tshirt image
//                             final tshirtImageSize = Size(tshirtImageValue.image.width.toDouble(),
//                                 tshirtImageValue.image.height.toDouble());
//                             // Get the render box of the tshirt image
//                             tshirtRenderBox =
//                                 tshirtKey.currentContext!.findRenderObject() as RenderBox;
//                             // Get the size of the tshirt render box
//                             final tshirtRenderSize = tshirtRenderBox!.size;
//                             // Calculate the scale of the tshirt image
//                             final tshirtCurrentScale = min(
//                                 tshirtRenderSize.width / tshirtImageSize.width,
//                                 tshirtRenderSize.height / tshirtImageSize.height);
//                             // Get the previous scale of the tshirt image
//                             final tshirtPreviousScale = controllerValue.tshirtScale;
//                             // Get resolution of the logo image
//                             final logoImageSize = Size(logoImageValue.image.width.toDouble(),
//                                 logoImageValue.image.height.toDouble());
//                             // Update the controller value
//                             if (tshirtPreviousScale != tshirtCurrentScale) {
//                               widget._controller.value = controllerValue.copyWith(
//                                 tshirtScale: tshirtCurrentScale,
//                                 tshirtImageSize: tshirtImageSize,
//                                 logoImageSize: logoImageSize,
//                                 logoPosition: Offset(
//                                   controllerValue.logoPosition.dx *
//                                       tshirtCurrentScale /
//                                       tshirtPreviousScale,
//                                   controllerValue.logoPosition.dy *
//                                       tshirtCurrentScale /
//                                       tshirtPreviousScale,
//                                 ),
//                               );
//                             }
//                           });
//                           return Stack(
//                             children: [
//                               Align(
//                                 alignment: Alignment.topLeft,
//                                 child: Image.asset(
//                                   controllerValue.tshirtImage,
//                                   fit: BoxFit.contain,
//                                   key: tshirtKey,
//                                 ),
//                               ),
//                               Positioned(
//                                 left: controllerValue.logoPosition.dx,
//                                 top: controllerValue.logoPosition.dy,
//                                 child: Transform.rotate(
//                                   angle: controllerValue.logoRotation,
//                                   child: Stack(
//                                     children: [
//                                       _buildSide(
//                                         mockupData: controllerValue,
//                                         dragStarted: dragStarted,
//                                         left: 10,
//                                         right: 10,
//                                         size: cornersSize,
//                                         onPanUpdate: (details) {
//                                           final cursorOffset = details.globalPosition;
//                                           final imageCenterOffset = Offset(
//                                             controllerValue.logoPosition.dx +
//                                                 controllerValue.logoImageSize.width *
//                                                     controllerValue.tshirtScale *
//                                                     controllerValue.logoScale /
//                                                     2,
//                                             controllerValue.logoPosition.dy +
//                                                 controllerValue.logoImageSize.height *
//                                                     controllerValue.tshirtScale *
//                                                     controllerValue.logoScale /
//                                                     2,
//                                           );
//                                           final rotation = atan2(
//                                             cursorOffset.dy - imageCenterOffset.dy,
//                                             cursorOffset.dx - imageCenterOffset.dx,
//                                           );
//                                           widget._controller.value = controllerValue.copyWith(
//                                             logoRotation: rotation,
//                                           );
//                                         },
//                                       ),
//                                       _buildSide(
//                                         mockupData: controllerValue,
//                                         dragStarted: dragStarted,
//                                         top: 10,
//                                         bottom: 10,
//                                         left: 0,
//                                         size: cornersSize,
//                                         onPanUpdate: (details) {
//                                           final cursorOffset = details.globalPosition;
//                                           final imageCenterOffset = Offset(
//                                             controllerValue.logoPosition.dx +
//                                                 controllerValue.logoImageSize.width *
//                                                     controllerValue.tshirtScale *
//                                                     controllerValue.logoScale /
//                                                     2,
//                                             controllerValue.logoPosition.dy +
//                                                 controllerValue.logoImageSize.height *
//                                                     controllerValue.tshirtScale *
//                                                     controllerValue.logoScale /
//                                                     2,
//                                           );
//                                           final rotation = atan2(
//                                             cursorOffset.dy - imageCenterOffset.dy,
//                                             cursorOffset.dx - imageCenterOffset.dx,
//                                           );
//                                           widget._controller.value = controllerValue.copyWith(
//                                             logoRotation: rotation,
//                                           );
//                                         },
//                                       ),
//                                       _buildSide(
//                                         mockupData: controllerValue,
//                                         dragStarted: dragStarted,
//                                         top: 10,
//                                         bottom: 10,
//                                         right: 0,
//                                         size: cornersSize,
//                                         onPanUpdate: (details) {
//                                           final cursorOffset = details.globalPosition;
//                                           final imageCenterOffset = Offset(
//                                             controllerValue.logoPosition.dx +
//                                                 controllerValue.logoImageSize.width *
//                                                     controllerValue.tshirtScale *
//                                                     controllerValue.logoScale /
//                                                     2,
//                                             controllerValue.logoPosition.dy +
//                                                 controllerValue.logoImageSize.height *
//                                                     controllerValue.tshirtScale *
//                                                     controllerValue.logoScale /
//                                                     2,
//                                           );
//                                           final rotation = atan2(
//                                             cursorOffset.dy - imageCenterOffset.dy,
//                                             cursorOffset.dx - imageCenterOffset.dx,
//                                           );
//                                           widget._controller.value = controllerValue.copyWith(
//                                             logoRotation: rotation,
//                                           );
//                                         },
//                                       ),
//                                       _buildSide(
//                                         mockupData: controllerValue,
//                                         dragStarted: dragStarted,
//                                         left: 10,
//                                         right: 10,
//                                         bottom: 0,
//                                         size: cornersSize,
//                                         onPanUpdate: (details) {
//                                           final cursorOffset = details.globalPosition;
//                                           final imageCenterOffset = Offset(
//                                             controllerValue.logoPosition.dx +
//                                                 controllerValue.logoImageSize.width *
//                                                     controllerValue.tshirtScale *
//                                                     controllerValue.logoScale /
//                                                     2,
//                                             controllerValue.logoPosition.dy +
//                                                 controllerValue.logoImageSize.height *
//                                                     controllerValue.tshirtScale *
//                                                     controllerValue.logoScale /
//                                                     2,
//                                           );
//                                           final rotation = atan2(
//                                             cursorOffset.dy - imageCenterOffset.dy,
//                                             cursorOffset.dx - imageCenterOffset.dx,
//                                           );
//                                           widget._controller.value = controllerValue.copyWith(
//                                             logoRotation: rotation,
//                                           );
//                                         },
//                                       ),
//                                       _buildCorner(
//                                         top: 0,
//                                         left: 0,
//                                         cursor: SystemMouseCursors.resizeUpLeft,
//                                         mockupData: controllerValue,
//                                         dragStarted: dragStarted,
//                                         cornersSize: cornersSize,
//                                         onPanUpdate: (details) {
//                                           final imageOffsetMirrorCorner =
//                                               controllerValue.logoPosition;
//                                           final pointerOffset = details.globalPosition;
//                                           final newX =
//                                               pointerOffset.dx - imageOffsetMirrorCorner.dx - 5;
//                                           final newY =
//                                               pointerOffset.dy - imageOffsetMirrorCorner.dy - 5;
//                                           final scalex = newX /
//                                               (controllerValue.logoImageSize.width *
//                                                   controllerValue.tshirtScale);
//                                           final scaley = newY /
//                                               (controllerValue.logoImageSize.height *
//                                                   controllerValue.tshirtScale);
//                                           final newScale = max(0.01, max(scalex, scaley));
//                                           widget._controller.value = controllerValue.copyWith(
//                                             logoScale: newScale,
//                                           );
//                                         },
//                                       ),
//                                       _buildCorner(
//                                         top: 0,
//                                         right: 0,
//                                         cursor: SystemMouseCursors.resizeUpRight,
//                                         mockupData: controllerValue,
//                                         dragStarted: dragStarted,
//                                         cornersSize: cornersSize,
//                                         onPanUpdate: (details) {
//                                           final imageOffsetMirrorCorner =
//                                               controllerValue.logoPosition;
//                                           final pointerOffset = details.globalPosition;
//                                           final newX =
//                                               pointerOffset.dx - imageOffsetMirrorCorner.dx - 5;
//                                           final newY =
//                                               pointerOffset.dy - imageOffsetMirrorCorner.dy - 5;
//                                           final scalex = newX /
//                                               (controllerValue.logoImageSize.width *
//                                                   controllerValue.tshirtScale);
//                                           final scaley = newY /
//                                               (controllerValue.logoImageSize.height *
//                                                   controllerValue.tshirtScale);
//                                           final newScale = max(0.01, max(scalex, scaley));
//                                           widget._controller.value = controllerValue.copyWith(
//                                             logoScale: newScale,
//                                           );
//                                         },
//                                       ),
//                                       _buildCorner(
//                                         bottom: 0,
//                                         left: 0,
//                                         cursor: SystemMouseCursors.resizeDownLeft,
//                                         mockupData: controllerValue,
//                                         dragStarted: dragStarted,
//                                         cornersSize: cornersSize,
//                                         onPanUpdate: (details) {
//                                           final imageOffsetMirrorCorner =
//                                               controllerValue.logoPosition;
//                                           final pointerOffset = details.globalPosition;
//                                           final newX =
//                                               pointerOffset.dx - imageOffsetMirrorCorner.dx - 5;
//                                           final newY =
//                                               pointerOffset.dy - imageOffsetMirrorCorner.dy - 5;
//                                           final scalex = newX /
//                                               (controllerValue.logoImageSize.width *
//                                                   controllerValue.tshirtScale);
//                                           final scaley = newY /
//                                               (controllerValue.logoImageSize.height *
//                                                   controllerValue.tshirtScale);
//                                           final newScale = max(0.01, max(scalex, scaley));
//                                           widget._controller.value = controllerValue.copyWith(
//                                             logoScale: newScale,
//                                           );
//                                         },
//                                       ),
//                                       _buildCorner(
//                                         bottom: 0,
//                                         right: 0,
//                                         cursor: SystemMouseCursors.resizeDownRight,
//                                         mockupData: controllerValue,
//                                         dragStarted: dragStarted,
//                                         cornersSize: cornersSize,
//                                         onPanUpdate: (details) {
//                                           final imageOffsetMirrorCorner =
//                                               controllerValue.logoPosition;
//                                           final pointerOffset = details.globalPosition;
//                                           final newX =
//                                               pointerOffset.dx - imageOffsetMirrorCorner.dx - 5;
//                                           final newY =
//                                               pointerOffset.dy - imageOffsetMirrorCorner.dy - 5;
//                                           final scalex = newX /
//                                               (controllerValue.logoImageSize.width *
//                                                   controllerValue.tshirtScale);
//                                           final scaley = newY /
//                                               (controllerValue.logoImageSize.height *
//                                                   controllerValue.tshirtScale);
//                                           final newScale = max(0.01, max(scalex, scaley));
//                                           widget._controller.value = controllerValue.copyWith(
//                                             logoScale: newScale,
//                                           );
//                                         },
//                                       ),
//                                       Padding(
//                                         padding: EdgeInsets.all(cornersSize),
//                                         child: Draggable(
//                                           onDragStarted: () {
//                                             setState(() {
//                                               dragStarted = true;
//                                             });
//                                           },
//                                           onDragEnd: (details) {
//                                             widget._controller.value = controllerValue.copyWith(
//                                                 logoPosition: details.offset);
//                                             setState(() {
//                                               dragStarted = false;
//                                             });
//                                           },
//                                           childWhenDragging: Container(),
//                                           feedback: Transform.translate(
//                                             offset: Offset(-cornersSize, -cornersSize),
//                                             child: Transform.rotate(
//                                               angle: controllerValue.logoRotation,
//                                               child: Stack(
//                                                 children: [
//                                                   _buildSide(
//                                                     mockupData: controllerValue,
//                                                     dragStarted: dragStarted,
//                                                     left: 10,
//                                                     right: 10,
//                                                     size: cornersSize,
//                                                     onPanUpdate: null,
//                                                   ),
//                                                   _buildSide(
//                                                     mockupData: controllerValue,
//                                                     dragStarted: dragStarted,
//                                                     top: 10,
//                                                     bottom: 10,
//                                                     left: 0,
//                                                     size: cornersSize,
//                                                     onPanUpdate: null,
//                                                   ),
//                                                   _buildSide(
//                                                     mockupData: controllerValue,
//                                                     dragStarted: dragStarted,
//                                                     top: 10,
//                                                     bottom: 10,
//                                                     right: 0,
//                                                     size: cornersSize,
//                                                     onPanUpdate: null,
//                                                   ),
//                                                   _buildSide(
//                                                     mockupData: controllerValue,
//                                                     dragStarted: dragStarted,
//                                                     left: 10,
//                                                     right: 10,
//                                                     bottom: 0,
//                                                     size: cornersSize,
//                                                     onPanUpdate: null,
//                                                   ),
//                                                   _buildCorner(
//                                                     top: 0,
//                                                     left: 0,
//                                                     mockupData: controllerValue,
//                                                     dragStarted: dragStarted,
//                                                     onPanUpdate: null,
//                                                     cornersSize: cornersSize,
//                                                   ),
//                                                   _buildCorner(
//                                                     top: 0,
//                                                     right: 0,
//                                                     mockupData: controllerValue,
//                                                     dragStarted: dragStarted,
//                                                     onPanUpdate: null,
//                                                     cornersSize: cornersSize,
//                                                   ),
//                                                   _buildCorner(
//                                                     bottom: 0,
//                                                     left: 0,
//                                                     mockupData: controllerValue,
//                                                     dragStarted: dragStarted,
//                                                     onPanUpdate: null,
//                                                     cornersSize: cornersSize,
//                                                   ),
//                                                   _buildCorner(
//                                                     bottom: 0,
//                                                     right: 0,
//                                                     mockupData: controllerValue,
//                                                     dragStarted: dragStarted,
//                                                     onPanUpdate: null,
//                                                     cornersSize: cornersSize,
//                                                   ),
//                                                   Container(
//                                                       padding: EdgeInsets.all(cornersSize),
//                                                       child: _buildLogo(controllerValue)),
//                                                 ],
//                                               ),
//                                             ),
//                                           ),
//                                           child: _buildLogo(controllerValue),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           );
//                         });
//                       });
//                 }
//               });
//         });
//   }

//   Positioned _buildSide({
//     required MockupData mockupData,
//     required bool dragStarted,
//     required Function(DragUpdateDetails)? onPanUpdate,
//     required double size,
//     double? left,
//     double? right,
//     double? top,
//     double? bottom,
//     MouseCursor? cursor,
//   }) {
//     return Positioned(
//       left: left,
//       right: right,
//       top: top,
//       bottom: bottom,
//       child: Opacity(
//         opacity: dragStarted ? 0.0 : 1.0,
//         child: MouseRegion(
//           cursor: cursor ?? SystemMouseCursors.click,
//           child: GestureDetector(
//             onPanUpdate: onPanUpdate,
//             child: Container(
//               width: size,
//               height: size,
//               decoration: BoxDecoration(
//                 color: Colors.green.withOpacity(0.7),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Positioned _buildCorner({
//     required MockupData mockupData,
//     required bool dragStarted,
//     required Function(DragUpdateDetails)? onPanUpdate,
//     required double cornersSize,
//     double? left,
//     double? right,
//     double? top,
//     double? bottom,
//     MouseCursor? cursor,
//   }) {
//     return Positioned(
//       left: left,
//       right: right,
//       top: top,
//       bottom: bottom,
//       child: Opacity(
//         opacity: dragStarted ? 0.0 : 1.0,
//         child: MouseRegion(
//           cursor: cursor ?? SystemMouseCursors.click,
//           child: GestureDetector(
//             onPanUpdate: onPanUpdate,
//             child: Container(
//               width: cornersSize,
//               height: cornersSize,
//               decoration: BoxDecoration(
//                 color: Colors.red.withOpacity(0.7),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildLogo(MockupData value) {
//     return MouseRegion(
//       cursor: SystemMouseCursors.move,
//       child: Image.asset(
//         value.logoImage,
//         fit: BoxFit.contain,
//         width: value.logoImageSize.width * value.tshirtScale * value.logoScale,
//         height: value.logoImageSize.height * value.tshirtScale * value.logoScale,
//       ),
//     );
//   }
// }
