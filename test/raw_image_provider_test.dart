import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:raw_image_provider/raw_image_provider.dart';

void main() {
  test('RawImageProvider resolve', () async {
    var width = 10;
    var height = 10;
    var pixels = Uint8List.fromList(
      List.generate(width * height * 4, (i) => i % 4 < 1 ? 0 : 0xff),
    );

    var raw = RawImageData(
      pixels,
      width,
      height,
      pixelFormat: PixelFormat.rgba8888,
    );

    var provider = RawImageProvider(raw);
    Future<ImageInfo> nextFrame() async {
      var completer = Completer<ImageInfo>.sync();
      provider.load(await provider.obtainKey(ImageConfiguration.empty),
          (Uint8List bytes,
              {int? cacheWidth, int? cacheHeight, bool? allowUpscaling}) {
        fail('should not call');
      }).addListener(ImageStreamListener(
        (image, b) {
          expect(image.image, isNotNull);
          completer.complete(image);
        },
        onError: completer.completeError,
      ));
      return completer.future;
    }
    // waiting for image frame
    var imageInfo = await nextFrame();
    expect(imageInfo.image.width, width);
    expect(imageInfo.image.height, height);
    expect(
      imageInfo.image.toByteData().then((b) => b!.buffer.asUint8List()),
      completion(equals(pixels)),
    );
  });
}
