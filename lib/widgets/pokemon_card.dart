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

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Consumer<PokemonProvider>(
                builder: (context, provider, child) {
                  final isFav = provider.isFavorite(pokemon.id);
                  return IconButton(
                    icon: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: isFav ? Colors.red : Colors.grey,
                    ),
                    onPressed: () => provider.toggleFavorite(pokemon.id),
                  );
                },
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.network(
                  pokemon.imageUrl,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    '#${pokemon.id.toString().padLeft(3, '0')}',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  PokemonText(
                    text: pokemon.name.toUpperCase(),
                    type: pokemon.types.isNotEmpty ? pokemon.types.first : 'normal',
                    fontSize: 16,
                    strokeWidth: 3,
                    letterSpacing: 1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
