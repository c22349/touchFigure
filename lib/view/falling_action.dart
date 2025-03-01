import 'package:flutter/material.dart';
import 'package:touchfigure/app_constants.dart';

class FallingAction extends StatefulWidget {
  const FallingAction({super.key, required this.title});

  final String title;

  @override
  State<FallingAction> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<FallingAction> {
  double _circlePosition = -100.0; // 初期位置を設定
  bool _isAnimating = false; // アニメーション中かどうかを示すフラグ

  void _incrementCounter() {
    if (_isAnimating) return; // アニメーション中は何もしない

    setState(() {
      _isAnimating = true; // アニメーション開始
      double screenHeight = MediaQuery.of(context).size.height;
      _circlePosition = screenHeight + 50.0; // 画面の下まで突き抜ける
    });

    // アニメーションが終了した後に初期位置に戻す
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isAnimating = false; // アニメーション終了
      });
      // アニメーション終了後に位置をリセット
      _circlePosition = -100.0; // 初期位置に戻す
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(seconds: 1),
              top: _circlePosition,
              left: MediaQuery.of(context).size.width / 2 - 25, // 中央に配置
              child: Visibility(
                visible: _isAnimating, // アニメーション中のみ表示
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppConstants.circleColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
