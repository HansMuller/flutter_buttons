// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';

import 'button_style.dart';
import 'contained_button_theme.dart';
import 'text_button_theme.dart';
import 'outlined_button_theme.dart';


// Temporary proxy for TBD static MaterialStateProperty<T>.all(T value)
class MaterialStatePropertyAll<T> implements MaterialStateProperty<T> {
  const MaterialStatePropertyAll(this.value);

  final T value;

  @override
  T resolve(Set<MaterialState> states) => value;

  @override
  String toString() {
    return '$runtimeType($value)';
  }
}

// Temporary proxy for TBD ShapeBorder.withSide(BorderSide side)
shapeBorderWithSide(ShapeBorder shape, BorderSide side) {
  if (shape == null)
    return shape;
  if (shape is RoundedRectangleBorder) {
    return RoundedRectangleBorder(
      borderRadius: shape.borderRadius,
      side: side,
    );
  }
  if (shape is BeveledRectangleBorder) {
    return BeveledRectangleBorder(
      borderRadius: shape.borderRadius,
      side: side,
    );
  }
  if (shape is StadiumBorder) {
    return StadiumBorder(
      side: side,
    );
  }
  if (shape is CircleBorder) {
    return CircleBorder(
      side: side,
    );
  }
  if (shape is ContinuousRectangleBorder) {
    return ContinuousRectangleBorder(
      borderRadius: shape.borderRadius,
      side: side,
    );
  }
  if (shape is CircleBorder) {
    return CircleBorder(
      side: side,
    );
  }
  return shape;
}

abstract class _ButtonStyleButton extends StatefulWidget {
  const _ButtonStyleButton({
    Key key,
    @required this.onPressed,
    @required this.onLongPress,
    @required this.style,
    @required this.focusNode,
    @required this.autofocus,
    @required this.clipBehavior,
    @required this.enableFeedback,
    @required this.animationDuration,
    @required this.child,
  }) : assert(autofocus != null),
       assert(clipBehavior != null),
       assert(enableFeedback != null),
       assert(animationDuration != null),
       super(key: key);

  final VoidCallback onPressed;
  final VoidCallback onLongPress;
  final ButtonStyle style;
  final Clip clipBehavior;
  final FocusNode focusNode;
  final bool autofocus;
  final bool enableFeedback;
  final Duration animationDuration;
  final Widget child;

  // Returns a ButtonStyle that's based on the Theme's
  // textTheme and colorScheme. Concrete button subclasses must
  // resolve the button's actual visual parameters by combining this
  // style with the widget's style and the button theme's style.
  //
  // Defined here rather than in the State subclass to ensure that
  // the default style can only depend on the BuildContext.
  ButtonStyle _defaultStyleOf(BuildContext context);

  /// Whether the button is enabled or disabled.
  ///
  /// Buttons are disabled by default. To enable a button, set its [onPressed]
  /// or [onLongPress] properties to a non-null value.
  bool get enabled => onPressed != null || onLongPress != null;
}

abstract class _ButtonStyleState<T extends _ButtonStyleButton> extends State<T> {
  final Set<MaterialState> _states = <MaterialState>{};

  bool get _hovered => _states.contains(MaterialState.hovered);
  bool get _focused => _states.contains(MaterialState.focused);
  bool get _pressed => _states.contains(MaterialState.pressed);
  bool get _disabled => _states.contains(MaterialState.disabled);

  void _updateState(MaterialState state, bool value) {
    value ? _states.add(state) : _states.remove(state);
  }

  void _handleHighlightChanged(bool value) {
    if (_pressed != value) {
      setState(() {
        _updateState(MaterialState.pressed, value);
      });
    }
  }

  void _handleHoveredChanged(bool value) {
    if (_hovered != value) {
      setState(() {
        _updateState(MaterialState.hovered, value);
      });
    }
  }

