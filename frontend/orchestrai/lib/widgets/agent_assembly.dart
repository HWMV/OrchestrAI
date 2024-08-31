// import 'dart:io';
// import 'dart:typed_data';
// import 'package:flutter/services.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:image/image.dart' as img;

// class AgentAssembly {
//   static Future<String> assembleAndSaveAgent(
//       String head, String body, String tool) async {
//     // Load images
//     final headImage = await loadImage(head);
//     final bodyImage = await loadImage(body);
//     final toolImage = await loadImage(tool);

//     // Create a new image to compose on
//     final compositeImage = img.Image(width: 300, height: 400);

//     // Compose images
//     img.compositeImage(compositeImage, headImage, dstX: 100, dstY: 0);
//     img.compositeImage(compositeImage, bodyImage, dstX: 50, dstY: 150);
//     img.compositeImage(compositeImage, toolImage, dstX: 200, dstY: 200);

//     // Save the composite image
//     final tempDir = await getTemporaryDirectory();
//     final file = File(
//         '${tempDir.path}/agent_${DateTime.now().millisecondsSinceEpoch}.png');
//     await file.writeAsBytes(img.encodePng(compositeImage));

//     return file.path;
//   }

//   static Future<img.Image> loadImage(String assetPath) async {
//     final ByteData data = await rootBundle.load(assetPath);
//     return img.decodeImage(data.buffer.asUint8List())!;
//   }
// }
