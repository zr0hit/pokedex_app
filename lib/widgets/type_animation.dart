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
  late String secondaryType;
  
  late List<_Particle> _standardParticles;

  @override
  void initState() {
    super.initState();
    isLegendary = legendaryPokemon.contains(widget.pokemon.name.toLowerCase());
    isMythical = mythicalPokemon.contains(widget.pokemon.name.toLowerCase());
    primaryType = widget.pokemon.types.isNotEmpty ? widget.pokemon.types.first.toLowerCase() : 'normal';
    secondaryType = widget.pokemon.types.length > 1 ? widget.pokemon.types[1].toLowerCase() : primaryType;

    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400));
    
    if (!isLegendary && !isMythical && primaryType != 'electric' && primaryType != 'fire' && primaryType != 'water' && primaryType != 'grass') {
      int totalStats = widget.pokemon.stats.values.fold(0, (sum, val) => sum + val);
      int particleCount = (totalStats / 7).clamp(30, 120).toInt();
      _standardParticles = List.generate(particleCount, (index) => _createParticle(primaryType));
    }

    _controller.forward().then((_) {
      widget.onComplete();
    });
  }

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'grass': return Colors.green.shade500;
      case 'fire': return Colors.red.shade500;
      case 'water': return Colors.blue.shade500;
      case 'bug': return Colors.lightGreen.shade600;
      case 'normal': return Colors.grey.shade500;
      case 'poison': return Colors.purple.shade400;
      case 'electric': return Colors.yellowAccent.shade700;
      case 'ground': return Colors.brown.shade500;
      case 'fighting': return Colors.orange.shade700;
      case 'psychic': return Colors.pink.shade400;
      case 'rock': return Colors.brown.shade700;
      case 'ghost': return Colors.deepPurple.shade500;
      case 'ice': return Colors.cyan.shade600;
      case 'dragon': return Colors.indigo.shade500;
      case 'dark': return Colors.black87;
      case 'steel': return Colors.blueGrey.shade500;
      case 'fairy': return Colors.pinkAccent.shade400;
      default: return Colors.grey.shade500;
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'electric': return Icons.bolt;
      case 'fire': return Icons.local_fire_department;
      case 'water': case 'ice': return Icons.water_drop;
      case 'grass': case 'bug': return Icons.eco;
      case 'rock': case 'ground': case 'fighting': return Icons.landscape;
      case 'flying': case 'dragon': return Icons.air;
      case 'psychic': case 'ghost': case 'poison': return Icons.blur_on;
      default: return Icons.star;
    }
  }

  _Particle _createParticle(String type) {
    IconData icon = _getTypeIcon(type);
    Color color = _getTypeColor(type);
    double startX = 0.5, startY = 0.5, endX = 0.5, endY = 0.5;
    
    switch (type) {
      case 'water': case 'ice': 
        startX = _random.nextDouble(); startY = -0.2;
        endX = startX + 0.3; endY = 1.2;
        break;
      case 'grass': case 'bug': 
        startX = 1.2; startY = _random.nextDouble();
        endX = -0.2; endY = startY + (_random.nextDouble() - 0.5) * 0.7;
        break;
      case 'rock': case 'ground': case 'fighting':
        startX = _random.nextDouble(); startY = -0.2;
        endX = startX; endY = 1.2;
        break;
      case 'psychic': case 'ghost': case 'poison': 
        startX = _random.nextDouble(); startY = _random.nextDouble();
        endX = startX + (_random.nextDouble() - 0.5) * 1.2; endY = startY + (_random.nextDouble() - 0.5) * 1.2;
        break;
      case 'flying': case 'dragon': 
        startX = -0.2; startY = _random.nextDouble();
        endX = 1.2; endY = startY + (_random.nextDouble() - 0.5) * 0.5;
        break;
      default: 
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
    Color c1 = _getTypeColor(primaryType);
    Color c2 = _getTypeColor(secondaryType);
    if (c1 == c2) c2 = c1.withAlpha(150);
    IconData typeIcon = _getTypeIcon(primaryType);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        if (isLegendary) return _buildLegendary(c1, c2, typeIcon);
        if (isMythical) return _buildMythical(c1, c2, typeIcon);
        
        switch (primaryType) {
          case 'electric': return _buildElectric(c1);
          case 'fire': return _buildFire(c1);
          case 'water': return _buildWater(c1);
          case 'grass': return _buildGrass(c1);
          default: return _buildStandard(c1);
        }
      }
    );
  }

  Widget _buildLegendary(Color c1, Color c2, IconData typeIcon) {
    double progress = _controller.value;
    double scale = Curves.easeOutQuart.transform(progress) * 20;
    double opacity = progress > 0.7 ? (1.0 - progress) * 3.33 : 1.0;
    
    return IgnorePointer(
      child: Stack(
        children: [
          if (progress < 0.2)
            Positioned.fill(child: Container(color: c1.withOpacity(1.0 - (progress * 5)))),
          Positioned.fill(
            child: Opacity(
              opacity: opacity.clamp(0.0, 1.0),
              child: Center(
                child: Transform.scale(
                  scale: scale,
                  child: Transform.rotate(
                    angle: progress * pi,
                    child: Icon(Icons.wb_twilight, color: c2.withOpacity(0.8), size: 100),
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
                  scale: scale * 0.7,
                  child: Transform.rotate(
                    angle: -progress * 2 * pi,
                    child: Icon(typeIcon, color: c1, size: 80),
                  ),
                ),
              ),
            ),
          ),
          Positioned.fill(child: Container(color: c1.withOpacity(sin(progress * pi) * 0.4))),
        ],
      ),
    );
  }

  Widget _buildMythical(Color c1, Color c2, IconData typeIcon) {
    double progress = _controller.value;
    double scale = Curves.easeInOutCubic.transform(progress) * 15;
    double opacity = progress > 0.8 ? (1.0 - progress) * 5 : 1.0;
    
    Color galaxyColor = Color.lerp(Colors.deepPurple.shade900, c1, 0.6)!;
    
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned.fill(child: Container(color: galaxyColor.withOpacity(sin(progress * pi)))),
          Positioned.fill(
            child: Opacity(
              opacity: opacity.clamp(0.0, 1.0),
              child: Center(
                child: Transform.scale(
                  scale: scale,
                  child: Transform.rotate(
                    angle: -progress * 2 * pi,
                    child: Icon(Icons.flare, color: c2, size: 100),
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
                    child: Icon(typeIcon, color: c1, size: 80),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildElectric(Color c1) {
    double progress = _controller.value;
    bool isFlash = (progress * 20).toInt() % 2 == 0 && progress < 0.8;
    double opacity = progress > 0.8 ? (1.0 - progress) * 5 : 1.0;

    return IgnorePointer(
      child: Stack(
        children: [
          if (isFlash) Positioned.fill(child: Container(color: Colors.white)),
          if (!isFlash) Positioned.fill(child: Container(color: c1.withOpacity(sin(progress*pi) * 0.6))),
          
          ...List.generate(5, (index) {
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
                     child: Icon(Icons.bolt, color: c1, size: 100),
                   ),
                 ),
               ),
             );
          })
        ],
      ),
    );
  }

  Widget _buildFire(Color c1) {
    double progress = _controller.value;
    double opacity = progress > 0.7 ? (1.0 - progress) * 3.33 : 1.0;
    
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned.fill(child: Container(color: c1.withOpacity(sin(progress * pi) * 0.8))),
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
                  child: Icon(Icons.local_fire_department, color: c1, size: 80),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildWater(Color c1) {
    double progress = _controller.value;
    double opacity = progress > 0.8 ? (1.0 - progress) * 5 : 1.0;
    
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned.fill(child: Container(color: c1.withOpacity(sin(progress * pi) * 0.7))),
          ...List.generate(40, (index) {
            double startX = _random.nextDouble();
            double y = 1.2 - (progress * 2) - (_random.nextDouble() * 0.5);
            double x = startX + sin(progress * 10 + index) * 0.05;
            
            return Positioned(
              left: x * MediaQuery.of(context).size.width,
              top: y * MediaQuery.of(context).size.height,
              child: Opacity(
                opacity: opacity.clamp(0.0, 1.0),
                child: Icon(Icons.circle_outlined, color: Colors.white70, size: _random.nextDouble() * 40 + 10),
              ),
            );
          }),
          Positioned.fill(
            child: Opacity(
              opacity: (1.0 - progress).clamp(0.0, 1.0),
              child: Center(
                child: Transform.scale(
                  scale: progress * 15,
                  child: Icon(Icons.water_drop, color: c1.withOpacity(0.5), size: 100),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildGrass(Color c1) {
    double progress = _controller.value;
    double opacity = progress > 0.8 ? (1.0 - progress) * 5 : 1.0;
    
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned.fill(child: Container(color: c1.withOpacity(sin(progress * pi) * 0.6))),
          ...List.generate(35, (index) {
            double startX = 1.2 + _random.nextDouble();
            double startY = -0.2 - _random.nextDouble();
            double endX = -0.5 - _random.nextDouble();
            double endY = 1.2 + _random.nextDouble();
            
            double x = startX + (endX - startX) * progress;
            double y = startY + (endY - startY) * progress;
            double rotation = progress * 10 * _random.nextDouble();
            
            return Positioned(
              left: x * MediaQuery.of(context).size.width,
              top: y * MediaQuery.of(context).size.height,
              child: Opacity(
                opacity: opacity.clamp(0.0, 1.0),
                child: Transform.rotate(
                  angle: rotation,
                  child: Icon(Icons.eco, color: Colors.lightGreenAccent, size: _random.nextDouble() * 60 + 30),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildStandard(Color c1) {
    double progress = _controller.value;
    double bgOpacity = sin(progress * pi) * 0.5;

    return IgnorePointer(
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(color: c1.withOpacity(bgOpacity.clamp(0.0, 1.0))),
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
