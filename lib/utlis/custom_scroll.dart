


import 'dart:ui';

import 'package:flutter/material.dart';

class BouncingScrollBehaviorX extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }

  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const BouncingScrollPhysics();
  }
}

class BouncingScrollWrapperX extends StatelessWidget {
  final Widget child;
  final bool dragWithMouse;

  const BouncingScrollWrapperX({
    super.key,
    required this.child,
    this.dragWithMouse = false,
  });

  static Widget builder(
    BuildContext context,
    Widget child, {
    bool dragWithMouse = false,
  }) {
    return BouncingScrollWrapperX(dragWithMouse: dragWithMouse, child: child);
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: BouncingScrollBehaviorX().copyWith(
        overscroll: false,
        scrollbars: false,
        dragDevices: dragWithMouse
            ? {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
              }
            : null,
      ),
      child: child,
    );
  }
}

class ClampingScrollBehaviorX extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }

  // Set physics to clamping.
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const ClampingScrollPhysics();
  }
}

class ClampingScrollWrapperX extends StatelessWidget {
  final Widget child;
  final bool dragWithMouse;
  final bool? scrollBar;

  const ClampingScrollWrapperX({
    super.key,
    required this.child,
    this.dragWithMouse = false,
    this.scrollBar
  });

  static Widget builder(
    BuildContext context,
    Widget child, {
    bool dragWithMouse = false,
  }) {
    return ClampingScrollWrapperX(dragWithMouse: dragWithMouse, child: child);
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: ClampingScrollBehaviorX().copyWith(
        overscroll: false,
        scrollbars: scrollBar ?? false,
        dragDevices: dragWithMouse
            ? {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
              }
            : null,
      ),
      child: child,
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
