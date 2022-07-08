import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fps_widget/fps_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.brown,
    Colors.black,
    Colors.pink,
    Colors.white,
  ];

  final random = Random();
  bool isRunning = false;

  @override
  void initState() {
    SchedulerBinding.instance.addPersistentFrameCallback((timeStamp) async {
      if (!isRunning) return;

      final mq = MediaQuery.of(context);

      final position = Offset(
        random.nextDouble() * mq.size.width,
        random.nextDouble() * mq.size.height - 100,
      );

      final pointerDown = PointerDownEvent(position: position);
      final pointerUp = PointerUpEvent(position: position);

      await Future.delayed(const Duration(milliseconds: 20));

      GestureBinding.instance.handlePointerEvent(pointerDown);
      GestureBinding.instance.handlePointerEvent(pointerUp);
    });
    super.initState();
  }

  void toggleRandomTaps() {
    setState(() {
      isRunning = !isRunning;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FPSWidget(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Center(
                child: Wrap(
                  children: [
                    for (int i = 0; i < 18; i++)
                      InkSparkleButton(
                        color: colors[i % colors.length],
                        onPressed: () {
                          setState(() {});
                        },
                      ),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: toggleRandomTaps,
              child: Text(isRunning ? 'Stop' : 'Start'),
            ),
          ],
        ),
      ),
    );
  }
}

class InkSparkleButton extends StatelessWidget {
  final Color color;
  final VoidCallback onPressed;

  const InkSparkleButton({
    super.key,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: IconButton(
        onPressed: onPressed,
        splashColor: color,
        iconSize: 80,
        icon: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            border: Border.all(
              color: color,
              width: 1,
            ),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
