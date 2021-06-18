# Raw pixel data ImageProvider

Support Image widget to load raw rgba pixels data.

## Example
```dart
    // create RawImageData
    var width = 100;
    var height = 100;
    var pixels = Uint8List.fromList(
        List.generate(width * height * 4, (i) => i % 4 < 1 ? 0 : 0xff),
    );

    var raw = RawImageData(
        pixels,
        width,
        height,
        pixelFormat: PixelFormat.rgba8888,
    );
    // build Image Widget:
    var image = Image(image: RawImageProvider(raw));
```