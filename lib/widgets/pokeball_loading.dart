import 'dart:math';
import 'package:flutter/material.dart';

class PokeballLoading extends StatefulWidget {
  final double size;
  final Color color;

  const PokeballLoading({super.key, this.size = 50.0, this.color = Colors.redAccent});

  @override
  State<PokeballLoading> createState() => _PokeballLoadingState();
}

class _PokeballLoadingState extends State<PokeballLoading> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // Fast rotation for loading effect
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 800))..repeat();
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
      builder: (context, child) {
        return Transform.rotate(
          angle: _controller.value * 2 * pi,
          child: Icon(
            Icons.catching_pokemon,
            size: widget.size,
            color: widget.color,
          ),
        );
      },
    );
  }
}
