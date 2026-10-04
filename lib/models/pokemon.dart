class PokemonListItem {
  final String name;
  final String url;
  final int id;
  
  PokemonListItem({required this.name, required this.url, required this.id});

  factory PokemonListItem.fromJson(Map<String, dynamic> json) {
    final url = json['url'] as String;
    final parts = url.split('/');
    final id = int.parse(parts[parts.length - 2]);
    return PokemonListItem(
      name: json['name'],
      url: url,
      id: id,
    );
  }
  
  String get imageUrl => 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';
}

class PokemonDetail {
  final int id;
  final String name;
  final int height;
  final int weight;
  final List<String> types;
  final List<String> abilities;
  final Map<String, int> stats;

  PokemonDetail({
    required this.id,
    required this.name,
    required this.height,
    required this.weight,
    required this.types,
    required this.abilities,
    required this.stats,
  });

  factory PokemonDetail.fromJson(Map<String, dynamic> json) {
    List<String> types = (json['types'] as List).map((t) => t['type']['name'] as String).toList();
    List<String> abilities = (json['abilities'] as List).map((a) => a['ability']['name'] as String).toList();
    
    Map<String, int> stats = {};
    for (var stat in json['stats']) {
      stats[stat['stat']['name']] = stat['base_stat'];
    }

    return PokemonDetail(
      id: json['id'],
      name: json['name'],
      height: json['height'],
      weight: json['weight'],
      types: types,
      abilities: abilities,
      stats: stats,
    );
  }
  
  String get imageUrl => 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';
}
