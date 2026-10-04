import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/pokemon.dart';
import '../providers/pokemon_provider.dart';
import '../widgets/pokemon_text.dart';
import '../widgets/dynamic_background.dart';
import '../widgets/animated_details_card.dart';
import '../widgets/pokeball_loading.dart';

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
      flex: 3, 
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(isDesktop ? 24.0 : 16.0),
          child: Hero(
            tag: 'pokemon-${_detail.id}',
            child: Image.network(
              _detail.imageUrl,
              fit: BoxFit.contain,
              width: double.infinity,
              height: double.infinity, 
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const PokeballLoading(color: Colors.white, size: 60);
              },
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.error, color: Colors.white, size: 100),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailsSection(bool isDesktop) {
    String primaryType = _detail.types.isNotEmpty ? _detail.types.first : 'normal';
    String secondaryType = _detail.types.length > 1 ? _detail.types[1] : primaryType;
    Color c1 = _getTypeColor(primaryType);
    Color c2 = _getTypeColor(secondaryType);

    return Expanded(
      flex: 4,
      child: AnimatedDetailsCard(
        pokemon: _detail,
        color1: c1,
        color2: c2,
        isDesktop: isDesktop,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '#${_detail.id.toString().padLeft(3, '0')}',
                style: TextStyle(fontSize: isDesktop ? 28 : 20, color: Colors.white70, fontWeight: FontWeight.w600, letterSpacing: 2),
              ),
              const SizedBox(height: 16),
              
              Wrap(
                spacing: 12,
                children: _detail.types.map((type) {
                  return Chip(
                    label: Text(
                      type.toUpperCase(),
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: isDesktop ? 16 : 14),
                    ),
                    backgroundColor: _getTypeColor(type),
                    side: BorderSide.none,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  );
                }).toList(),
              ),
              SizedBox(height: isDesktop ? 30 : 20),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildInfoItem('Weight', '${(_detail.weight / 10).toStringAsFixed(1)} kg', isDesktop),
                  Container(height: isDesktop ? 60 : 40, width: 2, color: Colors.white24),
                  _buildInfoItem('Height', '${(_detail.height / 10).toStringAsFixed(1)} m', isDesktop),
                ],
              ),
              SizedBox(height: isDesktop ? 40 : 30),
              
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Base Stats', style: TextStyle(fontSize: isDesktop ? 26 : 22, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
              const SizedBox(height: 16),
              
              ..._detail.stats.entries.map((e) => _buildStatRow(e.key, e.value, isDesktop)).toList(),
              
              SizedBox(height: isDesktop ? 40 : 30),
              _buildWeaknessSection(isDesktop),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(String title, String value, bool isDesktop) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: isDesktop ? 24 : 20, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 8),
        Text(title, style: TextStyle(color: Colors.white60, fontSize: isDesktop ? 16 : 14)),
      ],
    );
  }

  Widget _buildStatRow(String statName, int statValue, bool isDesktop) {
    IconData statIcon;
    Color iconColor;
    String displayStatName = statName.toUpperCase();
    
    switch (statName.toLowerCase()) {
      case 'hp': statIcon = Icons.favorite; iconColor = Colors.redAccent; break;
      case 'attack': statIcon = Icons.sports_martial_arts; iconColor = Colors.orangeAccent; break;
      case 'defense': statIcon = Icons.shield; iconColor = Colors.blueAccent; break;
      case 'special-attack': statIcon = Icons.auto_awesome; iconColor = Colors.purpleAccent; displayStatName = 'SP. ATK'; break;
      case 'special-defense': statIcon = Icons.security; iconColor = Colors.lightBlueAccent; displayStatName = 'SP. DEF'; break;
      case 'speed': statIcon = Icons.directions_run; iconColor = Colors.greenAccent; break;
      default: statIcon = Icons.star; iconColor = Colors.white; break;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(statIcon, color: iconColor, size: isDesktop ? 24 : 20),
          const SizedBox(width: 8),
          SizedBox(
            width: isDesktop ? 90 : 80,
            child: Text(
              displayStatName,
              style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w600, fontSize: isDesktop ? 16 : 13),
            ),
          ),
          SizedBox(
            width: isDesktop ? 45 : 35,
            child: Text(
              statValue.toString(),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: isDesktop ? 18 : 16, color: Colors.white),
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: statValue / 150,
                minHeight: isDesktop ? 14 : 10,
                backgroundColor: Colors.white12, 
                color: statValue > 70 ? Colors.greenAccent : (statValue > 40 ? Colors.orangeAccent : Colors.redAccent),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeaknessSection(bool isDesktop) {
    String primaryType = _detail.types.isNotEmpty ? _detail.types.first.toLowerCase() : 'normal';
    
    List<String> weakAgainst = [];
    List<String> strongAgainst = [];
    
    switch (primaryType) {
      case 'fire': weakAgainst = ['water', 'ground', 'rock']; strongAgainst = ['grass', 'bug', 'ice', 'steel']; break;
      case 'water': weakAgainst = ['electric', 'grass']; strongAgainst = ['fire', 'ground', 'rock']; break;
      case 'grass': weakAgainst = ['fire', 'ice', 'poison', 'flying', 'bug']; strongAgainst = ['water', 'ground', 'rock']; break;
      case 'electric': weakAgainst = ['ground']; strongAgainst = ['water', 'flying']; break;
      case 'ice': weakAgainst = ['fire', 'fighting', 'rock', 'steel']; strongAgainst = ['grass', 'ground', 'flying', 'dragon']; break;
      case 'fighting': weakAgainst = ['flying', 'psychic', 'fairy']; strongAgainst = ['normal', 'ice', 'rock', 'dark', 'steel']; break;
      case 'poison': weakAgainst = ['ground', 'psychic']; strongAgainst = ['grass', 'fairy']; break;
      case 'ground': weakAgainst = ['water', 'grass', 'ice']; strongAgainst = ['fire', 'electric', 'poison', 'rock', 'steel']; break;
      case 'flying': weakAgainst = ['electric', 'ice', 'rock']; strongAgainst = ['grass', 'fighting', 'bug']; break;
      case 'psychic': weakAgainst = ['bug', 'ghost', 'dark']; strongAgainst = ['fighting', 'poison']; break;
      case 'bug': weakAgainst = ['fire', 'flying', 'rock']; strongAgainst = ['grass', 'psychic', 'dark']; break;
      case 'rock': weakAgainst = ['water', 'grass', 'fighting', 'ground', 'steel']; strongAgainst = ['fire', 'ice', 'flying', 'bug']; break;
      case 'ghost': weakAgainst = ['ghost', 'dark']; strongAgainst = ['psychic', 'ghost']; break;
      case 'dragon': weakAgainst = ['ice', 'dragon', 'fairy']; strongAgainst = ['dragon']; break;
      case 'dark': weakAgainst = ['fighting', 'bug', 'fairy']; strongAgainst = ['psychic', 'ghost']; break;
      case 'steel': weakAgainst = ['fire', 'fighting', 'ground']; strongAgainst = ['ice', 'rock', 'fairy']; break;
      case 'fairy': weakAgainst = ['poison', 'steel']; strongAgainst = ['fighting', 'dragon', 'dark']; break;
      case 'normal': weakAgainst = ['fighting']; strongAgainst = []; break;
      default: weakAgainst = ['fighting']; strongAgainst = []; break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (strongAgainst.isNotEmpty) ...[
          Align(
            alignment: Alignment.centerLeft,
            child: Text('Strong Against', style: TextStyle(fontSize: isDesktop ? 22 : 18, fontWeight: FontWeight.bold, color: Colors.greenAccent)),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: Wrap(
              spacing: 8, runSpacing: 8,
              children: strongAgainst.map((t) => _buildTypeChip(t, isDesktop)).toList(),
            ),
          ),
          SizedBox(height: isDesktop ? 24 : 16),
        ],
        Align(
          alignment: Alignment.centerLeft,
          child: Text('Weak Against', style: TextStyle(fontSize: isDesktop ? 22 : 18, fontWeight: FontWeight.bold, color: Colors.redAccent)),
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerLeft,
          child: Wrap(
            spacing: 8, runSpacing: 8,
            children: weakAgainst.map((t) => _buildTypeChip(t, isDesktop)).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildTypeChip(String type, bool isDesktop) {
    return Chip(
      label: Text(type.toUpperCase(), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: isDesktop ? 13 : 11)),
      backgroundColor: _getTypeColor(type).withOpacity(0.8),
      side: BorderSide(color: Colors.white.withOpacity(0.3)),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
    );
  }

  @override
  Widget build(BuildContext context) {
    String primaryType = _detail.types.isNotEmpty ? _detail.types.first : 'normal';
    String secondaryType = _detail.types.length > 1 ? _detail.types[1] : primaryType;
    String bgUrl = _getBackgroundImage(primaryType);

    Color c1 = _getTypeColor(primaryType);
    Color c2 = _getTypeColor(secondaryType);
    if (c1 == c2) {
      c2 = c1.withAlpha(100);
    }

    return Scaffold(
      body: Stack(
        children: [
          DynamicBackground(
            pokemon: _detail,
            bgUrl: bgUrl,
            typeColor1: c1,
            typeColor2: c2,
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
                        pokemonName: _detail.name,
                        fontSize: 32,
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
                              size: 36,
                            ),
                            onPressed: () => provider.toggleFavorite(_detail),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                
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
