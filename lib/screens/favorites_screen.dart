import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pokemon_provider.dart';
import '../widgets/pokemon_card.dart';
import '../models/pokemon.dart';
import '../data/pokemon_data.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  String _currentFavType = 'All';
  
  final List<String> _types = [
    'All', 'Legendary', 'Mythical', 'Normal', 'Fire', 'Water', 'Electric', 'Grass', 'Ice', 
    'Fighting', 'Poison', 'Ground', 'Flying', 'Psychic', 'Bug', 
    'Rock', 'Ghost', 'Dragon', 'Dark', 'Steel', 'Fairy'
  ];

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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _types.length,
                itemBuilder: (context, index) {
                  final type = _types[index];
                  final isSelected = _currentFavType == type;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: FilterChip(
                      label: Text(type, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                      selected: isSelected,
                      selectedColor: Colors.red.shade200,
                      checkmarkColor: Colors.red.shade900,
                      backgroundColor: Colors.grey.shade100,
                      elevation: isSelected ? 4 : 0,
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      onSelected: (selected) {
                        setState(() {
                          _currentFavType = selected ? type : 'All';
                        });
                      },
                    ),
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: Consumer<PokemonProvider>(
              builder: (context, provider, child) {
                final allFavorites = provider.favoriteDetails;
                
                List<PokemonDetail> filteredFavorites = allFavorites;
                if (_currentFavType != 'All') {
                  if (_currentFavType == 'Legendary') {
                    filteredFavorites = allFavorites.where((p) => legendaryPokemon.contains(p.name)).toList();
                  } else if (_currentFavType == 'Mythical') {
                    filteredFavorites = allFavorites.where((p) => mythicalPokemon.contains(p.name)).toList();
                  } else {
                    filteredFavorites = allFavorites.where((p) => p.types.contains(_currentFavType.toLowerCase())).toList();
                  }
                }

                if (filteredFavorites.isEmpty) {
                  return Center(
                    child: Text(
                      _currentFavType == 'All' 
                        ? 'No favorites yet!' 
                        : 'No $_currentFavType favorites found.', 
                      style: const TextStyle(fontSize: 18, color: Colors.grey)
                    )
                  );
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
                  itemCount: filteredFavorites.length,
                  itemBuilder: (context, index) {
                    return PokemonCard(pokemon: filteredFavorites[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
