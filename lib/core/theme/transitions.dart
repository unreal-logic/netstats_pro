import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FadePageRoute<T> extends CustomTransitionPage<T> {
  FadePageRoute({
    required super.child,
    super.key,
  }) : super(
         transitionsBuilder: (context, animation, secondaryAnimation, child) =>
             FadeTransition(opacity: animation, child: child),
         transitionDuration: const Duration(milliseconds: 300),
       );
}
