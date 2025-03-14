import 'dart:math';
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

  void _incrementCounter() {
    setState(() {
      _circlePositions.add(-100.0); // 新しい円を初期位置に追加
      _circleHorizontalPositions.add(
        _getRandomHorizontalPosition(),
      ); // ランダムな横位置を追加
      _circleKeys.add(DateTime.now().millisecondsSinceEpoch); // 識別子を追加
      _circleColors.add(_getRandomColor()); // ランダムな色を追加
      _isExploding.add(false); // 新しい円の破裂状態を追加
    });

    // 各円のアニメーションを開始
    Future.delayed(Duration.zero, () {
      setState(() {
        if (_circlePositions.isNotEmpty) {
          _circlePositions[_circlePositions.length - 1] =
              MediaQuery.of(context).size.height + 50.0; // 画面の下まで移動
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Stack(
          children: List.generate(_circlePositions.length, (index) {
            return AnimatedPositioned(
              key: ValueKey(_circleKeys[index]), // 識別子をキーとして使用
              duration: const Duration(seconds: 3),
              top: _circlePositions[index],
              left: _circleHorizontalPositions[index], // ランダムな横位置を使用
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _isExploding[index] = true; // 破裂アニメーションを開始
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
                },
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
