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
  late bool _isImageOnLeft;

  @override
  void initState() {
    super.initState();
    _detail = widget.pokemonItem;
    // Deterministic random so the same pokemon always has the same side
    _isImageOnLeft = _detail.id % 2 == 0;
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

  Widget _buildImageSection(bool isDesktop) {
    return Expanded(
      flex: 1,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Hero(
            tag: 'pokemon-${_detail.id}',
            child: Image.network(
              _detail.imageUrl,
              fit: BoxFit.contain,
              width: double.infinity, // allow it to grow large
              height: isDesktop ? double.infinity : 220,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const CircularProgressIndicator(color: Colors.white);
              },
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.error, color: Colors.white, size: 100),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailsSection(bool isDesktop) {
    return Expanded(
      flex: 1,
      child: Container(
        margin: EdgeInsets.all(isDesktop ? 32 : 16),
        padding: EdgeInsets.all(isDesktop ? 40 : 24),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.92),
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 10),
            )
          ]
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '#${_detail.id.toString().padLeft(3, '0')}',
                style: TextStyle(fontSize: isDesktop ? 28 : 20, color: Colors.grey.shade600, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),
              
              Wrap(
                spacing: 16,
                children: _detail.types.map((type) {
                  return Chip(
                    label: Text(
                      type.toUpperCase(),
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: isDesktop ? 18 : 14),
                    ),
                    backgroundColor: _getTypeColor(type),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  );
                }).toList(),
              ),
              SizedBox(height: isDesktop ? 40 : 30),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildInfoItem('Weight', '${(_detail.weight / 10).toStringAsFixed(1)} kg', isDesktop),
                  Container(height: isDesktop ? 60 : 40, width: 2, color: Colors.grey.shade300),
                  _buildInfoItem('Height', '${(_detail.height / 10).toStringAsFixed(1)} m', isDesktop),
                ],
              ),
              SizedBox(height: isDesktop ? 40 : 30),
              
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Base Stats', style: TextStyle(fontSize: isDesktop ? 26 : 22, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 20),
              
              ..._detail.stats.entries.map((e) => _buildStatRow(e.key, e.value, isDesktop)).toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(String title, String value, bool isDesktop) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: isDesktop ? 24 : 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(title, style: TextStyle(color: Colors.grey.shade600, fontSize: isDesktop ? 16 : 14)),
      ],
    );
  }

  Widget _buildStatRow(String statName, int statValue, bool isDesktop) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          SizedBox(
            width: isDesktop ? 120 : 100,
            child: Text(
              statName.toUpperCase(),
              style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.w600, fontSize: isDesktop ? 16 : 14),
            ),
          ),
          SizedBox(
            width: isDesktop ? 50 : 40,
            child: Text(
              statValue.toString(),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: isDesktop ? 18 : 16),
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: statValue / 150,
                minHeight: isDesktop ? 14 : 10,
                backgroundColor: Colors.grey.shade200,
                color: statValue > 70 ? Colors.green : (statValue > 40 ? Colors.orange : Colors.red),
              ),
            ),
          ),
        ],
      ),
    );
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
            child: Container(color: Colors.black.withOpacity(0.5)), // Slightly darker overlay for contrast
          ),
          
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white, size: 36),
                        onPressed: () => Navigator.pop(context),
                      ),
                      PokemonText(
                        text: _detail.name.toUpperCase(),
                        type: primaryType,
                        fontSize: 36,
                        strokeWidth: 6,
                        letterSpacing: 4,
                      ),
                      Consumer<PokemonProvider>(
                        builder: (context, provider, child) {
                          final isFav = provider.isFavorite(_detail.id);
                          return IconButton(
                            icon: Icon(
                              isFav ? Icons.favorite : Icons.favorite_border,
                              color: isFav ? Colors.redAccent : Colors.white,
                              size: 36,
                            ),
                            onPressed: () => provider.toggleFavorite(_detail.id),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                
                // Responsive Layout
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      bool isDesktop = constraints.maxWidth > 800;
                      
                      if (isDesktop) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: _isImageOnLeft
                              ? [_buildImageSection(true), _buildDetailsSection(true)]
                              : [_buildDetailsSection(true), _buildImageSection(true)],
                        );
                      } else {
                        // Mobile fallback (Always Image top, details bottom)
                        return Column(
                          children: [
                            _buildImageSection(false),
                            _buildDetailsSection(false),
                          ],
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
