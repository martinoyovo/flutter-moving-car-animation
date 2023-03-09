import 'dart:async';

import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  double moveX = 0;
  final moveY = 1;

  @override
  void initState() {
    Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {
        //moveX -= 5;

        //looping bg
        if(moveX <= -100) {
          moveX = -0;
        }
      });
    });

    moveController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500))..repeat();
    moveAnimation = Tween<double>(begin: 0, end: 50).animate(moveController);

    moveController.addStatusListener((status) {
      moveController.repeat();
      setState(() {});
    });

    super.initState();
  }

  late AnimationController moveController;
  late Animation moveAnimation;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
      return Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            Stack(
              children: [
                Image.asset('assets/Img_1.png'),
                Positioned(
                  bottom: moveController.value,
                  left: moveX,
                  right: -moveX,
                  child: Stack(
                    children: [
                      Image.asset(
                        'assets/Img_05.png',
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        left: 148,
                        bottom: 0,
                        child: CustomPaint(
                          size: const Size(140, 20),
                          painter: DrawLight(),
                        )
                      )
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {

                    if(moveController.isCompleted) {
                      setState(() {
                        moveController.stop();
                      });
                    }
                    else {
                      setState(() {
                        moveController.forward();
                      });
                    }
                },
                child: const Text('Move Car')
              )
              ],
            )
          ],
        ),
      );
  }
}

class DrawLight extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    final paint = Paint(
      
    )..shader = LinearGradient(colors: [
      Colors.yellow.withOpacity(0.7),
      Colors.white.withOpacity(0.7),
    ]).createShader(
      Rect.fromCircle(center: const Offset(50, 15), radius: 10)
    );

    path.moveTo(0, 0);
    path.lineTo(size.width, size.height);
    path.relativeLineTo(-size.width+50, 0);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

}