  void _handleFocusedChanged(bool value) {
    if (_focused != value) {
      setState(() {
        _updateState(MaterialState.focused, value);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _updateState(MaterialState.disabled, !widget.enabled);
  }

  @override
  void didUpdateWidget(T oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateState(MaterialState.disabled, !widget.enabled);
    // If the button is disabled while a press gesture is currently ongoing,
    // InkWell makes a call to handleHighlightChanged. This causes an exception
    // because it calls setState in the middle of a build. To preempt this, we
    // manually update pressed to false when this situation occurs.
    if (_disabled && _pressed) {
      _handleHighlightChanged(false);
    }
  }

  T _resolve<T>(
    MaterialStateProperty<T> widgetValue,
    MaterialStateProperty<T> themeValue,
    MaterialStateProperty<T> defaultValue)
  {
    assert(defaultValue != null);
    return widgetValue?.resolve(_states) ?? themeValue?.resolve(_states) ?? defaultValue.resolve(_states);
  }

  ButtonStyle themeStyleFor(BuildContext context);

  @override
  Widget build(BuildContext context) {
    final ButtonStyle widgetStyle = widget.style;
    final ButtonStyle themeStyle = themeStyleFor(context);
    final ButtonStyle defaultStyle = widget._defaultStyleOf(context);

    final TextStyle resolvedTextStyle = _resolve<TextStyle>(
      widgetStyle?.textStyle, themeStyle?.textStyle, defaultStyle.textStyle,
    );
    final Color resolvedBackgroundColor = _resolve<Color>(
      widgetStyle?.backgroundColor, themeStyle?.backgroundColor, defaultStyle.backgroundColor,
    );
    final Color resolvedForegroundColor = _resolve<Color>(
      widgetStyle?.foregroundColor, themeStyle?.foregroundColor, defaultStyle.foregroundColor,
    );
    final double resolvedElevation = _resolve<double>(
      widgetStyle?.elevation, themeStyle?.elevation, defaultStyle.elevation,
    );
    final EdgeInsetsGeometry resolvedPadding = _resolve<EdgeInsetsGeometry>(
      widgetStyle?.padding, themeStyle?.padding, defaultStyle.padding,
    );
    final Size resolvedMinimumSize = _resolve<Size>(
      widgetStyle?.minimumSize, themeStyle?.minimumSize, defaultStyle.minimumSize,

    );
    final BorderSide resolvedSide = _resolve<BorderSide>(
      widgetStyle?.side, themeStyle?.side, defaultStyle.side,
    );
    final ShapeBorder resolvedShape = _resolve<ShapeBorder>(
      widgetStyle?.shape, themeStyle?.shape, defaultStyle.shape,
    );

    // TODO(hansmuller): add support for overlayColor to InkWell
    Color resolveOverlayColor(MaterialState state) {
      final Set<MaterialState> states = <MaterialState>{ state };
      return widgetStyle?.overlayColor?.resolve(states)
          ?? themeStyle?.overlayColor?.resolve(states)
          ?? defaultStyle.overlayColor.resolve(states);
    }
    final Color pressedColor = resolveOverlayColor(MaterialState.pressed);
    final Color hoveredColor = resolveOverlayColor(MaterialState.hovered);
    final Color focusedColor = resolveOverlayColor(MaterialState.focused);

    final VisualDensity resolvedVisualDensity = widgetStyle?.visualDensity ?? defaultStyle.visualDensity;
    final MaterialTapTargetSize resolvedTapTargetSize =  widgetStyle?.tapTargetSize ?? defaultStyle.tapTargetSize;

    final Offset densityAdjustment = resolvedVisualDensity.baseSizeAdjustment;
    final BoxConstraints effectiveConstraints = resolvedVisualDensity.effectiveConstraints(
      BoxConstraints(
        minWidth: resolvedMinimumSize.width,
        minHeight: resolvedMinimumSize.height,
      ),
    );
    final EdgeInsetsGeometry padding = resolvedPadding.add(
      EdgeInsets.only(
        left: densityAdjustment.dx,
        top: densityAdjustment.dy,
        right: densityAdjustment.dx,
        bottom: densityAdjustment.dy,
      ),
    ).clamp(EdgeInsets.zero, EdgeInsetsGeometry.infinity);

    final Widget result = ConstrainedBox(
      constraints: effectiveConstraints,
      child: Material(
        elevation: resolvedElevation,
        textStyle: resolvedTextStyle?.copyWith(color: resolvedForegroundColor),
        shape: shapeBorderWithSide(resolvedShape, resolvedSide), // resolvedShape?.withSide(resolvedSide)
        color: resolvedBackgroundColor,
        type: resolvedBackgroundColor == null ? MaterialType.transparency : MaterialType.button,
        animationDuration: widget.animationDuration,
        clipBehavior: widget.clipBehavior,
        child: InkWell(
          onTap: widget.onPressed,
          onLongPress: widget.onLongPress,
          onHighlightChanged: _handleHighlightChanged,
          onHover: _handleHoveredChanged,
          enableFeedback: widget.enableFeedback,
          focusNode: widget.focusNode,
          canRequestFocus: widget.enabled,
          onFocusChange: _handleFocusedChanged,
          autofocus: widget.autofocus,

          splashFactory: InkRipple.splashFactory, // TODO put this in ButtonStyle
          highlightColor: Colors.transparent,
          splashColor: pressedColor,
          focusColor: focusedColor,
          hoverColor: hoveredColor,

          customBorder: resolvedShape,
          child: IconTheme.merge(
            data: IconThemeData(color: resolvedForegroundColor),
            child: Padding(
              padding: padding,
              child: Center(
                widthFactor: 1.0,
                heightFactor: 1.0,
                child: widget.child,
              ),
            ),
          ),
        ),
      ),
    );

    Size minSize;
    switch (resolvedTapTargetSize) {
      case MaterialTapTargetSize.padded:
        minSize = Size(
          kMinInteractiveDimension + densityAdjustment.dx,
          kMinInteractiveDimension + densityAdjustment.dy,
        );
        assert(minSize.width >= 0.0);
        assert(minSize.height >= 0.0);
        break;
      case MaterialTapTargetSize.shrinkWrap:
        minSize = Size.zero;
        break;
    }

    return Semantics(
      container: true,
      button: true,
      enabled: widget.enabled,
      child: _InputPadding(
        minSize: minSize,
        child: result,
      ),
    );
  }
}

/// A material design "Text Button".
///
/// A text button is a text label displayed on a (zero elevation) [Material]
/// widget that reacts to touches by filling with color.
///
/// Use text buttons on toolbars, in dialogs, or inline with other content but
/// offset from that content with padding so that the button's presence is
/// obvious. Text buttons intentionally do not have visible borders and must
/// therefore rely on their position relative to other content for context. In
/// dialogs and cards, they should be grouped together in one of the bottom
/// corners. Avoid using text buttons where they would blend in with other
/// content, for example in the middle of lists.
///
/// Material design text buttons have an all-caps label, some internal padding,
/// and some defined dimensions. To have a part of your application be
/// interactive, with ink splashes, without also committing to these stylistic
/// choices, consider using [InkWell] instead.
///
/// If the [onPressed] and [onLongPress] callbacks are null, then this button will be disabled,
/// will not react to touch, and will be colored as specified by
/// the [disabledColor] property instead of the [color] property. If you are
/// trying to change the button's [color] and it is not having any effect, check
/// that you are passing a non-null [onPressed] handler.
///
/// Text buttons have a minimum size of 88.0 by 36.0 which can be overridden
/// with [ButtonTheme].
///
/// The [clipBehavior] argument must not be null.
///
/// {@tool snippet}
///
/// This example shows a simple [TextButton].
///
/// ![A simple TextButton](https://flutter.github.io/assets-for-api-docs/assets/material/text_button.png)
///
/// ```dart
/// TextButton(
///   onPressed: () {
///     /*...*/
///   },
///   child: Text(
///     "Text Button",
///   ),
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [ContainedButton], a filled button whose material elevates when pressed.
///  * [DropdownButton], which offers the user a choice of a number of options.
///  * [SimpleDialogOption], which is used in [SimpleDialog]s.
///  * [IconButton], to create buttons that just contain icons.
///  * [InkWell], which implements the ink splash part of a text button.
///  * <https://material.io/design/components/buttons.html>
class TextButton extends _ButtonStyleButton {
  /// Create a TextButton.
  ///
  /// The [autofocus] and [clipBehavior] arguments must not be null.
  const TextButton({
    Key key,
    @required VoidCallback onPressed,
    VoidCallback onLongPress,
    ButtonStyle style,
    FocusNode focusNode,
    bool autofocus = false,
    Clip clipBehavior = Clip.none,
    bool enableFeedback = true,
    Duration animationDuration = kThemeChangeDuration,
    @required Widget child,
  }) : super(
    key: key,
    onPressed: onPressed,
    onLongPress: onLongPress,
    style: style,
    focusNode: focusNode,
    autofocus: autofocus,
    clipBehavior: clipBehavior,
    enableFeedback: enableFeedback,
    animationDuration: animationDuration,
    child: child,
  );

  factory TextButton.icon({
    Key key,
    @required VoidCallback onPressed,
    VoidCallback onLongPress,
    ButtonStyle style,
    FocusNode focusNode,
    bool autofocus = false,
    Clip clipBehavior = Clip.none,
    bool enableFeedback = true,
    Duration animationDuration = kThemeChangeDuration,
    @required Widget icon,
    @required Widget label,
  }) {
    assert(icon != null);
    assert(label != null);
    return TextButton(
      key: key,
      onPressed: onPressed,
      onLongPress: onLongPress,
      style: style,
      focusNode: focusNode,
      autofocus: autofocus,
      clipBehavior: clipBehavior,
      enableFeedback: enableFeedback,
      animationDuration: animationDuration,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          icon,
          const SizedBox(width: 8.0),
          label,
        ],
      ),
    );
  }

  @override
  _TextButtonState createState() => _TextButtonState();

  static ButtonStyle styleFrom({
    Color primary,
    Color onSurface,
    Color backgroundColor,
    TextStyle textStyle,
    double elevation,
    EdgeInsetsGeometry padding,
    Size minimumSize,
    BorderSide side,
    ShapeBorder shape,
    VisualDensity visualDensity,
    MaterialTapTargetSize tapTargetSize,
  }) {
    final MaterialStateProperty<Color> foregroundColor = (onSurface == null && primary == null)
      ? null
      : MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.disabled))
              return onSurface?.withOpacity(0.38);
            return primary;
          },
        );
    final MaterialStateProperty<Color> overlayColor = (primary == null)
      ? null
      : MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.hovered))
              return primary?.withOpacity(0.04);
            if (states.contains(MaterialState.focused) || states.contains(MaterialState.pressed))
              return primary?.withOpacity(0.12);
            return null;
          }
        );
    return ButtonStyle(
      textStyle: MaterialStatePropertyAll<TextStyle>(textStyle),
      foregroundColor: foregroundColor,
      backgroundColor: MaterialStatePropertyAll<Color>(backgroundColor),
      overlayColor: overlayColor,
      elevation: MaterialStatePropertyAll<double>(elevation),
      padding: MaterialStatePropertyAll<EdgeInsetsGeometry>(padding),
      minimumSize: MaterialStatePropertyAll<Size>(minimumSize),
      side: MaterialStatePropertyAll<BorderSide>(side),
      shape: MaterialStatePropertyAll<ShapeBorder>(shape),
      visualDensity: visualDensity,
      tapTargetSize: tapTargetSize,
    );
  }

  @override
  ButtonStyle _defaultStyleOf(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return styleFrom(
      primary: colorScheme.primary,
      onSurface: colorScheme.onSurface,
      backgroundColor: Colors.transparent,
      textStyle: theme.textTheme.button,
      elevation: 0,
      padding: EdgeInsets.all(8),
      minimumSize: Size(0, 36),
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
      visualDensity: theme.visualDensity,
      tapTargetSize: theme.materialTapTargetSize,
    );
  }
}


