import 'package:confetti/confetti.dart';
import 'package:consid_event_app/theme/custom_colors.dart';
import 'package:flutter/material.dart';

class TopConfettiWidget extends StatefulWidget {
  final Widget child;

  const TopConfettiWidget({Key? key, required this.child}) : super(key: key);

  @override
  _TopConfettiWidgetState createState() => _TopConfettiWidgetState();
}

class _TopConfettiWidgetState extends State<TopConfettiWidget> {
  late ConfettiController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ConfettiController(duration: const Duration(seconds: 5));
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

  Widget confetti() => Align(
        alignment: Alignment.topCenter,
        child: ConfettiWidget(
          confettiController: _controller,
          colors: CustomColors.confettiColorList,
          shouldLoop: true,
          blastDirectionality: BlastDirectionality.explosive,
          emissionFrequency: 0.05,
          numberOfParticles: 10,
          gravity: 0.05,
        ),
      );
}
