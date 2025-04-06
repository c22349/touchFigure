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
  List<double> _circleSizes = []; // 円のサイズを管理するリスト
  int _tapCount = 0; // タップ回数を管理
  int _buttonPressCount = 0; // ボタンを押した回数を管理
  Timer? _resetTimer; // タイマーを管理
  Timer? _buttonResetTimer; // ボタンカウント用のタイマー
  bool _showCount = false; // カウント表示の制御
  String? _countdownText; // カウントダウンテキストを管理

  @override
  void dispose() {
    _resetTimer?.cancel();
    _buttonResetTimer?.cancel();
    super.dispose();
  }

  void _startButtonPress() {
    setState(() {
      _buttonPressCount++;
    });
  }

  void _endButtonPress() {
    // 既存のタイマーをキャンセル
    _buttonResetTimer?.cancel();

    // 1秒後にカウントダウン開始
    _buttonResetTimer = Timer(AppConstants.countdownDelay, () {
      if (!mounted) return;

      final count = _buttonPressCount;
      setState(() {
        _buttonPressCount = 0;
      });

      // カウントダウン開始
      _startCountdown(count);
    });
  }

  void _startCountdown(int circleCount) {
    int count = 3;

    // 3秒間のカウントダウン
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      setState(() {
        _countdownText = count.toString();
      });

      count--;

      if (count < 0) {
        timer.cancel();
        setState(() {
          _countdownText = 'START!';
        });

        // START!表示後、円を生成
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            setState(() {
              _countdownText = null;
            });
            // 円を順番に生成
            for (int i = 0; i < circleCount; i++) {
              Future.delayed(Duration(milliseconds: i * 100), () {
                if (mounted) _addCircle();
              });
            }
          }
        });
      }
    });
  }

  void _addCircle() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // 最初の位置を画面上部に設定
    final initialPosition = -50.0; // 画面上部から少し上に配置
    final finalPosition = screenHeight - 50.0; // 画面下部に到達する位置

    // ランダムなサイズを生成（25から100の間）
    final randomSize = (Random().nextDouble() * 75 + 25);

    setState(() {
      _circlePositions.add(initialPosition);
      _circleHorizontalPositions.add(
        Random().nextDouble() * (screenWidth - randomSize),
      );
      _circleKeys.add(DateTime.now().millisecondsSinceEpoch);
      _circleColors.add(_getRandomColor());
      _isExploding.add(false);
      _circleSizes.add(randomSize);
    });

    // アニメーションの開始を少し遅らせる
    Future.delayed(const Duration(milliseconds: 50), () {
      if (mounted) {
        setState(() {
          if (_circlePositions.isNotEmpty) {
            _circlePositions[_circlePositions.length - 1] = finalPosition;
          }
        });
      }
    });
  }

  Color _getRandomColor() {
    return AppConstants.circleColors[Random().nextInt(
      AppConstants.circleColors.length,
    )];
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
    _resetTimer = Timer(AppConstants.resetDelay, () {
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
          _circleSizes.removeAt(index);
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
                  color: AppConstants.countBackgroundColor.withOpacity(
                    AppConstants.countBackgroundOpacity,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  '$_tapCount',
                  style: const TextStyle(
                    fontSize: 24,
                    color: AppConstants.countTextColor,
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
            if (_buttonPressCount > 0)
              Center(
                child: Text(
                  '$_buttonPressCount',
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            if (_countdownText != null)
              Center(
                child: Text(
                  _countdownText!,
                  style: const TextStyle(
                    fontSize: 72,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
            ...List.generate(_circlePositions.length, (index) {
              return AnimatedPositioned(
                key: ValueKey(_circleKeys[index]),
                duration: Duration(
                  milliseconds: ((Random().nextInt(5) + 4) * 500).toInt(),
                ),
                top: _circlePositions[index],
                left: _circleHorizontalPositions[index],
                child: GestureDetector(
                  onTap: () => _handleTap(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width:
                        _isExploding[index]
                            ? _circleSizes[index] * 2
                            : _circleSizes[index],
                    height:
                        _isExploding[index]
                            ? _circleSizes[index] * 2
                            : _circleSizes[index],
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
      floatingActionButton: GestureDetector(
        onTapDown: (_) => _startButtonPress(),
        onTapUp: (_) => _endButtonPress(),
        onTapCancel: () => _endButtonPress(),
        child: FloatingActionButton(
          onPressed: null, // GestureDetectorで制御するためnullに設定
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