class _TextButtonState extends _ButtonStyleState<TextButton> {
  @override
  ButtonStyle themeStyleFor(BuildContext context) {
    return TextButtonTheme.of(context)?.style;
  }
}


/// A material design "contained button".
///
/// A contained button is based on a [Material] widget whose [Material.elevation]
/// increases when the button is pressed.
///
/// Use contained buttons to add dimension to otherwise mostly flat layouts, e.g.
/// in long busy lists of content, or in wide spaces. Avoid using contained buttons
/// on already-contained content such as dialogs or cards.
///
/// If [onPressed] and [onLongPress] callbacks are null, then the button will be disabled and by
/// default will resemble a flat button in the [disabledColor]. If you are
/// trying to change the button's [color] and it is not having any effect, check
/// that you are passing a non-null [onPressed] or [onLongPress] callbacks.
///
/// If you want an ink-splash effect for taps, but don't want to use a button,
/// consider using [InkWell] directly.
///
/// Contained buttons have a minimum size of 88.0 by 36.0 which can be overridden
/// with [ButtonTheme].
///
/// {@tool dartpad --template=stateless_widget_scaffold}
///
/// This sample shows how to render a disabled ContainedButton, an enabled ContainedButton
/// and lastly a ContainedButton with gradient background.
///
/// ![Three contained buttons, one enabled, another disabled, and the last one
/// styled with a blue gradient background](https://flutter.github.io/assets-for-api-docs/assets/material/contained_button.png)
///
/// ```dart
/// Widget build(BuildContext context) {
///   return Center(
///     child: Column(
///       mainAxisSize: MainAxisSize.min,
///       children: <Widget>[
///         const ContainedButton(
///           onPressed: null,
///           style: ContainedButton.styleFrom(
///             textStyle: TextStyle(fontSize: 20),
///           ),
///           child: Text('Disabled Button'),
///         ),
///         const SizedBox(height: 30),
///         const ContainedButton(
///           onPressed: () {},
///           style: ContainedButton.styleFrom(
///             textStyle: TextStyle(fontSize: 20),
///           ),
///           child: Text('Enabled Button'),
///         ),
///         const SizedBox(height: 30),
///         ContainedButton(
///           onPressed: () {},
///           style: ContainedButton.styleFrom(
///             textStyle: TextStyle(fontSize: 20),
///             textColor: Colors.white,
///             const EdgeInsets.all(0.0),
///           ),
///           child: Container(
///             decoration: const BoxDecoration(
///               gradient: LinearGradient(
///                 colors: <Color>[
///                   Color(0xFF0D47A1),
///                   Color(0xFF1976D2),
///                   Color(0xFF42A5F5),
///                 ],
///               ),
///             ),
///             padding: const EdgeInsets.all(10.0),
///             child: const Text('Gradient Button'),
///           ),
///         ),
///       ],
///     ),
///   );
/// }
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [TextButton], a material design button without a shadow.
///  * [DropdownButton], a button that shows options to select from.
///  * [FloatingActionButton], the round button in material applications.
///  * [IconButton], to create buttons that just contain icons.
///  * [InkWell], which implements the ink splash part of a flat button.
///  * <https://material.io/design/components/buttons.html>
class ContainedButton extends _ButtonStyleButton {
  /// Create a ContainedButton.
  ///
  /// The [autofocus] and [clipBehavior] arguments must not be null.
  const ContainedButton({
    Key key,
    @required VoidCallback onPressed,
    VoidCallback onLongPress,
    ButtonStyle style,
    FocusNode focusNode,
    bool autofocus = false,
    Clip clipBehavior = Clip.none,
    bool enableFeedback = true,
    Duration animationDuration = kThemeChangeDuration,
    @required Widget child,
  }) : super(
    key: key,
    onPressed: onPressed,
    onLongPress: onLongPress,
    style: style,
    focusNode: focusNode,
    autofocus: autofocus,
    clipBehavior: clipBehavior,
    enableFeedback: enableFeedback,
    animationDuration: animationDuration,
    child: child,
  );

