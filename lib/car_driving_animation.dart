import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CarDrivingAnimation extends StatefulWidget {
  const CarDrivingAnimation({Key? key}) : super(key: key);

  @override
  State<CarDrivingAnimation> createState() => _CarDrivingAnimationState();
}

class _CarDrivingAnimationState extends State<CarDrivingAnimation> with SingleTickerProviderStateMixin {
  
  static double bottomHeight = 80;

  double moveX = 50;

  late AnimationController moveController;
  late Animation moveAnimation;

  bool lightOn = true;

  @override
  void initState() {
    Timer.periodic(const Duration(milliseconds: 10), (timer) {
      setState(() {
        moveX += 5;
      });

      //looping the move
      if(moveX >= 700) {
        moveX = 0;
      }
    });

    moveController = AnimationController(vsync: this,
        duration: const Duration(milliseconds: 300),
    );

    moveAnimation = Tween<double>(begin: 0, end: 4).animate(moveController);

    moveController.addListener(() {
      if(moveAnimation.status == AnimationStatus.completed) {
        moveController.reverse();
      }
      setState(() {});
    });

    moveController.repeat(reverse: true);

    super.initState();
  }

  final controlStopCar = LogicalKeySet(
    LogicalKeyboardKey.keyK
  );

  final controlLightOn = LogicalKeySet(
    LogicalKeyboardKey.keyL,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Shortcuts(
        shortcuts: {
          controlStopCar: StopCarIntent(),
          controlLightOn: LightOnIntent()
        },
        child: Actions(
          actions: <Type, Action<Intent>>{
            StopCarIntent: CallbackAction<StopCarIntent>(
              onInvoke: (intent) => stopCar()
            ),

            LightOnIntent: CallbackAction<LightOnIntent>(
              onInvoke: (intent) => turnLightOn()
            ),
          },
          child: Focus(
            autofocus: true,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  lightOn = !lightOn;
                });
              },
              onDoubleTap: () {
                if(moveController.isAnimating) {
                  moveController.stop();
                }
                else {
                  moveController.repeat(reverse: true);
                }

                setState(() {});
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Stack(
                      children: [
                        Image.asset('assets/Img_1.png'),
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: Container(
                            width: double.infinity,
                            height: bottomHeight,
                            color: const Color(0xFF261D37),
                          ),
                        ),

                        Positioned(
                          bottom: bottomHeight,
                          right: moveX,
                          child: Image.asset('assets/Img_03.png'),
                        ),
                        Positioned(
                          bottom: bottomHeight+moveAnimation.value,
                          left: 200,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Image.asset('assets/Img_05.png'),
                              if(lightOn == true) Positioned(
                                left: 148,
                                bottom: 0,
                                child: CustomPaint(
                                  size: const Size(140, 20),
                                  painter: DrawLight(),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50,),
                  const Text('Car Driving Animation with Flutter',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void stopCar() {
    if(moveController.isAnimating) {
      moveController.stop();
    }
    else {
      moveController.repeat(reverse: true);
    }

    setState(() {});
  }

  void turnLightOn() {
    setState(() {
      lightOn = !lightOn;
    });
  }
}

class DrawLight extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    final paint = Paint()..shader = LinearGradient(
      colors: [
        Colors.yellow.withOpacity(0.7),
        Colors.white.withOpacity(0.6)
      ]).createShader(
        Rect.fromCircle(
          center: const Offset(50, 15),
          radius: 10
        ));

    path.moveTo(0, 0);
    path.lineTo(size.width, size.height);
    path.relativeLineTo(-size.width+50, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class StopCarIntent extends Intent {}
class LightOnIntent extends Intent {}