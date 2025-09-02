import 'package:flutter/material.dart';
import 'dart:math' as math;

/// カスタムローディングインジケーターを表示するウィジェット
///
/// 1秒ごとにアイコンを回転させて、処理中のアニメーションを表示します。
/// アプリケーションで非同期処理が行われているときに、ユーザーに
/// 視覚的に通知するために使用します。
class LoadingIndicator extends StatefulWidget {
  const LoadingIndicator({super.key});

  @override
  State<LoadingIndicator> createState() => _LoadingIndicatorState();
}

class _LoadingIndicatorState extends State<LoadingIndicator>
    with SingleTickerProviderStateMixin {
  /// アニメーションコントローラ
  ///
  /// `AnimationController`を使って1秒ごとにアイコンが回転するアニメーションを設定します。
  /// `vsync`には、`State`オブジェクト（つまり、このクラス）を指定します。
  /// `..repeat(reverse: false)`によってアニメーションを繰り返し行います
  late AnimationController controller = AnimationController(
    duration: const Duration(milliseconds: 1000),
    vsync: this,
  )..repeat(reverse: false);

  static const _kMovingRate = 0.4;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        // コントローラの値によって回転角度を設定
        // 0.4未満で時計回りに回転させることで、前半回転して、後半は停止させている
        return Transform.rotate(
          angle: controller.value < _kMovingRate
              ? -controller.value * (2 * math.pi) / _kMovingRate
              : 0,
          child: const Icon(Icons.cached_rounded, size: 32),
        );
      },
    );
  }
}
