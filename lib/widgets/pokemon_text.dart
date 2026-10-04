import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/pokemon_data.dart';

class PokemonText extends StatefulWidget {
  final String text;
  final String type;
  final String? pokemonName; 
  final double fontSize;
  final double letterSpacing;
  final double strokeWidth;

  const PokemonText({
    super.key,
    required this.text,
    required this.type,
    this.pokemonName,
    this.fontSize = 24,
    this.letterSpacing = 2,
    this.strokeWidth = 3,
  });

  @override
  State<PokemonText> createState() => _PokemonTextState();
}

class _PokemonTextState extends State<PokemonText> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'grass': return Colors.green.shade700;
      case 'fire': return Colors.red.shade700;
      case 'water': return Colors.blue.shade700;
      case 'electric': return Colors.orange.shade700;
      case 'ghost': return Colors.deepPurple;
      case 'dark': return Colors.black87;
      default: return Colors.blueGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    String name = widget.pokemonName ?? widget.text;
    bool isLegendary = legendaryPokemon.contains(name.toLowerCase());
    bool isMythical = mythicalPokemon.contains(name.toLowerCase());

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        if (isLegendary) return _buildLegendaryText();
        if (isMythical) return _buildMythicalText();
        
        switch (widget.type.toLowerCase()) {
          case 'fire': return _buildFireText();
          case 'water': return _buildWaterText();
          case 'electric': return _buildElectricText();
          case 'ghost': 
          case 'dark': return _buildSpookyText();
          default: return _buildStandardText();
        }
      }
    );
  }

  Widget _buildLegendaryText() {
    double progress = _controller.value;
    return Text(
      widget.text,
      textAlign: TextAlign.center,
      style: GoogleFonts.cinzelDecorative(
        fontSize: widget.fontSize,
        letterSpacing: widget.letterSpacing,
        fontWeight: FontWeight.bold,
        color: Colors.amberAccent.shade100,
        shadows: [
          Shadow(
            color: Colors.amber,
            blurRadius: 10 + (progress * 15),
            offset: const Offset(0, 0),
          )
        ]
      ),
    );
  }

  Widget _buildMythicalText() {
    double progress = _controller.value;
    return Text(
      widget.text,
      textAlign: TextAlign.center,
      style: GoogleFonts.macondo(
        fontSize: widget.fontSize + 4,
        letterSpacing: widget.letterSpacing,
        fontWeight: FontWeight.bold,
        color: Colors.pinkAccent.shade100,
        shadows: [
          Shadow(
            color: Colors.deepPurpleAccent,
            blurRadius: 15 + (progress * 10),
            offset: Offset(sin(progress * pi) * 2, cos(progress * pi) * 2),
          )
        ]
      ),
    );
  }

  Widget _buildFireText() {
    double progress = _controller.value;
    return Transform.translate(
      offset: Offset(0, sin(progress * 10) * 2),
      child: Text(
        widget.text,
        textAlign: TextAlign.center,
        style: GoogleFonts.bangers(
          fontSize: widget.fontSize + 4,
          letterSpacing: widget.letterSpacing,
          color: Colors.orangeAccent,
          shadows: [
            Shadow(
              color: Colors.red,
              blurRadius: 5 + (progress * 5),
              offset: const Offset(0, -2), 
            )
          ]
        ),
      ),
    );
  }

  Widget _buildWaterText() {
    double progress = _controller.value;
    return Transform.translate(
      offset: Offset(sin(progress * pi * 2) * 5, 0),
      child: Text(
        widget.text,
        textAlign: TextAlign.center,
        style: GoogleFonts.pacifico(
          fontSize: widget.fontSize,
          color: Colors.white,
          shadows: const [
            Shadow(color: Colors.blueAccent, blurRadius: 15)
          ]
        ),
      ),
    );
  }

  Widget _buildElectricText() {
    double progress = _controller.value;
    bool isStrobe = (progress * 20).toInt() % 2 == 0;
    
    return Transform.translate(
      offset: Offset((_random.nextDouble() - 0.5) * 4, (_random.nextDouble() - 0.5) * 4),
      child: Text(
        widget.text,
        textAlign: TextAlign.center,
        style: GoogleFonts.orbitron(
          fontSize: widget.fontSize,
          fontWeight: FontWeight.w900,
          color: isStrobe ? Colors.yellowAccent : Colors.white,
          shadows: [
            Shadow(
              color: isStrobe ? Colors.orangeAccent : Colors.blueAccent,
              blurRadius: isStrobe ? 20 : 5,
            )
          ]
        ),
      ),
    );
  }

  Widget _buildSpookyText() {
    double progress = _controller.value;
    return Text(
      widget.text,
      textAlign: TextAlign.center,
      style: GoogleFonts.creepster(
        fontSize: widget.fontSize + 6,
        color: Colors.white70,
        shadows: [
          Shadow(
            color: Colors.deepPurple,
            blurRadius: 20 * progress,
          )
        ]
      ),
    );
  }

  Widget _buildStandardText() {
    Color typeColor = _getTypeColor(widget.type);
    
    return Stack(
      children: [
        Text(
          widget.text,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: widget.fontSize,
            fontWeight: FontWeight.w900,
            letterSpacing: widget.letterSpacing,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = widget.strokeWidth
              ..color = typeColor,
          ),
        ),
        Text(
          widget.text,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: widget.fontSize,
            fontWeight: FontWeight.w900,
            letterSpacing: widget.letterSpacing,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
