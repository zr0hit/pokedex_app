import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pokemon.dart';

class ApiService {
  static const String baseUrl = 'https://pokeapi.co/api/v2';

  Future<List<PokemonDetail>> getPokemonList(int offset, int limit) async {
    final response = await http.get(Uri.parse('$baseUrl/pokemon?limit=$limit&offset=$offset'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List results = data['results'];
      
      final details = await Future.wait(
        results.map((json) => getPokemonDetail(json['name'] as String))
      );
      return details;
    } else {
      throw Exception('Failed to load pokemon list');
    }
  }

  Future<List<String>> getPokemonNamesByType(String type) async {
    final response = await http.get(Uri.parse('$baseUrl/type/$type'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List pokemonList = data['pokemon'];
      return pokemonList.map((p) => p['pokemon']['name'] as String).toList();
    } else {
      throw Exception('Failed to load type');
    }
  }

  Future<List<String>> getAllPokemonNames() async {
    final response = await http.get(Uri.parse('$baseUrl/pokemon?limit=10000'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List results = data['results'];
      return results.map((p) => p['name'] as String).toList();
    }
    return [];
  }

  Future<PokemonDetail> getPokemonDetail(String idOrName) async {
    final response = await http.get(Uri.parse('$baseUrl/pokemon/$idOrName'));
    if (response.statusCode == 200) {
      return PokemonDetail.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load pokemon details');
    }
  }
}
