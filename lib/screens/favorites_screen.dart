import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pokemon_provider.dart';
import '../widgets/pokemon_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    int crossAxisCount = (MediaQuery.of(context).size.width / 220).floor();
    if (crossAxisCount < 2) crossAxisCount = 2;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.red.shade600,
        foregroundColor: Colors.white,
      ),
      body: Consumer<PokemonProvider>(
        builder: (context, provider, child) {
          final favorites = provider.favoritePokemonList;
          if (favorites.isEmpty) {
            return const Center(child: Text('No favorites yet!', style: TextStyle(fontSize: 18, color: Colors.grey)));
          }
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            cacheExtent: 2000,
            physics: const BouncingScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: 0.8,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              return PokemonCard(pokemon: favorites[index]);
            },
          );
        },
      ),
    );
  }
}
