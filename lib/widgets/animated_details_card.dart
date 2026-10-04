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
    // 6-second sweeping animation loop
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 6))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // We lerp the colors with black to create a premium dark background that still vividly shows the Pokemon's element
    Color darkColor1 = Color.lerp(widget.color1, Colors.black, 0.4)!.withOpacity(0.9);
    Color darkColor2 = Color.lerp(widget.color2, Colors.black, 0.7)!.withOpacity(0.95);

    return Container(
      margin: EdgeInsets.all(widget.isDesktop ? 32 : 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: widget.color1.withOpacity(0.3), // Glow effect based on Pokemon type!
            blurRadius: 30,
            spreadRadius: 5,
            offset: const Offset(0, 10),
          ),
        ]
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15), // Glassmorphism base
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              // Create a swirling spotlight/aurora effect moving across the card
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
                      Colors.black87,
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.5), // Glass edge
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