  factory ContainedButton.icon({
    Key key,
    @required VoidCallback onPressed,
    VoidCallback onLongPress,
    ButtonStyle style,
    FocusNode focusNode,
    bool autofocus = false,
    Clip clipBehavior = Clip.none,
    bool enableFeedback = true,
    Duration animationDuration = kThemeChangeDuration,
    @required Widget icon,
    @required Widget label,
  }) {
    assert(icon != null);
    assert(label != null);
    const ButtonStyle paddingStyle = ButtonStyle(
      padding: MaterialStatePropertyAll<EdgeInsets>(EdgeInsets.only(left: 12, right: 16)),
    );
    return ContainedButton(
      key: key,
      onPressed: onPressed,
      onLongPress: onLongPress,
      style: style == null ? paddingStyle : style.merge(paddingStyle),
      focusNode: focusNode,
      autofocus: autofocus,
      clipBehavior: clipBehavior,
      enableFeedback: enableFeedback,
      animationDuration: animationDuration,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          icon,
          const SizedBox(width: 8.0),
          label,
        ],
      ),
    );
  }

  @override
  _ContainedButtonState createState() => _ContainedButtonState();

  static ButtonStyle styleFrom({
    Color primary,
    Color onPrimary,
    Color onSurface,
    double elevation,
    TextStyle textStyle,
    EdgeInsetsGeometry padding,
    Size minimumSize,
    BorderSide side,
    ShapeBorder shape,
    VisualDensity visualDensity,
    MaterialTapTargetSize tapTargetSize,
  }) {
    final MaterialStateProperty<Color> backgroundColor = (onSurface == null && primary == null)
      ? null
      : MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.disabled))
              return onSurface?.withOpacity(0.12);
            return primary;
          }
        );
    final MaterialStateProperty<Color> foregroundColor = (onSurface == null && onPrimary == null)
      ? null
      : MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.disabled))
              return onSurface?.withOpacity(0.38);
            return onPrimary;
          }
        );
    final MaterialStateProperty<Color> overlayColor = (onPrimary == null)
      ? null
      : MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.hovered))
              return onPrimary?.withOpacity(0.08);
            if (states.contains(MaterialState.focused) || states.contains(MaterialState.pressed))
              return onPrimary?.withOpacity(0.24);
            return null;
          }
        );
    final MaterialStateProperty<double> elevationValue = (elevation == null)
      ? null
      : MaterialStateProperty.resolveWith<double>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.disabled)) return 0;
            if (states.contains(MaterialState.hovered)) return elevation + 2;
            if (states.contains(MaterialState.focused)) return elevation + 2;
            if (states.contains(MaterialState.pressed)) return elevation + 6;
            return elevation;
          }
        );
    return ButtonStyle(
      textStyle: MaterialStatePropertyAll<TextStyle>(textStyle),
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      overlayColor: overlayColor,
      elevation: elevationValue,
      padding: MaterialStatePropertyAll<EdgeInsetsGeometry>(padding),
      minimumSize: MaterialStatePropertyAll<Size>(minimumSize),
      side: MaterialStatePropertyAll<BorderSide>(side),
      shape: MaterialStatePropertyAll<ShapeBorder>(shape),
      visualDensity: visualDensity,
      tapTargetSize: tapTargetSize,
    );
  }

  @override
  ButtonStyle _defaultStyleOf(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return styleFrom(
      primary: colorScheme.primary,
      onPrimary: colorScheme.onPrimary,
      onSurface: colorScheme.onSurface,
      elevation: 2,
      textStyle: theme.textTheme.button,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      minimumSize: const Size(64, 36),
      side: BorderSide.none,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
      visualDensity: theme.visualDensity,
      tapTargetSize: theme.materialTapTargetSize,
    );
  }
}

