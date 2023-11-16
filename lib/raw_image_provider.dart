import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:crypto/crypto.dart';

/// Decodes the given [image] (raw image pixel data) as an image ('dart:ui')
class RawImageProvider extends ImageProvider<_RawImageKey> {
  final RawImageData image;
  final double? scale;
  final int? targetWidth;
  final int? targetHeight;
  RawImageProvider(
    this.image, {
    this.scale = 1.0,
    this.targetWidth,
    this.targetHeight,
  });

  @override
  ImageStreamCompleter loadImage(
      _RawImageKey key, ImageDecoderCallback decode) {
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key),
      scale: scale ?? 1.0,
      debugLabel: 'RawImageProvider(${describeIdentity(key)})',
    );
  }

  @override
  Future<_RawImageKey> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture(image._obtainKey());
  }

  /// see [ui.decodeImageFromPixels]
  Future<ui.Codec> _loadAsync(_RawImageKey key) async {
    assert(key == image._obtainKey());
    // rgba8888 pixels
    var buffer = await ui.ImmutableBuffer.fromUint8List(image.pixels);

    final descriptor = ui.ImageDescriptor.raw(
      buffer,
      width: image.width,
      height: image.height,
      pixelFormat: image.pixelFormat,
    );
    assert(() {
      debugPrint('ImageDescriptor: ${descriptor.width}x${descriptor.height}');
      return true;
    }());
    return descriptor.instantiateCodec(
        targetWidth: targetWidth, targetHeight: targetHeight);
  }
}

class _RawImageKey {
  final int w;
  final int h;
  final int format;
  final Digest dataHash;
  _RawImageKey(this.w, this.h, this.format, this.dataHash);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is _RawImageKey &&
        other.w == w &&
        other.h == h &&
        other.format == format &&
        other.dataHash == dataHash;
  }

  @override
  int get hashCode {
    return hashValues(w, h, format, dataHash.hashCode);
  }
}

/// Raw pixels data of an image
class RawImageData {
  final Uint8List pixels;
  final int width;
  final int height;
  final ui.PixelFormat pixelFormat;

  RawImageData(
    this.pixels,
    this.width,
    this.height, {
    this.pixelFormat = ui.PixelFormat.rgba8888,
  });

  _RawImageKey? _key;
  _RawImageKey _obtainKey() {
    return _key ??=
        _RawImageKey(width, height, pixelFormat.index, md5.convert(pixels));
  }
}
