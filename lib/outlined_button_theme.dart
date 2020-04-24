// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'button_style.dart';

class OutlinedButtonThemeData with Diagnosticable {
  const OutlinedButtonThemeData({ this.style });

  final ButtonStyle style;

  /// Linearly interpolate between two text button themes.
  static OutlinedButtonThemeData lerp(OutlinedButtonThemeData a, OutlinedButtonThemeData b, double t) {
    assert (t != null);
    if (a == null && b == null)
      return null;
    return OutlinedButtonThemeData(
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
    return other is OutlinedButtonThemeData && other.style == style;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<ButtonStyle>('style', style, defaultValue: null));
  }
}

class OutlinedButtonTheme extends InheritedTheme {
  const OutlinedButtonTheme({
    Key key,
    @required this.data,
    Widget child,
  }) : assert(data != null), super(key: key, child: child);

  final OutlinedButtonThemeData data;

  /// The closest instance of this class that encloses the given context.
  ///
  /// If there is no enclosing [OutlinedButtonsTheme] widget, then
  /// [ThemeData.textButtonTheme] is used.
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// OutlinedButtonTheme theme = OutlinedButtonTheme.of(context);
  /// ```
  static OutlinedButtonThemeData of(BuildContext context) {
    final OutlinedButtonTheme buttonTheme = context.dependOnInheritedWidgetOfExactType<OutlinedButtonTheme>();
    return buttonTheme?.data; // TODO(hansmuller) ?? Theme.of(context).containedButtonTheme
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    final OutlinedButtonTheme ancestorTheme = context.findAncestorWidgetOfExactType<OutlinedButtonTheme>();
    return identical(this, ancestorTheme) ? child : OutlinedButtonTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(OutlinedButtonTheme oldWidget) => data != oldWidget.data;
}