class _ContainedButtonState extends _ButtonStyleState<ContainedButton> {
  @override
  ButtonStyle themeStyleFor(BuildContext context) {
    return ContainedButtonTheme.of(context)?.style;
  }
}

/// Essentially a [TextButton] with a thin grey rounded rectangle border.
///
/// If the [onPressed] or [onLongPress] callbacks are null, then the button will be disabled and by
/// default will resemble a flat button in the [disabledColor].
///
/// If you want an ink-splash effect for taps, but don't want to use a button,
/// consider using [InkWell] directly.
///
/// See also:
///
///  * [ContainedButton], a filled material design button with a shadow.
///  * [TextButton], a material design button without a shadow.
///  * [DropdownButton], a button that shows options to select from.
///  * [FloatingActionButton], the round button in material applications.
///  * [IconButton], to create buttons that just contain icons.
///  * [InkWell], which implements the ink splash part of a flat button.
///  * <https://material.io/design/components/buttons.html>
class OutlinedButton extends _ButtonStyleButton {
  /// Create an OutlinedButton.
  ///
  /// The [autofocus] and [clipBehavior] arguments must not be null.
  const OutlinedButton({
    Key key,
    @required VoidCallback onPressed,
    VoidCallback onLongPress,
    ButtonStyle style,
    FocusNode focusNode,
    bool autofocus = false,
    Clip clipBehavior = Clip.none,
    bool enableFeedback = true,
    Duration animationDuration = kThemeChangeDuration,
    @required Widget child,
  }) : super(
    key: key,
    onPressed: onPressed,
    onLongPress: onLongPress,
    style: style,
    focusNode: focusNode,
    autofocus: autofocus,
    clipBehavior: clipBehavior,
    enableFeedback: enableFeedback,
    animationDuration: animationDuration,
    child: child,
  );

