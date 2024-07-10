import 'package:flutter/material.dart';

extension EdgeInsetsExt on EdgeInsets {
  EdgeInsets getSidesOnly() => EdgeInsets.only(left: left, right: right);
  EdgeInsets getTopOnly() => EdgeInsets.only(top: top);
  EdgeInsets getBottomOnly() => EdgeInsets.only(bottom: bottom);
}
