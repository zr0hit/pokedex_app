import 'dart:math';
import 'package:flutter/material.dart';
import '../models/pokemon.dart';

void showTypeAnimation(BuildContext context, PokemonDetail pokemon, VoidCallback onComplete) {
  final overlay = Overlay.of(context);
  late OverlayEntry entry;

  entry = OverlayEntry(
    builder: (context) => _TypeAnimationWidget(
      pokemon: pokemon,
      onComplete: () {
        entry.remove();
        onComplete();
      },
    ),
  );

  overlay.insert(entry);
}

class _TypeAnimationWidget extends StatefulWidget {
  final PokemonDetail pokemon;
  final VoidCallback onComplete;

  const _TypeAnimationWidget({required this.pokemon, required this.onComplete});

  @override
  _TypeAnimationWidgetState createState() => _TypeAnimationWidgetState();
}

class _TypeAnimationWidgetState extends State<_TypeAnimationWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final Random _random = Random();
  late List<_Particle> _particles;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400));
    
    int totalStats = widget.pokemon.stats.values.fold(0, (sum, val) => sum + val);
    int particleCount = (totalStats / 7).clamp(25, 120).toInt();

    _particles = List.generate(particleCount, (index) {
      String type = widget.pokemon.types[_random.nextInt(widget.pokemon.types.length)].toLowerCase();
      return _createParticle(type);
    });

    _controller.forward().then((_) {
      widget.onComplete();
    });
  }

  _Particle _createParticle(String type) {
    IconData icon;
    Color color;
    double startX = 0.5, startY = 0.5, endX = 0.5, endY = 0.5;
    
    switch (type) {
      case 'electric': 
        icon = Icons.bolt; color = Colors.yellowAccent; 
        startX = _random.nextDouble(); startY = -0.2;
        endX = startX + (_random.nextDouble() - 0.5) * 0.3; endY = 1.2;
        break;
      case 'rock': case 'ground': case 'fighting':
        icon = Icons.landscape; color = Colors.brown.shade400; 
        startX = _random.nextDouble(); startY = -0.2;
        endX = startX; endY = 1.2;
        break;
      case 'fire': 
        icon = Icons.local_fire_department; color = Colors.orangeAccent; 
        startX = _random.nextDouble(); startY = 1.2;
        endX = startX + (_random.nextDouble() - 0.5) * 0.6; endY = -0.2;
        break;
      case 'flying': case 'dragon': 
        icon = Icons.air; color = Colors.cyanAccent; 
        startX = -0.2; startY = _random.nextDouble();
        endX = 1.2; endY = startY + (_random.nextDouble() - 0.5) * 0.5;
        break;
      case 'water': case 'ice': 
        icon = Icons.water_drop; color = Colors.blueAccent; 
        startX = _random.nextDouble(); startY = -0.2;
        endX = startX + 0.3; endY = 1.2;
        break;
      case 'grass': case 'bug': 
        icon = Icons.eco; color = Colors.lightGreenAccent; 
        startX = 1.2; startY = _random.nextDouble();
        endX = -0.2; endY = startY + (_random.nextDouble() - 0.5) * 0.7;
        break;
      case 'psychic': case 'ghost': case 'poison': 
        icon = Icons.blur_on; color = Colors.purpleAccent; 
        startX = _random.nextDouble(); startY = _random.nextDouble();
        endX = startX + (_random.nextDouble() - 0.5) * 1.0; endY = startY + (_random.nextDouble() - 0.5) * 1.0;
        break;
      default: 
        icon = Icons.star; color = Colors.pinkAccent; 
        startX = 0.5; startY = 0.5;
        endX = _random.nextDouble() * 1.5 - 0.25; endY = _random.nextDouble() * 1.5 - 0.25;
        break;
    }

    return _Particle(
      icon: icon, color: color,
      startX: startX, startY: startY, endX: endX, endY: endY,
      size: _random.nextDouble() * 60 + 20,
      rotation: _random.nextDouble() * 2 * pi,
      rotationSpeed: (_random.nextDouble() - 0.5) * 15,
    );
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
        double progress = _controller.value;
        Color mainColor = _particles.isNotEmpty ? _particles.first.color : Colors.white;
        double bgOpacity = sin(progress * pi) * 0.5; // Flash effect

        return IgnorePointer(
          child: Stack(
            children: [
              Positioned.fill(
                child: Container(color: mainColor.withOpacity(bgOpacity.clamp(0.0, 1.0))),
              ),
              ..._particles.map((p) {
                double easeProgress;
                if (p.icon == Icons.local_fire_department || p.icon == Icons.blur_on) {
                   easeProgress = Curves.easeOutCubic.transform(progress);
                } else if (p.icon == Icons.bolt || p.icon == Icons.landscape || p.icon == Icons.water_drop) {
                   easeProgress = Curves.easeInQuint.transform(progress);
                } else {
                   easeProgress = Curves.easeOutQuad.transform(progress);
                }

                double x = p.startX + (p.endX - p.startX) * easeProgress;
                double y = p.startY + (p.endY - p.startY) * easeProgress;
                double currentRotation = p.rotation + (p.rotationSpeed * progress);
                double scale = sin(progress * pi) * 1.5 + 0.5; 
                double opacity = progress > 0.8 ? (1.0 - progress) * 5 : 1.0;

                return Positioned(
                  left: x * MediaQuery.of(context).size.width,
                  top: y * MediaQuery.of(context).size.height,
                  child: Opacity(
                    opacity: opacity.clamp(0.0, 1.0),
                    child: Transform.translate(
                      offset: Offset(-p.size/2, -p.size/2), // center align
                      child: Transform.rotate(
                        angle: currentRotation,
                        child: Transform.scale(
                          scale: scale,
                          child: Icon(
                             p.icon, 
                             color: p.color, 
                             size: p.size,
                             shadows: [
                               Shadow(blurRadius: 15.0, color: p.color.withOpacity(0.8), offset: const Offset(0, 0))
                             ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }
}

class _Particle {
  final IconData icon;
  final Color color;
  final double startX;
  final double startY;
  final double endX;
  final double endY;
  final double size;
  final double rotation;
  final double rotationSpeed;

  _Particle({
    required this.icon, required this.color,
    required this.startX, required this.startY, required this.endX, required this.endY,
    required this.size, required this.rotation, required this.rotationSpeed,
  });
}
