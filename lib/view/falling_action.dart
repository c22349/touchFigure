import 'package:flutter/material.dart';
import 'package:touchfigure/app_constants.dart';

class FallingAction extends StatefulWidget {
  const FallingAction({super.key, required this.title});

  final String title;

  @override
  State<FallingAction> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<FallingAction> {
  List<double> _circlePositions = []; // 円の位置を管理するリスト

  void _incrementCounter() {
    setState(() {
      _circlePositions.add(-100.0); // 新しい円を初期位置に追加
    });

    // 各円のアニメーションを開始
    Future.delayed(Duration.zero, () {
      setState(() {
        if (_circlePositions.isNotEmpty) {
          _circlePositions[_circlePositions.length - 1] =
              MediaQuery.of(context).size.height + 50.0; // 画面の下まで移動
        }
      });

      // アニメーションが終了した後に円を削除
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          if (_circlePositions.isNotEmpty) {
            _circlePositions.removeAt(0); // 最初の円を削除
          }
        });
      });
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
          children:
              _circlePositions.map((position) {
                return AnimatedPositioned(
                  duration: const Duration(seconds: 1),
                  top: position,
                  left: MediaQuery.of(context).size.width / 2 - 25, // 中央に配置
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppConstants.circleColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              }).toList(),
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
