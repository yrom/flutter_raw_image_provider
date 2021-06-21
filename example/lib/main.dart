import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:raw_image_provider/raw_image_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        appBar: AppBar(title: Text('Flutter raw image provider')),
        body: ListView(
          itemExtent: 80,
          children: List.generate(100, (i) {
            return StatefulBuilder(
              builder: (c, setState) {
                return ListTile(
                  trailing: Image(
                    fit: BoxFit.fitHeight,
                    image: RawImageProvider(createRawImage(120, 40)),
                  ),
                  title: Text('No. $i'),
                  subtitle: Text('Tap to refresh image'),
                  onTap: () => setState(() {}),
                );
              },
            );
          }),
        ),
      ),
    );
  }

  RawImageData createRawImage(int width, int height) {
    var r = Random();
    var pixels = Uint8List.fromList(List.generate(width * height, (i) {
      return [i % 256, r.nextInt(256), r.nextInt(256), 0xff];
    }).expand((list) => list).toList());

    return RawImageData(
      pixels,
      width,
      height,
      pixelFormat: PixelFormat.rgba8888,
    );
  }
}
