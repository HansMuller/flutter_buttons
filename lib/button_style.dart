// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:ui' show lerpDouble;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ButtonStyle with Diagnosticable {
  const ButtonStyle({
    this.textStyle,
    this.backgroundColor,
    this.foregroundColor,
    this.overlayColor,
    this.elevation,
    this.padding,
    this.minimumSize,
    this.side,
    this.shape,
    this.visualDensity,
    this.tapTargetSize,
  });

  final MaterialStateProperty<TextStyle> textStyle;
  final MaterialStateProperty<Color> backgroundColor;
  final MaterialStateProperty<Color> foregroundColor;
  final MaterialStateProperty<Color> overlayColor;
  final MaterialStateProperty<double> elevation;
  final MaterialStateProperty<EdgeInsetsGeometry> padding;
  final MaterialStateProperty<Size> minimumSize;
  final MaterialStateProperty<BorderSide> side;
  final MaterialStateProperty<ShapeBorder> shape;
  final VisualDensity visualDensity;
  final MaterialTapTargetSize tapTargetSize;

  /// Returns a copy of this ButtonStyle with the given fields replaced with
  /// the new values.
  ButtonStyle copyWith({
    MaterialStateProperty<TextStyle> textStyle,
    MaterialStateProperty<Color> backgroundColor,
    MaterialStateProperty<Color> foregroundColor,
    MaterialStateProperty<Color> overlayColor,
    MaterialStateProperty<double> elevation,
    MaterialStateProperty<EdgeInsetsGeometry> padding,
    MaterialStateProperty<Size> minimumSize,
    MaterialStateProperty<BorderSide> side,
    MaterialStateProperty<ShapeBorder> shape,
    VisualDensity visualDensity,
    MaterialTapTargetSize tapTargetSize,
  }) {
    return ButtonStyle(
      textStyle: textStyle ?? this.textStyle,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      foregroundColor: foregroundColor ?? this.foregroundColor,
      overlayColor: overlayColor ?? this.overlayColor,
      elevation: elevation ?? this.elevation,
      padding: padding ?? this.padding,
      minimumSize: minimumSize ?? this.minimumSize,
      side: side ?? this.side,
      shape: shape ?? this.shape,
      visualDensity: visualDensity ?? this.visualDensity,
      tapTargetSize: tapTargetSize ?? this.tapTargetSize,
    );
  }

  /// Returns a copy of this ButtonStyle where the non-null fields in [style]
  /// have replaced the corresponding fields in this ButtonStyle.
  ButtonStyle merge(ButtonStyle style) {
    if (style == null)
      return this;
    return copyWith(
      textStyle: style.textStyle ?? textStyle,
      backgroundColor: style.backgroundColor ?? backgroundColor,
      foregroundColor: style.foregroundColor ?? foregroundColor,
      overlayColor: style.overlayColor ?? overlayColor,
      elevation: style.elevation ?? elevation,
      padding: style.padding ?? padding,
      minimumSize: style.minimumSize ?? minimumSize,
      side: style.side ?? side,
      shape: style.shape ?? shape,
      visualDensity: style.visualDensity ?? visualDensity,
      tapTargetSize: style.tapTargetSize ?? tapTargetSize,
    );
  }

  @override
  int get hashCode {
    return hashValues(
      textStyle,
      backgroundColor,
      foregroundColor,
      overlayColor,
      elevation,
      padding,
      minimumSize,
      side,
      shape,
      visualDensity,
      tapTargetSize,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other))
      return true;
    if (other.runtimeType != runtimeType)
      return false;
    return other is ButtonStyle
        && other.textStyle == textStyle
        && other.backgroundColor == backgroundColor
        && other.foregroundColor == foregroundColor
        && other.overlayColor == overlayColor
        && other.elevation == elevation
        && other.padding == padding
        && other.minimumSize == minimumSize
        && other.side == side
        && other.shape == shape
        && other.visualDensity == visualDensity
        && other.tapTargetSize == tapTargetSize;
  }

  @override
  String toStringShort() {
    final List <String> overrides = <String>[
      if (textStyle != null) 'textStyle',
      if (backgroundColor != null) 'backgroundColor',
      if (foregroundColor != null) 'foregroundColor',
      if (overlayColor != null) 'overlayColor',
      if (elevation != null) 'elevation',
      if (padding != null) 'padding',
      if (minimumSize != null) 'minimumSize',
      if (side != null) 'side',
      if (shape != null) 'shape',
      if (visualDensity != null) 'visualDensity',
      if (tapTargetSize != null) 'tapTargetSize',
    ];
    final String overridesString = overrides.isEmpty
      ? 'no overrides'
      : 'overrides ${overrides.join(", ")}';

    return '${super.toStringShort()}($overridesString)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<MaterialStateProperty<TextStyle>>('textStyle', textStyle, defaultValue: null));
    properties.add(DiagnosticsProperty<MaterialStateProperty<Color>>('backgroundColor', backgroundColor, defaultValue: null));
    properties.add(DiagnosticsProperty<MaterialStateProperty<Color>>('foregroundColor', foregroundColor, defaultValue: null));
    properties.add(DiagnosticsProperty<MaterialStateProperty<Color>>('overlayColor', overlayColor, defaultValue: null));
    properties.add(DiagnosticsProperty<MaterialStateProperty<double>>('elevation', elevation, defaultValue: null));
    properties.add(DiagnosticsProperty<MaterialStateProperty<EdgeInsetsGeometry>>('padding', padding, defaultValue: null));
    properties.add(DiagnosticsProperty<MaterialStateProperty<Size>>('minimumSize', minimumSize, defaultValue: null));
    properties.add(DiagnosticsProperty<MaterialStateProperty<BorderSide>>('side', side, defaultValue: null));
    properties.add(DiagnosticsProperty<MaterialStateProperty<ShapeBorder>>('shape', shape, defaultValue: null));
    properties.add(DiagnosticsProperty<VisualDensity>('visualDensity', visualDensity, defaultValue: null));
    properties.add(EnumProperty<MaterialTapTargetSize>('tapTargetSize', tapTargetSize, defaultValue: null));
  }

  static ButtonStyle lerp(ButtonStyle a, ButtonStyle b, double t) {
    assert (t != null);
    if (a == null && b == null)
      return null;
    return ButtonStyle(
      textStyle: _lerpTextStyles(a?.textStyle, b?.textStyle, t),
      backgroundColor: _lerpColors(a?.backgroundColor, b?.backgroundColor, t),
      foregroundColor: _lerpColors(a?.foregroundColor, b?.foregroundColor, t),
      overlayColor: _lerpColors(a?.overlayColor, b?.overlayColor, t),
      elevation: _lerpDoubles(a?.elevation, b?.elevation, t),
      padding: _lerpInsets(a?.padding, b?.padding, t),
      minimumSize: _lerpSizes(a?.minimumSize, b?.minimumSize, t),
      side: _lerpSides(a?.side, b?.side, t),
      shape: _lerpShapes(a?.shape, b?.shape, t),
      visualDensity: t < 0.5 ? a.visualDensity : b.visualDensity,
      tapTargetSize: t < 0.5 ? a.tapTargetSize : b.tapTargetSize,
    );
  }

  static MaterialStateProperty<TextStyle> _lerpTextStyles(MaterialStateProperty<TextStyle> a, MaterialStateProperty<TextStyle> b, double t) {
    if (a == null && b == null)
      return null;
    return _LerpTextStyles(a, b, t);
  }

  static MaterialStateProperty<Color> _lerpColors(MaterialStateProperty<Color> a, MaterialStateProperty<Color> b, double t) {
    if (a == null && b == null)
      return null;
    return _LerpColors(a, b, t);
  }

  static MaterialStateProperty<double> _lerpDoubles(MaterialStateProperty<double> a, MaterialStateProperty<double> b, double t) {
    if (a == null && b == null)
      return null;
    return _LerpDoubles(a, b, t);
  }

  static MaterialStateProperty<EdgeInsetsGeometry> _lerpInsets(MaterialStateProperty<EdgeInsetsGeometry> a, MaterialStateProperty<EdgeInsetsGeometry> b, double t) {
    if (a == null && b == null)
      return null;
    return _LerpInsets(a, b, t);
  }

  static MaterialStateProperty<Size> _lerpSizes(MaterialStateProperty<Size> a, MaterialStateProperty<Size> b, double t) {
    if (a == null && b == null)
      return null;
    return _LerpSizes(a, b, t);
  }

  static MaterialStateProperty<BorderSide> _lerpSides(MaterialStateProperty<BorderSide> a, MaterialStateProperty<BorderSide> b, double t) {
    if (a == null && b == null)
      return null;
    return _LerpSides(a, b, t);
  }

  static MaterialStateProperty<ShapeBorder> _lerpShapes(MaterialStateProperty<ShapeBorder> a, MaterialStateProperty<ShapeBorder> b, double t) {
    if (a == null && b == null)
      return null;
    return _LerpShapes(a, b, t);
  }
}

