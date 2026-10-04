import 'dart:math';
import 'package:flutter/material.dart';
import '../models/pokemon.dart';
import '../data/pokemon_data.dart';

void showTypeAnimation(BuildContext context, PokemonDetail pokemon, VoidCallback onComplete) {
  final overlay = Overlay.of(context);
  late OverlayEntry entry;

  entry = OverlayEntry(
    builder: (context) => _AdvancedAnimationWidget(
      pokemon: pokemon,
      onComplete: () {
        entry.remove();
        onComplete();
      },
    ),
  );

  overlay.insert(entry);
}

class _AdvancedAnimationWidget extends StatefulWidget {
  final PokemonDetail pokemon;
  final VoidCallback onComplete;

  const _AdvancedAnimationWidget({required this.pokemon, required this.onComplete});

  @override
  _AdvancedAnimationWidgetState createState() => _AdvancedAnimationWidgetState();
}

class _AdvancedAnimationWidgetState extends State<_AdvancedAnimationWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final Random _random = Random();
  bool isLegendary = false;
  bool isMythical = false;
  late String primaryType;
  
  late List<_Particle> _standardParticles;

  @override
  void initState() {
    super.initState();
    isLegendary = legendaryPokemon.contains(widget.pokemon.name.toLowerCase());
    isMythical = mythicalPokemon.contains(widget.pokemon.name.toLowerCase());
    primaryType = widget.pokemon.types.isNotEmpty ? widget.pokemon.types.first.toLowerCase() : 'normal';

    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400));
    
    // Only generate standard particles if we need them
    if (!isLegendary && !isMythical && primaryType != 'electric' && primaryType != 'fire') {
      int totalStats = widget.pokemon.stats.values.fold(0, (sum, val) => sum + val);
      int particleCount = (totalStats / 7).clamp(30, 120).toInt();
      _standardParticles = List.generate(particleCount, (index) => _createParticle(primaryType));
    }

    _controller.forward().then((_) {
      widget.onComplete();
    });
  }

  _Particle _createParticle(String type) {
    IconData icon;
    Color color;
    double startX = 0.5, startY = 0.5, endX = 0.5, endY = 0.5;
    
    switch (type) {
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
      case 'rock': case 'ground': case 'fighting':
        icon = Icons.landscape; color = Colors.brown.shade400; 
        startX = _random.nextDouble(); startY = -0.2;
        endX = startX; endY = 1.2;
        break;
      case 'psychic': case 'ghost': case 'poison': 
        icon = Icons.blur_on; color = Colors.purpleAccent; 
        startX = _random.nextDouble(); startY = _random.nextDouble();
        endX = startX + (_random.nextDouble() - 0.5) * 1.2; endY = startY + (_random.nextDouble() - 0.5) * 1.2;
        break;
      case 'flying': case 'dragon': 
        icon = Icons.air; color = Colors.cyanAccent; 
        startX = -0.2; startY = _random.nextDouble();
        endX = 1.2; endY = startY + (_random.nextDouble() - 0.5) * 0.5;
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
        if (isLegendary) return _buildLegendary();
        if (isMythical) return _buildMythical();
        
        switch (primaryType) {
          case 'electric': return _buildElectric();
          case 'fire': return _buildFire();
          default: return _buildStandard();
        }
      }
    );
  }

  Widget _buildLegendary() {
    double progress = _controller.value;
    double scale = Curves.easeOutQuart.transform(progress) * 20;
    double opacity = progress > 0.7 ? (1.0 - progress) * 3.33 : 1.0;
    
    return IgnorePointer(
      child: Stack(
        children: [
          // White flash
          if (progress < 0.2)
            Positioned.fill(child: Container(color: Colors.white.withOpacity(1.0 - (progress * 5)))),
          // Golden Expanding Aura
          Positioned.fill(
            child: Opacity(
              opacity: opacity.clamp(0.0, 1.0),
              child: Center(
                child: Transform.scale(
                  scale: scale,
                  child: Transform.rotate(
                    angle: progress * pi,
                    child: const Icon(Icons.wb_twilight, color: Colors.amberAccent, size: 100),
                  ),
                ),
              ),
            ),
          ),
          // Intense gold overlay
          Positioned.fill(child: Container(color: Colors.amber.withOpacity(sin(progress * pi) * 0.5))),
        ],
      ),
    );
  }

  Widget _buildMythical() {
    double progress = _controller.value;
    double scale = Curves.easeInOutCubic.transform(progress) * 15;
    double opacity = progress > 0.8 ? (1.0 - progress) * 5 : 1.0;
    
    return IgnorePointer(
      child: Stack(
        children: [
          // Galaxy Purple background flash
          Positioned.fill(child: Container(color: Colors.deepPurple.shade900.withOpacity(sin(progress * pi)))),
          // Swirling stars
          Positioned.fill(
            child: Opacity(
              opacity: opacity.clamp(0.0, 1.0),
              child: Center(
                child: Transform.scale(
                  scale: scale,
                  child: Transform.rotate(
                    angle: -progress * 2 * pi,
                    child: const Icon(Icons.flare, color: Colors.cyanAccent, size: 100),
                  ),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Opacity(
              opacity: opacity.clamp(0.0, 1.0),
              child: Center(
                child: Transform.scale(
                  scale: scale * 0.8,
                  child: Transform.rotate(
                    angle: progress * 3 * pi,
                    child: const Icon(Icons.auto_awesome, color: Colors.pinkAccent, size: 80),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildElectric() {
    double progress = _controller.value;
    bool isFlash = (progress * 20).toInt() % 2 == 0 && progress < 0.8;
    double opacity = progress > 0.8 ? (1.0 - progress) * 5 : 1.0;

    return IgnorePointer(
      child: Stack(
        children: [
          // Strobe Light
          if (isFlash) Positioned.fill(child: Container(color: Colors.white)),
          if (!isFlash) Positioned.fill(child: Container(color: Colors.yellowAccent.withOpacity(sin(progress*pi) * 0.6))),
          
          // Huge chaotic lightning bolts
          ...List.generate(5, (index) {
             // Only show randomly during the animation
             if ((progress * 100).toInt() % (index + 2) != 0) return const SizedBox();
             
             return Positioned(
               left: _random.nextDouble() * MediaQuery.of(context).size.width - 100,
               top: _random.nextDouble() * MediaQuery.of(context).size.height - 100,
               child: Opacity(
                 opacity: opacity.clamp(0.0, 1.0),
                 child: Transform.rotate(
                   angle: (_random.nextDouble() - 0.5) * pi,
                   child: Transform.scale(
                     scale: 5.0 + _random.nextDouble() * 10,
                     child: const Icon(Icons.bolt, color: Colors.yellow, size: 100),
                   ),
                 ),
               ),
             );
          })
        ],
      ),
    );
  }

  Widget _buildFire() {
    double progress = _controller.value;
    double opacity = progress > 0.7 ? (1.0 - progress) * 3.33 : 1.0;
    
    return IgnorePointer(
      child: Stack(
        children: [
          // Orange flash
          Positioned.fill(child: Container(color: Colors.deepOrange.withOpacity(sin(progress * pi) * 0.8))),
          
          // Eruption from bottom
          ...List.generate(30, (index) {
            double easeProgress = Curves.easeOutCubic.transform(progress);
            double x = 0.5 + (_random.nextDouble() - 0.5) * easeProgress * 2;
            double y = 1.2 - easeProgress * (1.0 + _random.nextDouble());
            double scale = (1.0 - progress) * 3 + _random.nextDouble() * 2;
            
            return Positioned(
              left: x * MediaQuery.of(context).size.width,
              top: y * MediaQuery.of(context).size.height,
              child: Opacity(
                opacity: opacity.clamp(0.0, 1.0),
                child: Transform.scale(
                  scale: scale,
                  child: const Icon(Icons.local_fire_department, color: Colors.orangeAccent, size: 80),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildStandard() {
    double progress = _controller.value;
    Color mainColor = _standardParticles.isNotEmpty ? _standardParticles.first.color : Colors.white;
    double bgOpacity = sin(progress * pi) * 0.5;

    return IgnorePointer(
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(color: mainColor.withOpacity(bgOpacity.clamp(0.0, 1.0))),
          ),
          ..._standardParticles.map((p) {
            double easeProgress = Curves.easeOutQuad.transform(progress);
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
                  offset: Offset(-p.size/2, -p.size/2),
                  child: Transform.rotate(
                    angle: currentRotation,
                    child: Transform.scale(
                      scale: scale,
                      child: Icon(
                         p.icon, 
                         color: p.color, 
                         size: p.size,
                         shadows: [Shadow(blurRadius: 15.0, color: p.color.withOpacity(0.8), offset: const Offset(0, 0))]
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
