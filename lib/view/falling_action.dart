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

  void _incrementCounter() {
    setState(() {
      _circlePosition = _circlePosition == -100.0 ? 0.0 : -100.0; // 位置を切り替え
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
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppConstants.circleColor,
                  shape: BoxShape.circle,
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
