import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:touchfigure/app_constants.dart';

class FallingAction extends StatefulWidget {
  const FallingAction({super.key, required this.title});

  final String title;

  @override
  State<FallingAction> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<FallingAction> {
  List<double> _circlePositions = []; // 円の縦位置を管理するリスト
  List<double> _circleHorizontalPositions = []; // 円の横位置を管理するリスト
  List<int> _circleKeys = []; // 各円の識別子を管理するリスト
  List<Color> _circleColors = []; // 各円の色を管理するリスト
  List<bool> _isExploding = []; // 破裂アニメーションの状態を管理
  int _tapCount = 0; // タップ回数を管理
  int _buttonPressCount = 0; // 追加：ボタンを押した回数を管理
  Timer? _resetTimer; // タイマーを管理
  Timer? _buttonResetTimer; // 追加：ボタンカウント用のタイマー
  bool _showCount = false; // カウント表示の制御

  @override
  void dispose() {
    _resetTimer?.cancel();
    _buttonResetTimer?.cancel(); // 追加：タイマーの解放
    super.dispose();
  }

  void _incrementCounter() {
    setState(() {
      _buttonPressCount++;
      _circlePositions.add(-100.0);
      _circleHorizontalPositions.add(_getRandomHorizontalPosition());
      _circleKeys.add(DateTime.now().millisecondsSinceEpoch);
      _circleColors.add(_getRandomColor());
      _isExploding.add(false);
    });

    // 既存のタイマーをキャンセル
    _buttonResetTimer?.cancel();

    // 2秒後にボタンカウントをリセット
    _buttonResetTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _buttonPressCount = 0;
        });
      }
    });

    // 各円のアニメーションを開始
    Future.delayed(Duration.zero, () {
      setState(() {
        if (_circlePositions.isNotEmpty) {
          _circlePositions[_circlePositions.length - 1] =
              MediaQuery.of(context).size.height + 50.0;
        }
      });
    });
  }

  Color _getRandomColor() {
    return AppConstants.circleColors[Random().nextInt(
      AppConstants.circleColors.length,
    )];
  }

  double _getRandomHorizontalPosition() {
    final screenWidth = MediaQuery.of(context).size.width;
    return Random().nextDouble() * (screenWidth - 50); // 画面幅に基づいてランダムな位置を計算
  }

  void _handleTap(int index) {
    setState(() {
      _tapCount++;
      _showCount = true;
      _isExploding[index] = true;
    });

    // 既存のタイマーをキャンセル
    _resetTimer?.cancel();

    // 2秒後にカウントをリセット
    _resetTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _tapCount = 0;
          _showCount = false;
        });
      }
    });

    // 破裂アニメーション後に円を削除
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _circlePositions.removeAt(index);
          _circleHorizontalPositions.removeAt(index);
          _circleKeys.removeAt(index);
          _circleColors.removeAt(index);
          _isExploding.removeAt(index);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          if (_showCount)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.center,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 6.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  '$_tapCount',
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: Center(
        child: Stack(
          children: [
            if (_buttonPressCount > 0) // 修正：カウントが0より大きい時のみ表示
              Center(
                child: Text(
                  '$_buttonPressCount',
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ...List.generate(_circlePositions.length, (index) {
              return AnimatedPositioned(
                key: ValueKey(_circleKeys[index]),
                duration: const Duration(seconds: 3),
                top: _circlePositions[index],
                left: _circleHorizontalPositions[index],
                child: GestureDetector(
                  onTap: () => _handleTap(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: _isExploding[index] ? 100 : 50,
                    height: _isExploding[index] ? 100 : 50,
                    decoration: BoxDecoration(
                      color:
                          _isExploding[index]
                              ? _circleColors[index].withOpacity(0)
                              : _circleColors[index],
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              );
            }),
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
