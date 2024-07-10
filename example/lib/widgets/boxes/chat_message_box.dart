import 'dart:math' as math;

import 'package:app/design/tokens.dart';
import 'package:boxy/boxy.dart';
import 'package:flutter/material.dart';

class ChatMessageBox extends StatelessWidget {
  const ChatMessageBox({
    super.key,
    required this.content,
    this.contentCaption,
    this.indicator,
    this.secondaryIndicator,
    this.avatar,
    this.quote,
    this.padding = EdgeInsets.zero,
    this.invert = false,
    this.dividerColor = Colors.deepPurpleAccent,
  });

  final Widget content;
  final Widget? indicator;
  final Widget? secondaryIndicator;
  final Widget? avatar;
  final Widget? contentCaption;
  final Widget? quote;
  final EdgeInsets padding;
  final bool invert;
  final Color dividerColor;

  static const avatarSize = Size.square(xl);
  static const avatarInset = xxs / 2;

  @override
  Widget build(BuildContext context) => Padding(
        padding: padding,
        child: CustomBoxy(
          delegate: _Delegate(
            horizontalPadding: const EdgeInsets.symmetric(horizontal: 16.0),
            invert: invert,
            layoutAvatar: avatar != null,
          ),
          children: [
            LayoutId(id: #content, child: content),
            if (quote != null) LayoutId(id: #quote, child: quote!),
            if (quote != null) LayoutId(id: #quoteDivider, child: ColoredBox(color: dividerColor)),
            if (indicator != null) LayoutId(id: #indicator, child: indicator!),
            if (avatar != null) LayoutId(id: #avatar, child: avatar!),
            if (secondaryIndicator != null) LayoutId(id: #secondaryIndicator, child: secondaryIndicator!),
            if (contentCaption != null) LayoutId(id: #contentCaption, child: contentCaption!),
          ],
        ),
      );
}

class _Delegate extends BoxyDelegate {
  _Delegate({
    this.invert = false,
    this.layoutAvatar = false,
    this.horizontalPadding = EdgeInsets.zero,
  });

  /// Chat tiles can optionally invert their alignment.
  final bool invert;
  final bool layoutAvatar;
  final EdgeInsets horizontalPadding;

  /// The avatar is expected to fade out using `FancySwitcher` with instant sizing.
  /// Still keep the width tight, so there's no jumps in layout.
  BoxConstraints _getAvatarConstraints() => BoxConstraints(
        maxHeight: ChatMessageBox.avatarSize.height,
        minHeight: 0.0,
        minWidth: ChatMessageBox.avatarSize.width,
        maxWidth: ChatMessageBox.avatarSize.width,
      );

  @override
  Size layout() {
    final content = getChild(#content);
    final quote = getChildOrNull(#quote);
    final quoteDivider = getChildOrNull(#quoteDivider);
    final contentCaption = getChildOrNull(#contentCaption);
    final indicator = getChildOrNull(#indicator);
    final secondaryIndicator = getChildOrNull(#secondaryIndicator);
    final avatar = getChildOrNull(#avatar);

    // Content should never have a smaller height than the avatar, to avoid jumping.
    final layoutConstraints = this.constraints;
    final sidePadding = horizontalPadding.horizontal / 2.0;

    // Avatar must layout first to correctly react to its size animation.
    final avatarSize =
        layoutAvatar ? avatar?.layout(_getAvatarConstraints()) ?? const Size.square(0.0) : const Size.square(0.0);
    final avatarSizeAndInset = layoutAvatar ? ChatMessageBox.avatarSize.width - ChatMessageBox.avatarInset : 0.0;

    final constraints = BoxConstraints(
      minHeight: avatarSize.height,
      maxWidth: layoutConstraints.biggest.width - horizontalPadding.horizontal,
      minWidth: 0.0,
      maxHeight: double.infinity,
    );
    final contentConstraints = BoxConstraints(maxWidth: constraints.maxWidth - avatarSizeAndInset);

    // Quote layouts before content, since it's on top of it.
    final quoteSize = quote?.layout(contentConstraints);
    quote?.position(
      !invert
          ? Offset(sidePadding + avatarSizeAndInset, 0.0)
          : Offset(layoutConstraints.biggest.width - sidePadding - avatarSizeAndInset - quoteSize!.width, 0.0),
    );

    const quoteDividerConstraints = BoxConstraints.tightFor(width: xxs / 2, height: xxs / 2);
    quoteDivider?.layout(quoteDividerConstraints);
    quoteDivider?.position(
      Offset(
        !invert ? quote!.rect.left + xs : quote!.rect.right - xs,
        quoteSize!.height,
      ),
    );

    final contentSize = content.layout(contentConstraints);
    final contentOffset = !invert
        ? Offset(sidePadding + avatarSizeAndInset, quoteDivider?.rect.bottom ?? 0.0)
        : Offset(
            layoutConstraints.biggest.width - sidePadding - avatarSizeAndInset - contentSize.width,
            quoteDivider?.rect.bottom ?? 0.0,
          );
    content.position(contentOffset);
    double height = math.max(content.rect.bottom, avatarSize.height);

    if (contentCaption != null) {
      final contentRect = content.rect;
      final size = contentCaption.layout(
        contentConstraints.copyWith(maxWidth: contentConstraints.maxWidth - ChatMessageBox.avatarInset * 4.0),
      );
      final offset = Offset(
        !invert
            ? contentRect.left + ChatMessageBox.avatarInset * 2.0
            : contentRect.right - ChatMessageBox.avatarInset * 2.0 - size.width,
        contentRect.bottom,
      );
      contentCaption.position(offset);
      height = math.max(contentCaption.rect.bottom, avatarSize.height);
    }

    if (avatar != null) {
      final y = height - avatarSize.height;
      final offset = !invert
          ? Offset(sidePadding, y)
          : Offset(layoutConstraints.biggest.width - sidePadding - avatarSize.width, y);
      avatar.position(offset);
    }

    if (indicator != null) {
      final size = indicator.layout(const BoxConstraints());
      final offset = !invert
          ? Offset(
              contentOffset.dx + contentSize.width - size.width / 2.0,
              contentOffset.dy + contentSize.height - size.height / 2.0,
            )
          : Offset(
              contentOffset.dx - size.width / 2.0,
              contentOffset.dy + contentSize.height - size.height / 2.0,
            );
      indicator.position(offset);
    }

    if (secondaryIndicator != null) {
      final indicatorRect = indicator?.rect;
      final size = secondaryIndicator.layout(const BoxConstraints());
      if (indicatorRect != null) {
        final offset = Offset(
          !invert ? indicatorRect.left - size.width : indicatorRect.right,
          contentOffset.dy + contentSize.height - size.height / 2.0,
        );
        secondaryIndicator.position(offset);
      } else {
        final offset = Offset(
          !invert ? contentOffset.dx + contentSize.width - size.width / 2.0 : contentOffset.dx - size.width / 2.0,
          contentOffset.dy + contentSize.height - size.height / 2.0,
        );
        secondaryIndicator.position(offset);
      }
    }

    return Size(layoutConstraints.biggest.width, height);
  }

  @override
  bool shouldRelayout(_Delegate old) =>
      old.invert != invert || old.horizontalPadding != horizontalPadding || old.layoutAvatar != layoutAvatar;
}
