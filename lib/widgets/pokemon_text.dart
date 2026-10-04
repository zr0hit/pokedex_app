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
        return _buildStandardText(); // All other types revert to the standard anime style
      }
    );
  }

  Widget _buildLegendaryText() {
    double progress = _controller.value;
    Color typeColor = _getTypeColor(widget.type);
    
    return Text(
      widget.text,
      textAlign: TextAlign.center,
      style: GoogleFonts.cinzelDecorative(
        fontSize: widget.fontSize,
        letterSpacing: widget.letterSpacing,
        fontWeight: FontWeight.bold,
        color: Colors.white, // Crisp white text so it doesn't blend into backgrounds
        shadows: [
          Shadow(
            color: typeColor, // Massive pulsing glow perfectly matching their specific element!
            blurRadius: 10 + (progress * 20),
            offset: const Offset(0, 0),
          ),
          Shadow(
            color: Colors.black.withOpacity(0.8), // Drop shadow guarantees readability
            blurRadius: widget.strokeWidth,
            offset: const Offset(1, 1),
          )
        ]
      ),
    );
  }

  Widget _buildMythicalText() {
    double progress = _controller.value;
    Color typeColor = _getTypeColor(widget.type);
    
    return Text(
      widget.text,
      textAlign: TextAlign.center,
      style: GoogleFonts.macondo(
        fontSize: widget.fontSize + 4,
        letterSpacing: widget.letterSpacing,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        shadows: [
          Shadow(
            color: typeColor, // Mystical swirl glow matching their element!
            blurRadius: 15 + (progress * 15),
            offset: Offset(sin(progress * pi) * 2, cos(progress * pi) * 2),
          ),
          Shadow(
            color: Colors.black.withOpacity(0.8),
            blurRadius: widget.strokeWidth,
            offset: const Offset(1, 1),
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
