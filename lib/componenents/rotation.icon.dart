import 'package:flutter/material.dart';

class RotatingIcon extends StatefulWidget {
  final double size;

  const RotatingIcon({this.size = 100, super.key});

  @override
  _RotatingGearState createState() => _RotatingGearState();
}

class _RotatingGearState extends State<RotatingIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2), // durata di un giro completo
    )..repeat(); // ripete l'animazione all'infinito
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, child) {
        return Transform.rotate(
          angle: _controller.value * 2 * 3.14159265359, // da 0 a 2π
          child: child,
        );
      },
      child: Icon(
        Icons.settings, // puoi sostituire con un'immagine di ingranaggio
        size: widget.size,
        color: Colors.black,
      ),
    );
  }
}
