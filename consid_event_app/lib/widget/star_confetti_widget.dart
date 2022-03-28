import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:consid_event_app/theme/custom_colors.dart';
import 'package:flutter/material.dart';

class StarConfettiWidget extends StatefulWidget {
  final Widget child;

  const StarConfettiWidget({Key? key, required this.child}) : super(key: key);

  @override
  _StarConfettiWidgetState createState() => _StarConfettiWidgetState();
}

class _StarConfettiWidgetState extends State<StarConfettiWidget> {
  late ConfettiController _controller;
  final Random _random = Random();
  final int _min = 2;
  final int _max = 8;

  @override
  void initState() {
    super.initState();
    _controller = ConfettiController(duration: const Duration(seconds: 15));
    _controller.play();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        confetti(),
      ],
    );
  }

  int particles() => _min + _random.nextInt(_max - _min);

  Widget confetti() => Align(
        alignment: Alignment.topCenter,
        child: ConfettiWidget(
          confettiController: _controller,
          colors: CustomColors.confettiColorList,
          shouldLoop: true,
          blastDirectionality: BlastDirectionality.explosive,
          maxBlastForce: 10,
          minBlastForce: 5,
          emissionFrequency: 0.005,
          numberOfParticles: particles(),
          gravity: 0.05,
          createParticlePath: drawStar,
        ),
      );

  Path drawStar(Size size) {
    // Method to convert degree to radians
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }
}
