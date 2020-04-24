// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'button_style.dart';

class ContainedButtonThemeData with Diagnosticable {
  const ContainedButtonThemeData({ this.style });

  final ButtonStyle style;

  /// Linearly interpolate between two text button themes.
  static ContainedButtonThemeData lerp(ContainedButtonThemeData a, ContainedButtonThemeData b, double t) {
    assert (t != null);
    if (a == null && b == null)
      return null;
    return ContainedButtonThemeData(
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
    return other is ContainedButtonThemeData && other.style == style;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<ButtonStyle>('style', style, defaultValue: null));
  }
}

class ContainedButtonTheme extends InheritedTheme {
  const ContainedButtonTheme({
    Key key,
    @required this.data,
    Widget child,
  }) : assert(data != null), super(key: key, child: child);

  final ContainedButtonThemeData data;

  /// The closest instance of this class that encloses the given context.
  ///
  /// If there is no enclosing [ContainedButtonsTheme] widget, then
  /// [ThemeData.textButtonTheme] is used.
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// ContainedButtonTheme theme = ContainedButtonTheme.of(context);
  /// ```
  static ContainedButtonThemeData of(BuildContext context) {
    final ContainedButtonTheme buttonTheme = context.dependOnInheritedWidgetOfExactType<ContainedButtonTheme>();
    return buttonTheme?.data; // TODO(hansmuller) ?? Theme.of(context).containedButtonTheme
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    final ContainedButtonTheme ancestorTheme = context.findAncestorWidgetOfExactType<ContainedButtonTheme>();
    return identical(this, ancestorTheme) ? child : ContainedButtonTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(ContainedButtonTheme oldWidget) => data != oldWidget.data;
}
