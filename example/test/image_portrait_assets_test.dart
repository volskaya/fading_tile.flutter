import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:app/resources/resources.dart';

void main() {
  test('image_portrait_assets assets test', () {
    expect(File(ImagePortraitAssets.one).existsSync(), isTrue);
    expect(File(ImagePortraitAssets.three).existsSync(), isTrue);
    expect(File(ImagePortraitAssets.two).existsSync(), isTrue);
  });
}
