import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/pokemon.dart';
import '../services/api_service.dart';
import '../data/pokemon_data.dart';

class PokemonProvider with ChangeNotifier {
  final SharedPreferences _prefs;
  final ApiService _apiService = ApiService();
  
  List<PokemonDetail> _pokemonList = [];
  bool _isLoading = false;
  bool _hasError = false;
  int _offset = 0;
  final int _limit = 20;
  
  List<String> _favorites = [];
  List<PokemonDetail> _favoriteDetails = [];
  
  List<String> _allPokemonNames = [];

  String _currentType = 'All';
  String get currentType => _currentType;
  List<String> get allPokemonNames => _allPokemonNames;

  List<String> _filteredTypeNames = [];

  PokemonProvider(this._prefs) {
    _loadFavorites();
    _loadAllNames();
    loadPokemonList();
  }

  List<PokemonDetail> get pokemonList => _pokemonList;
  List<PokemonDetail> get favoriteDetails => _favoriteDetails;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  List<String> get favorites => _favorites;

  Future<void> _loadFavorites() async {
    _favorites = _prefs.getStringList('favorites') ?? [];
    notifyListeners();
    
    // Background load the full details of saved favorites so they are always available
    for (String idStr in _favorites) {
      try {
        final detail = await _apiService.getPokemonDetail(idStr);
        if (!_favoriteDetails.any((p) => p.id == detail.id)) {
          _favoriteDetails.add(detail);
        }
      } catch (e) {
        // Silently ignore if a favorite fails to load
      }
    }
    notifyListeners();
  }

  Future<void> _loadAllNames() async {
    _allPokemonNames = await _apiService.getAllPokemonNames();
    notifyListeners();
  }

  void setTypeFilter(String type) async {
    if (_currentType == type) return;
    _currentType = type;
    _pokemonList.clear();
    _offset = 0;
    _hasError = false;
    
    if (type == 'All') {
      _filteredTypeNames.clear();
      await loadPokemonList();
    } else if (type == 'Legendary') {
      _isLoading = true;
      notifyListeners();
      _filteredTypeNames = legendaryPokemon;
      await loadPokemonList();
    } else if (type == 'Mythical') {
      _isLoading = true;
      notifyListeners();
      _filteredTypeNames = mythicalPokemon;
      await loadPokemonList();
    } else {
      _isLoading = true;
      notifyListeners();
      try {
         _filteredTypeNames = await _apiService.getPokemonNamesByType(type.toLowerCase());
         await loadPokemonList();
      } catch (e) {
         _hasError = true;
         _isLoading = false;
         notifyListeners();
      }
    }
  }

  Future<void> loadPokemonList() async {
    if (_isLoading && _offset != 0) return;
    _isLoading = true;
    _hasError = false;
    notifyListeners();

    try {
      if (_currentType == 'All') {
         final newItems = await _apiService.getPokemonList(_offset, _limit);
         _pokemonList.addAll(newItems);
         _offset += _limit;
      } else {
         if (_offset >= _filteredTypeNames.length) {
            _isLoading = false;
            notifyListeners();
            return;
         }
         int end = (_offset + _limit < _filteredTypeNames.length) ? _offset + _limit : _filteredTypeNames.length;
         final namesToFetch = _filteredTypeNames.sublist(_offset, end);
         
         final details = await Future.wait(
           namesToFetch.map((name) => _apiService.getPokemonDetail(name))
         );
         _pokemonList.addAll(details);
         _offset = end;
      }
    } catch (e) {
      _hasError = true;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void toggleFavorite(PokemonDetail pokemon) {
    final idStr = pokemon.id.toString();
    if (_favorites.contains(idStr)) {
      _favorites.remove(idStr);
      _favoriteDetails.removeWhere((p) => p.id == pokemon.id);
    } else {
      _favorites.add(idStr);
      if (!_favoriteDetails.any((p) => p.id == pokemon.id)) {
        _favoriteDetails.add(pokemon);
      }
    }
    _prefs.setStringList('favorites', _favorites);
    notifyListeners();
  }

  bool isFavorite(int id) {
    return _favorites.contains(id.toString());
  }
}