class _LerpTextStyles implements MaterialStateProperty<TextStyle> {
  const _LerpTextStyles(this.a, this.b, this.t);

  final MaterialStateProperty<TextStyle> a;
  final MaterialStateProperty<TextStyle> b;
  final double t;

  @override
  TextStyle resolve(Set<MaterialState> states) {
    final TextStyle resolvedA = a?.resolve(states);
    final TextStyle resolvedB = b?.resolve(states);
    return TextStyle.lerp(resolvedA, resolvedB, t);
  }
}

class _LerpColors implements MaterialStateProperty<Color> {
  const _LerpColors(this.a, this.b, this.t);

  final MaterialStateProperty<Color> a;
  final MaterialStateProperty<Color> b;
  final double t;

  @override
  Color resolve(Set<MaterialState> states) {
    final Color resolvedA = a?.resolve(states);
    final Color resolvedB = b?.resolve(states);
    return Color.lerp(resolvedA, resolvedB, t);
  }
}

class _LerpDoubles implements MaterialStateProperty<double> {
  const _LerpDoubles(this.a, this.b, this.t);

  final MaterialStateProperty<double> a;
  final MaterialStateProperty<double> b;
  final double t;

  @override
  double resolve(Set<MaterialState> states) {
    final double resolvedA = a?.resolve(states);
    final double resolvedB = b?.resolve(states);
    return lerpDouble(resolvedA, resolvedB, t);
  }
}