  factory OutlinedButton.icon({
    Key key,
    @required VoidCallback onPressed,
    VoidCallback onLongPress,
    ButtonStyle style,
    FocusNode focusNode,
    bool autofocus = false,
    Clip clipBehavior = Clip.none,
    bool enableFeedback = true,
    Duration animationDuration = kThemeChangeDuration,
    @required Widget icon,
    @required Widget label,
  }) {
    assert(icon != null);
    assert(label != null);
    const ButtonStyle paddingStyle = ButtonStyle(
      padding: MaterialStatePropertyAll<EdgeInsets>(EdgeInsets.only(left: 12, right: 16)),
    );
    return OutlinedButton(
      key: key,
      onPressed: onPressed,
      onLongPress: onLongPress,
      style: style == null ? paddingStyle : style.merge(paddingStyle),
      focusNode: focusNode,
      autofocus: autofocus,
      clipBehavior: clipBehavior,
      enableFeedback: enableFeedback,
      animationDuration: animationDuration,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          icon,
          const SizedBox(width: 8.0),
          label,
        ],
      ),
    );
  }

  @override
  _OutlinedButtonState createState() => _OutlinedButtonState();

  static ButtonStyle styleFrom({
    Color primary,
    Color onSurface,
    Color backgroundColor,
    TextStyle textStyle,
    double elevation,
    EdgeInsetsGeometry padding,
    Size minimumSize,
    BorderSide side,
    ShapeBorder shape,
    VisualDensity visualDensity,
    MaterialTapTargetSize tapTargetSize,
  }) {
    final MaterialStateProperty<Color> foregroundColor = (onSurface == null && primary == null)
      ? null
      : MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.disabled))
              return onSurface?.withOpacity(0.38);
            return primary;
          },
        );
    final MaterialStateProperty<Color> overlayColor = (primary == null)
      ? null
      : MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.hovered))
              return primary?.withOpacity(0.04);
            if (states.contains(MaterialState.focused) || states.contains(MaterialState.pressed))
              return primary?.withOpacity(0.12);
            return null;
          }
        );
    return ButtonStyle(
      textStyle: MaterialStatePropertyAll<TextStyle>(textStyle),
      foregroundColor: foregroundColor,
      backgroundColor: MaterialStatePropertyAll<Color>(backgroundColor),
      overlayColor: overlayColor,
      elevation: MaterialStatePropertyAll<double>(elevation),
      padding: MaterialStatePropertyAll<EdgeInsetsGeometry>(padding),
      minimumSize: MaterialStatePropertyAll<Size>(minimumSize),
      side: MaterialStatePropertyAll<BorderSide>(side),
      shape: MaterialStatePropertyAll<ShapeBorder>(shape),
      visualDensity: visualDensity,
      tapTargetSize: tapTargetSize,
    );
  }

  @override
  ButtonStyle _defaultStyleOf(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return styleFrom(
      primary: colorScheme.primary,
      onSurface: colorScheme.onSurface,
      backgroundColor: Colors.transparent,
      textStyle: theme.textTheme.button,
      elevation: 0,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      minimumSize: Size(64, 36),
      side: BorderSide(
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.12),
        width: 1,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      visualDensity: theme.visualDensity,
      tapTargetSize: theme.materialTapTargetSize,
    );
  }
}

