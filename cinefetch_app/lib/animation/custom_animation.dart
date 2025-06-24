import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

enum AnimationType { fastFade,fade, fadeSlide, bounce, swing }

class CustomAnimation extends StatelessWidget {
  final double delay;
  final Widget child;
  final AnimationType type;

  const CustomAnimation(
    this.delay,
    this.child, {
    super.key,
    this.type = AnimationType.fade,
  });

  @override
  Widget build(BuildContext context) {
    final tween = MovieTween();

    switch (type) {
      case AnimationType.fastFade:
        tween.tween(
          'opacity',
          Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 500),
        );
        break;
      case AnimationType.fade:
        tween.tween(
          'opacity',
          Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 500),
        );
        break;
      case AnimationType.fadeSlide:
        tween
          ..tween(
            'opacity',
            Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 500),
          )
          ..tween(
            'translateY',
            Tween(begin: 30.0, end: 0.0),
            duration: const Duration(milliseconds: 500),
          );
        break;
      case AnimationType.bounce:
        tween
          ..tween(
            'opacity',
            Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 400),
          )
          ..tween(
            'translateY',
            Tween(begin: 60.0, end: 0.0),
            duration: const Duration(milliseconds: 700),
            curve: Curves.bounceOut,
          );
        break;
      case AnimationType.swing:
        tween
          ..tween(
            'opacity',
            Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 400),
          )
          ..tween(
            'angle',
            Tween(begin: -0.3, end: 0.0),
            duration: const Duration(milliseconds: 700),
            curve: Curves.elasticOut,
          );
        break;
    }

    return PlayAnimationBuilder<Movie>(
      tween: tween,
      duration: tween.duration + Duration(milliseconds: (500 * delay).round()),
      delay: Duration(milliseconds: (500 * delay).round()),
      builder: (context, value, child) {
        Widget animatedChild = child!;
        if (type == AnimationType.fade) {
          animatedChild = Opacity(opacity: value.get('opacity'), child: child);
        } else if (type == AnimationType.fadeSlide ||
            type == AnimationType.bounce) {
          animatedChild = Opacity(
            opacity: value.get('opacity'),
            child: Transform.translate(
              offset: Offset(0, value.get('translateY')),
              child: child,
            ),
          );
        } else if (type == AnimationType.swing) {
          animatedChild = Opacity(
            opacity: value.get('opacity'),
            child: Transform.rotate(angle: value.get('angle'), child: child),
          );
        }
        return animatedChild;
      },
      child: child,
    );
  }
}