class _LerpInsets implements MaterialStateProperty<EdgeInsetsGeometry> {
  const _LerpInsets(this.a, this.b, this.t);

  final MaterialStateProperty<EdgeInsetsGeometry> a;
  final MaterialStateProperty<EdgeInsetsGeometry> b;
  final double t;

  @override
  EdgeInsetsGeometry resolve(Set<MaterialState> states) {
    final EdgeInsetsGeometry resolvedA = a?.resolve(states);
    final EdgeInsetsGeometry resolvedB = b?.resolve(states);
    return EdgeInsetsGeometry.lerp(resolvedA, resolvedB, t);
  }
}

class _LerpSizes implements MaterialStateProperty<Size> {
  const _LerpSizes(this.a, this.b, this.t);

  final MaterialStateProperty<Size> a;
  final MaterialStateProperty<Size> b;
  final double t;

  @override
  Size resolve(Set<MaterialState> states) {
    final Size resolvedA = a?.resolve(states);
    final Size resolvedB = b?.resolve(states);
    return Size.lerp(resolvedA, resolvedB, t);
  }
}

class _LerpSides implements MaterialStateProperty<BorderSide> {
  const _LerpSides(this.a, this.b, this.t);

  final MaterialStateProperty<BorderSide> a;
  final MaterialStateProperty<BorderSide> b;
  final double t;

  @override
  BorderSide resolve(Set<MaterialState> states) {
    final BorderSide resolvedA = a?.resolve(states);
    final BorderSide resolvedB = b?.resolve(states);
    return BorderSide.lerp(resolvedA, resolvedB, t);
  }
}

class _LerpShapes implements MaterialStateProperty<ShapeBorder> {
  const _LerpShapes(this.a, this.b, this.t);

  final MaterialStateProperty<ShapeBorder> a;
  final MaterialStateProperty<ShapeBorder> b;
  final double t;

  @override
  ShapeBorder resolve(Set<MaterialState> states) {
    final ShapeBorder resolvedA = a?.resolve(states);
    final ShapeBorder resolvedB = b?.resolve(states);
    return ShapeBorder.lerp(resolvedA, resolvedB, t);
  }
}
