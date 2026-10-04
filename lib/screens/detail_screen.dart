import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/pokemon.dart';
import '../providers/pokemon_provider.dart';
import '../widgets/pokemon_text.dart';

class DetailScreen extends StatefulWidget {
  final PokemonDetail pokemonItem;

  const DetailScreen({super.key, required this.pokemonItem});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late PokemonDetail _detail;

  @override
  void initState() {
    super.initState();
    _detail = widget.pokemonItem;
  }

  String _getBackgroundImage(String type) {
    switch (type.toLowerCase()) {
      case 'grass':
      case 'bug':
        return 'https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?q=80&w=1080&auto=format&fit=crop';
      case 'fire':
        return 'https://images.unsplash.com/photo-1473215535565-1d4e41d8e12b?q=80&w=1080&auto=format&fit=crop';
      case 'water':
        return 'https://images.unsplash.com/photo-1505118380757-91f5f5632de0?q=80&w=1080&auto=format&fit=crop';
      case 'rock':
      case 'ground':
      case 'fighting':
        return 'https://images.unsplash.com/photo-1522069169874-c58ec4b76be5?q=80&w=1080&auto=format&fit=crop';
      case 'electric':
        return 'https://images.unsplash.com/photo-1605722243979-fc0eb0f6120c?q=80&w=1080&auto=format&fit=crop';
      case 'flying':
      case 'dragon':
        return 'https://images.unsplash.com/photo-1499346156599-722135dc51c4?q=80&w=1080&auto=format&fit=crop';
      case 'ice':
        return 'https://images.unsplash.com/photo-1518780664697-55e3ad937233?q=80&w=1080&auto=format&fit=crop';
      case 'ghost':
      case 'dark':
      case 'poison':
        return 'https://images.unsplash.com/photo-1509983611728-98e3532c5ba7?q=80&w=1080&auto=format&fit=crop';
      case 'psychic':
      case 'fairy':
        return 'https://images.unsplash.com/photo-1534447677768-be436bb09401?q=80&w=1080&auto=format&fit=crop';
      default:
        return 'https://images.unsplash.com/photo-1500382017468-9049fed747ef?q=80&w=1080&auto=format&fit=crop';
    }
  }

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'grass': return Colors.green;
      case 'fire': return Colors.red;
      case 'water': return Colors.blue;
      case 'bug': return Colors.lightGreen;
      case 'normal': return Colors.grey;
      case 'poison': return Colors.purple;
      case 'electric': return Colors.orangeAccent;
      case 'ground': return Colors.brown;
      case 'fighting': return Colors.orange;
      case 'psychic': return Colors.pink;
      case 'rock': return Colors.brown.shade700;
      case 'ghost': return Colors.deepPurple;
      case 'ice': return Colors.cyan;
      case 'dragon': return Colors.indigo;
      case 'dark': return Colors.black87;
      case 'steel': return Colors.blueGrey;
      case 'fairy': return Colors.pinkAccent;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    String primaryType = _detail.types.isNotEmpty ? _detail.types.first : 'normal';
    String bgUrl = _getBackgroundImage(primaryType);

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              bgUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, err, stack) => Container(color: Colors.grey.shade800),
            ),
          ),
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.4)),
          ),
          
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
                        onPressed: () => Navigator.pop(context),
                      ),
                      PokemonText(
                        text: _detail.name.toUpperCase(),
                        type: primaryType,
                        fontSize: 26,
                        strokeWidth: 5,
                        letterSpacing: 2,
                      ),
                      Consumer<PokemonProvider>(
                        builder: (context, provider, child) {
                          final isFav = provider.isFavorite(_detail.id);
                          return IconButton(
                            icon: Icon(
                              isFav ? Icons.favorite : Icons.favorite_border,
                              color: isFav ? Colors.redAccent : Colors.white,
                              size: 30,
                            ),
                            onPressed: () => provider.toggleFavorite(_detail.id),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                
                Hero(
                  tag: 'pokemon-${_detail.id}',
                  child: Image.network(
                    _detail.imageUrl,
                    height: 220,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const SizedBox(
                        height: 220, 
                        child: Center(child: CircularProgressIndicator(color: Colors.white))
                      );
                    },
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.error, color: Colors.white, size: 100),
                  ),
                ),
                
                const SizedBox(height: 10),
                
                Expanded(
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 10, left: 16, right: 16, bottom: 16),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.92),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        )
                      ]
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '#${_detail.id.toString().padLeft(3, '0')}',
                            style: TextStyle(fontSize: 20, color: Colors.grey.shade600, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 16),
                          
                          Wrap(
                            spacing: 12,
                            children: _detail.types.map((type) {
                              return Chip(
                                label: Text(
                                  type.toUpperCase(),
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                                backgroundColor: _getTypeColor(type),
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 30),
                          
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildInfoItem('Weight', '${(_detail.weight / 10).toStringAsFixed(1)} kg'),
                              Container(height: 40, width: 1, color: Colors.grey.shade300),
                              _buildInfoItem('Height', '${(_detail.height / 10).toStringAsFixed(1)} m'),
                            ],
                          ),
                          const SizedBox(height: 30),
                          
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Base Stats', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(height: 16),
                          
                          ..._detail.stats.entries.map((e) => _buildStatRow(e.key, e.value)).toList(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String title, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Text(title, style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
      ],
    );
  }

  Widget _buildStatRow(String statName, int statValue) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              statName.toUpperCase(),
              style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(
            width: 40,
            child: Text(
              statValue.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: statValue / 150,
                minHeight: 10,
                backgroundColor: Colors.grey.shade200,
                color: statValue > 70 ? Colors.green : (statValue > 40 ? Colors.orange : Colors.red),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
