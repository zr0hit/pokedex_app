import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pokemon_provider.dart';
import '../widgets/pokemon_card.dart';
import '../services/api_service.dart';
import 'detail_screen.dart';
import 'favorites_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  String _searchQuery = '';

  final List<String> _types = [
    'All', 'Normal', 'Fire', 'Water', 'Electric', 'Grass', 'Ice', 
    'Fighting', 'Poison', 'Ground', 'Flying', 'Psychic', 'Bug', 
    'Rock', 'Ghost', 'Dragon', 'Dark', 'Steel', 'Fairy'
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      context.read<PokemonProvider>().loadPokemonList();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildPokemonTitle() {
    return Stack(
      children: [
        Text(
          'Pokédex',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            letterSpacing: 3,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 5
              ..color = Colors.blue.shade800,
          ),
        ),
        Text(
          'Pokédex',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            letterSpacing: 3,
            color: Colors.yellowAccent.shade400,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    int crossAxisCount = (MediaQuery.of(context).size.width / 220).floor();
    if (crossAxisCount < 2) crossAxisCount = 2;

    return Scaffold(
      appBar: AppBar(
        title: _buildPokemonTitle(),
        backgroundColor: Colors.red.shade600,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FavoritesScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Autocomplete<String>(
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text == '') {
                      return const Iterable<String>.empty();
                    }
                    return context.read<PokemonProvider>().allPokemonNames.where((String option) {
                      return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
                    }).take(5);
                  },
                  onSelected: (String selection) async {
                    showDialog(
                      context: context, 
                      barrierDismissible: false,
                      builder: (_) => const Center(child: CircularProgressIndicator()),
                    );
                    try {
                      final detail = await ApiService().getPokemonDetail(selection);
                      if (context.mounted) {
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (_) => DetailScreen(pokemonItem: detail)));
                      }
                    } catch (e) {
                      if (context.mounted) Navigator.pop(context);
                    }
                  },
                  optionsViewBuilder: (context, onSelected, options) {
                    return Align(
                      alignment: Alignment.topLeft,
                      child: Material(
                        elevation: 4.0,
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          width: MediaQuery.of(context).size.width - 32,
                          constraints: const BoxConstraints(maxHeight: 250),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: options.length,
                            itemBuilder: (BuildContext context, int index) {
                              final String option = options.elementAt(index);
                              return ListTile(
                                leading: const Icon(Icons.search, color: Colors.grey),
                                title: Text(option.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold)),
                                onTap: () => onSelected(option),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                  fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                    return TextField(
                      controller: controller,
                      focusNode: focusNode,
                      decoration: InputDecoration(
                        hintText: 'Search any Pokémon globally...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value.toLowerCase();
                        });
                      },
                    );
                  },
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 40,
                  child: Consumer<PokemonProvider>(
                    builder: (context, provider, child) {
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _types.length,
                        itemBuilder: (context, index) {
                          final type = _types[index];
                          final isSelected = provider.currentType == type;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: FilterChip(
                              label: Text(type),
                              selected: isSelected,
                              selectedColor: Colors.red.shade100,
                              onSelected: (selected) {
                                provider.setTypeFilter(type);
                              },
                            ),
                          );
                        },
                      );
                    }
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<PokemonProvider>(
              builder: (context, provider, child) {
                final filteredList = provider.pokemonList.where((p) {
                  return p.name.toLowerCase().contains(_searchQuery);
                }).toList();

                if (provider.pokemonList.isEmpty && provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (provider.hasError && provider.pokemonList.isEmpty) {
                  return Center(
                    child: ElevatedButton(
                      onPressed: () => provider.loadPokemonList(),
                      child: const Text('Retry'),
                    ),
                  );
                }

                return GridView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: filteredList.length + (provider.isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == filteredList.length) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final pokemon = filteredList[index];
                    return PokemonCard(pokemon: pokemon);
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
