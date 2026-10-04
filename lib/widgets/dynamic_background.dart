import 'dart:math';
import 'package:flutter/material.dart';
import '../models/pokemon.dart';

class DynamicBackground extends StatefulWidget {
  final PokemonDetail pokemon;
  final String bgUrl;
  final Color typeColor1;
  final Color typeColor2;

  const DynamicBackground({
    super.key,
    required this.pokemon,
    required this.bgUrl,
    required this.typeColor1,
    required this.typeColor2,
  });

  @override
  State<DynamicBackground> createState() => _DynamicBackgroundState();
}

class _DynamicBackgroundState extends State<DynamicBackground> with TickerProviderStateMixin {
  late AnimationController _gradientController;
  late AnimationController _rotationController;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    // Slow shifting gradient
    _gradientController = AnimationController(vsync: this, duration: const Duration(seconds: 8))..repeat(reverse: true);
    // Slow continuous rotation for the watermark
    _rotationController = AnimationController(vsync: this, duration: const Duration(seconds: 20))..repeat();
    // Subtle pulse effect
    _pulseController = AnimationController(vsync: this, duration: const Duration(seconds: 4))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _gradientController.dispose();
    _rotationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Base environment image
        Positioned.fill(
          child: Image.network(
            widget.bgUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, err, stack) => Container(color: Colors.grey.shade900),
          ),
        ),
        
        // Animated Shifting Gradient matching Pokemon Types
        Positioned.fill(
          child: AnimatedBuilder(
            animation: _gradientController,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      widget.typeColor1.withOpacity(0.65),
                      widget.typeColor2.withOpacity(0.65),
                      Colors.black.withOpacity(0.4), // Darken edges for contrast
                    ],
                    begin: Alignment(-1.0 + _gradientController.value, -1.0),
                    end: Alignment(1.0 - _gradientController.value, 1.0),
                    stops: const [0.0, 0.6, 1.0],
                  ),
                ),
              );
            },
          ),
        ),
        
        // Giant Rotating Pokeball Watermark
        Positioned(
          right: -150,
          bottom: -150,
          child: AnimatedBuilder(
            animation: Listenable.merge([_rotationController, _pulseController]),
            builder: (context, child) {
              double scale = 1.0 + (_pulseController.value * 0.1);
              return Transform.scale(
                scale: scale,
                child: Transform.rotate(
                  angle: _rotationController.value * 2 * pi,
                  child: Icon(
                    Icons.catching_pokemon, 
                    size: 700, 
                    color: Colors.white.withOpacity(0.15),
                  ),
                ),
              );
            }
          ),
        ),
        
        // Top-left Type Icon watermark for extra dynamism
        Positioned(
          left: -50,
          top: -50,
          child: AnimatedBuilder(
            animation: _rotationController,
            builder: (context, child) {
              return Transform.rotate(
                angle: -_rotationController.value * pi, // Rotate counter-clockwise
                child: Icon(
                  _getTypeIcon(widget.pokemon.types.first), 
                  size: 300, 
                  color: widget.typeColor1.withOpacity(0.2),
                ),
              );
            }
          ),
        ),
      ],
    );
  }

  IconData _getTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'electric': return Icons.bolt;
      case 'fire': return Icons.local_fire_department;
      case 'water': 
      case 'ice': return Icons.water_drop;
      case 'grass': 
      case 'bug': return Icons.eco;
      case 'rock': 
      case 'ground': 
      case 'fighting': return Icons.landscape;
      case 'flying': 
      case 'dragon': return Icons.air;
      case 'psychic':
      case 'ghost':
      case 'poison': return Icons.blur_on;
      default: return Icons.star;
    }
  }
}
