// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'button_style.dart';

class TextButtonThemeData with Diagnosticable {
  const TextButtonThemeData({ this.style });

  final ButtonStyle style;

  /// Linearly interpolate between two text button themes.
  static TextButtonThemeData lerp(TextButtonThemeData a, TextButtonThemeData b, double t) {
    assert (t != null);
    if (a == null && b == null)
      return null;
    return TextButtonThemeData(
      style: ButtonStyle.lerp(a?.style, b?.style, t),
    );
  }

  @override
  int get hashCode {
    return style.hashCode;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other))
      return true;
    if (other.runtimeType != runtimeType)
      return false;
    return other is TextButtonThemeData && other.style == style;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<ButtonStyle>('style', style, defaultValue: null));
  }
}

class TextButtonTheme extends InheritedTheme {
  const TextButtonTheme({
    Key key,
    @required this.data,
    Widget child,
  }) : assert(data != null), super(key: key, child: child);

  final TextButtonThemeData data;

  /// The closest instance of this class that encloses the given context.
  ///
  /// If there is no enclosing [TextButtonsTheme] widget, then
  /// [ThemeData.textButtonTheme] is used.
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// TextButtonTheme theme = TextButtonTheme.of(context);
  /// ```
  static TextButtonThemeData of(BuildContext context) {
    final TextButtonTheme buttonTheme = context.dependOnInheritedWidgetOfExactType<TextButtonTheme>();
    return buttonTheme?.data; // TODO(hansmuller) ?? Theme.of(context).textButtonTheme
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    final TextButtonTheme ancestorTheme = context.findAncestorWidgetOfExactType<TextButtonTheme>();
    return identical(this, ancestorTheme) ? child : TextButtonTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(TextButtonTheme oldWidget) => data != oldWidget.data;
}
