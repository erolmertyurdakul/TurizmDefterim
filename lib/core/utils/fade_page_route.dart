import 'package:flutter/material.dart';

/// A premium, hardware-accelerated fade page transition that eliminates layout-shifting
/// and JIT compile jank during screen pushes and pops on all platforms (especially Flutter Web).
class FadePageRoute<T> extends PageRouteBuilder<T> {
  final Widget child;

  FadePageRoute({required this.child, super.settings})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionDuration: const Duration(milliseconds: 250),
          reverseTransitionDuration: const Duration(milliseconds: 200),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // A simple FadeTransition is extremely fast because it does not trigger repaints
            // or layout passes on transition frames, operating entirely on the GPU.
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );
}
