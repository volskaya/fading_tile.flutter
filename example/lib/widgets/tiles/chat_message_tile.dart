import 'package:app/design/colors.dart';
import 'package:app/design/motion.dart';
import 'package:app/design/tokens.dart';
import 'package:app/design/typography.dart';
import 'package:app/extensions/edge_insets.dart';
import 'package:app/models/chat_message.dart';
import 'package:app/widgets/boxes/chat_message_box.dart';
import 'package:app/widgets/example_message_picture.dart';
import 'package:app/widgets/example_message_presence_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:motion_switcher/motion_switcher.dart';
import 'package:nil/nil.dart';

class ChatMessageTile extends StatelessWidget {
  const ChatMessageTile({
    super.key,
    required this.message,
    this.similarPrevious = false,
    this.similarNext = false,
    this.padding = EdgeInsets.zero,
  });

  final ChatMessage message;
  final bool similarPrevious;
  final bool similarNext;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final colors = OurColors.of(context);
    final owned = message.owned;
    final backgroundColor = owned ? colors.accentPrimary : colors.surface;
    final foregroundColor = owned ? colors.onAccentPrimary : colors.onSurface;

    return _Bubble(
      message: message,
      content: Text(message.text),
      backgroundColor: backgroundColor,
      textColor: foregroundColor,
      similarNext: similarNext,
      similarPrevious: similarPrevious,
      invert: owned,
      padding: padding,
    );
  }
}

class _Bubble extends HookWidget {
  const _Bubble({
    super.key, // ignore: unused_element
    required this.message,
    required this.content,
    this.invert = false,
    this.textPadding = const EdgeInsets.all(xxs), // ignore: unused_element
    this.padding = EdgeInsets.zero,
    this.backgroundColor = Colors.deepOrange,
    this.textColor = Colors.white,
    this.similarPrevious = false,
    this.similarNext = false,
    this.clip = true, // ignore: unused_element
    this.onPressed, // ignore: unused_element
  });

  final ChatMessage message;
  final bool invert;
  final Widget content;
  final EdgeInsets textPadding;
  final EdgeInsets padding;
  final Color backgroundColor;
  final Color textColor;
  final bool similarPrevious;
  final bool similarNext;
  final bool clip;
  final VoidCallback? onPressed;

  static final _dateFormatter = DateFormat.yMd().add_jm();

  @override
  Widget build(BuildContext context) {
    final colors = OurColors.of(context);
    final typography = OurTypography.of(context);
    final horizontalPadding = MediaQuery.paddingOf(context).getSidesOnly();

    final buildAvatar = !similarNext;
    final buildAvatarSwitcher = useMemoized(() => buildAvatar);

    final animationDuration = Motion.durations.medium;
    final animationEasing = Motion.curves.emphasized;

    return AnimatedSize(
      duration: animationDuration,
      reverseDuration: animationDuration,
      curve: animationEasing,
      alignment: Alignment.topCenter,
      clipBehavior: Clip.none,
      child: ChatMessageBox(
        content: Container(
          decoration: ShapeDecoration(shape: RoundedBorders.button, color: backgroundColor),
          clipBehavior: clip ? Clip.antiAlias : Clip.none,
          padding: textPadding,
          child: IconTheme.merge(
            data: IconThemeData(color: textColor, size: xs),
            child: DefaultTextStyle(
              style: typography.body.copyWith(color: textColor),
              child: content,
            ),
          ),
        ),
        padding: padding + horizontalPadding,
        invert: invert,
        dividerColor: colors.hint,
        contentCaption: !buildAvatarSwitcher
            ? null
            : TweenAnimationBuilder<Color?>(
                duration: animationDuration, // Match with message avatar fade duration.
                curve: !buildAvatar ? Motion.curves.emphasizedDecelerate : Motion.curves.emphasizedAccelerate,
                tween: ColorTween(end: buildAvatar ? colors.hint : colors.hint.withAlpha(0)),
                builder: (_, value, __) => value == null || value.alpha == 0
                    ? nil
                    : Padding(
                        padding: const EdgeInsets.fromLTRB(xxs, xxs / 2, xxs, 0.0),
                        child: Text(
                          _dateFormatter.format(message.date),
                          maxLines: 1,
                          style: typography.caption.apply(color: value),
                        ),
                      ),
              ),
        avatar: !buildAvatarSwitcher
            ? nil
            : MotionSwitcher(
                instantSize: false,
                duration: Motion.durations.medium,
                child: !buildAvatar
                    ? null
                    : ExampleMessagePicture(
                        size: ChatMessageBox.avatarSize,
                        sender: message.sender,
                        children: !invert
                            ? [ExampleMessagePresenceIndicator(invert: invert)] //
                            : const <Widget>[],
                      ),
              ),
      ),
    );
  }
}
