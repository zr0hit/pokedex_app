import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/pokemon.dart';
import '../providers/pokemon_provider.dart';
import '../screens/detail_screen.dart';
import 'type_animation.dart';
import 'pokemon_text.dart';

class PokemonCard extends StatelessWidget {
  final PokemonDetail pokemon;

  const PokemonCard({super.key, required this.pokemon});

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'grass': return Colors.green.shade500;
      case 'fire': return Colors.red.shade500;
      case 'water': return Colors.blue.shade500;
      case 'bug': return Colors.lightGreen.shade600;
      case 'normal': return Colors.grey.shade500;
      case 'poison': return Colors.purple.shade400;
      case 'electric': return Colors.orangeAccent.shade400;
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

  @override
  Widget build(BuildContext context) {
    String primaryType = pokemon.types.isNotEmpty ? pokemon.types.first : 'normal';
    String secondaryType = pokemon.types.length > 1 ? pokemon.types[1] : primaryType;
    Color c1 = _getTypeColor(primaryType);
    Color c2 = _getTypeColor(secondaryType);
    if (c1 == c2) {
      c2 = c1.withAlpha(150);
    }

    return Card(
      elevation: 6,
      shadowColor: c1.withOpacity(0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          showTypeAnimation(context, pokemon, () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailScreen(pokemonItem: pokemon),
              ),
            );
          });
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [c1, c2],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              // Giant Watermark Pokeball
              Positioned(
                right: -25,
                bottom: -25,
                child: Icon(
                  Icons.catching_pokemon,
                  size: 140,
                  color: Colors.white.withOpacity(0.15),
                ),
              ),
              
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0, top: 12.0),
                        child: Text(
                          '#${pokemon.id.toString().padLeft(3, '0')}',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8), 
                            fontSize: 14, 
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      Consumer<PokemonProvider>(
                        builder: (context, provider, child) {
                          final isFav = provider.isFavorite(pokemon.id);
                          return IconButton(
                            icon: Icon(
                              isFav ? Icons.favorite : Icons.favorite_border,
                              color: isFav ? Colors.redAccent : Colors.white70,
                            ),
                            onPressed: () => provider.toggleFavorite(pokemon.id),
                          );
                        },
                      ),
                    ],
                  ),
                  
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Hero(
                        tag: 'pokemon-${pokemon.id}',
                        child: Image.network(
                          pokemon.imageUrl,
                          fit: BoxFit.contain,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(child: CircularProgressIndicator(color: Colors.white));
                          },
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.error, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Center(
                      child: PokemonText(
                        text: pokemon.name.toUpperCase(),
                        type: primaryType,
                        fontSize: 18,
                        strokeWidth: 3.5,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
