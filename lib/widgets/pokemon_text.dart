import 'package:flutter/material.dart';

class PokemonText extends StatelessWidget {
  final String text;
  final String type;
  final double fontSize;
  final double strokeWidth;
  final double letterSpacing;

  const PokemonText({
    super.key, 
    required this.text, 
    required this.type,
    this.fontSize = 28,
    this.strokeWidth = 4,
    this.letterSpacing = 2,
  });

  @override
  Widget build(BuildContext context) {
    Color fill;
    Color stroke;

    switch (type.toLowerCase()) {
      case 'fire':
        fill = Colors.orangeAccent; stroke = Colors.red.shade900; break;
      case 'water':
        fill = Colors.lightBlueAccent; stroke = Colors.blue.shade900; break;
      case 'grass':
      case 'bug':
        fill = Colors.lightGreenAccent; stroke = Colors.green.shade900; break;
      case 'electric':
        fill = Colors.yellowAccent; stroke = Colors.blue.shade900; break; 
      case 'rock':
      case 'ground':
      case 'fighting':
        fill = Colors.orange.shade200; stroke = Colors.brown.shade900; break;
      case 'poison':
      case 'ghost':
        fill = Colors.purpleAccent.shade100; stroke = Colors.deepPurple.shade900; break;
      case 'psychic':
      case 'fairy':
        fill = Colors.pinkAccent.shade100; stroke = Colors.pink.shade900; break;
      case 'ice':
        fill = Colors.cyanAccent; stroke = Colors.blue.shade900; break;
      case 'dragon':
        fill = Colors.indigoAccent.shade100; stroke = Colors.red.shade900; break;
      default:
        fill = Colors.yellowAccent; stroke = Colors.blue.shade800; break;
    }

    return Stack(
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w900,
            letterSpacing: letterSpacing,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = strokeWidth
              ..color = stroke,
          ),
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w900,
            letterSpacing: letterSpacing,
            color: fill,
          ),
        ),
      ],
    );
  }
}
