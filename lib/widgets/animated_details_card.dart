import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/pokemon.dart';

class AnimatedDetailsCard extends StatefulWidget {
  final PokemonDetail pokemon;
  final Color color1;
  final Color color2;
  final bool isDesktop;
  final Widget child;

  const AnimatedDetailsCard({
    super.key,
    required this.pokemon,
    required this.color1,
    required this.color2,
    required this.isDesktop,
    required this.child,
  });

  @override
  State<AnimatedDetailsCard> createState() => _AnimatedDetailsCardState();
}

class _AnimatedDetailsCardState extends State<AnimatedDetailsCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 6))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Increased transparency so background effects and animations show through beautifully
    Color darkColor1 = Color.lerp(widget.color1, Colors.black, 0.5)!.withOpacity(0.5);
    Color darkColor2 = Color.lerp(widget.color2, Colors.black, 0.8)!.withOpacity(0.6);

    return Container(
      margin: EdgeInsets.all(widget.isDesktop ? 32 : 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: widget.color1.withOpacity(0.3), 
            blurRadius: 30,
            spreadRadius: 5,
            offset: const Offset(0, 10),
          ),
        ]
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), 
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              double x = sin(_controller.value * pi);
              double y = cos(_controller.value * pi);
              
              return Container(
                padding: EdgeInsets.all(widget.isDesktop ? 40 : 24),
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment(x, y),
                    radius: 2.0,
                    colors: [
                      darkColor1,
                      darkColor2,
                      Colors.black87.withOpacity(0.4),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.5), 
                ),
                child: widget.child,
              );
            }
          ),
        ),
      ),
    );
  }
}
