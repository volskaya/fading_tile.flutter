import 'package:app/design/colors.dart';
import 'package:app/design/tokens.dart';
import 'package:app/resources/resources.dart';
import 'package:flutter/material.dart';
import 'package:motion_switcher/motion_switcher.dart';

class ExampleMessagePicture extends StatelessWidget {
  const ExampleMessagePicture({
    super.key,
    required this.size,
    required this.sender,
    this.children = const [],
  });

  final Size size;
  final String? sender;
  final List<Widget> children;

  static const images = {
    "One": AssetImage(ImagePortraitAssets.one),
    "Two": AssetImage(ImagePortraitAssets.two),
    "Three": AssetImage(ImagePortraitAssets.three),
  };

  @override
  Widget build(BuildContext context) {
    final initials = sender?.isNotEmpty == true ? sender!.split("").first : "??";
    final colors = OurColors.of(context);

    return Container(
      width: size.width,
      height: size.height,
      decoration: ShapeDecoration(
        shape: RoundedBorders.button,
        color: colors.surface,
      ),
      child: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          Center(
            child: Text(
              initials,
              style: const TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
          MotionImage(
            imageProvider: images[sender],
            fit: BoxFit.cover,
            filterQuality: FilterQuality.none,
            shape: RoundedBorders.button,
          ),
          ...children,
        ],
      ),
    );
  }
}