class _OutlinedButtonState extends _ButtonStyleState<OutlinedButton> {
  @override
  ButtonStyle themeStyleFor(BuildContext context) {
    return OutlinedButtonTheme.of(context)?.style;
  }
}

/// A widget to pad the area around a [MaterialButton]'s inner [Material].
///
/// Redirect taps that occur in the padded area around the child to the center
/// of the child. This increases the size of the button and the button's
/// "tap target", but not its material or its ink splashes.
class _InputPadding extends SingleChildRenderObjectWidget {
  const _InputPadding({
    Key key,
    Widget child,
    this.minSize,
  }) : super(key: key, child: child);

  final Size minSize;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderInputPadding(minSize);
  }

  @override
  void updateRenderObject(BuildContext context, covariant _RenderInputPadding renderObject) {
    renderObject.minSize = minSize;
  }
}

class _RenderInputPadding extends RenderShiftedBox {
  _RenderInputPadding(this._minSize, [RenderBox child]) : super(child);

  Size get minSize => _minSize;
  Size _minSize;
  set minSize(Size value) {
    if (_minSize == value)
      return;
    _minSize = value;
    markNeedsLayout();
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    if (child != null)
      return math.max(child.getMinIntrinsicWidth(height), minSize.width);
    return 0.0;
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    if (child != null)
      return math.max(child.getMinIntrinsicHeight(width), minSize.height);
    return 0.0;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    if (child != null)
      return math.max(child.getMaxIntrinsicWidth(height), minSize.width);
    return 0.0;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    if (child != null)
      return math.max(child.getMaxIntrinsicHeight(width), minSize.height);
    return 0.0;
  }

  @override
  void performLayout() {
    final BoxConstraints constraints = this.constraints;
    if (child != null) {
      child.layout(constraints, parentUsesSize: true);
      final double height = math.max(child.size.width, minSize.width);
      final double width = math.max(child.size.height, minSize.height);
      size = constraints.constrain(Size(height, width));
      final BoxParentData childParentData = child.parentData as BoxParentData;
      childParentData.offset = Alignment.center.alongOffset(size - child.size as Offset);
    } else {
      size = Size.zero;
    }
  }

  @override
  bool hitTest(BoxHitTestResult result, { Offset position }) {
    if (super.hitTest(result, position: position)) {
      return true;
    }
    final Offset center = child.size.center(Offset.zero);
    return result.addWithRawTransform(
      transform: MatrixUtils.forceToPoint(center),
      position: center,
      hitTest: (BoxHitTestResult result, Offset position) {
        assert(position == center);
        return child.hitTest(result, position: center);
      },
    );
  }
}
