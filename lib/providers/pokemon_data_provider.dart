import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:pokedex/services/database_service.dart';
import 'package:pokedex/services/http_service.dart';

final pokemonDataProvider =
    FutureProvider.family<Pokemon?, String>((ref, url) async {
  HTTPService _httpService = GetIt.instance.get<HTTPService>();
  Response? res = await _httpService.getPokemons(url);
  if (res != null && res.data != null) {
    return Pokemon.fromJson(res.data);
  }
  return null;
});

final favouritePokemonsProvider =
    StateNotifierProvider<FavouritePokemonsProvider, List<String>>((ref) {
  return FavouritePokemonsProvider([]);
});

class FavouritePokemonsProvider extends StateNotifier<List<String>> {
  final DatabaseService _databaseService =
      GetIt.instance.get<DatabaseService>();

  final FAVOURITE_POKEMON_LIST_KEY = "FAVOURITE_POKEMON_LIST_KEY";
  FavouritePokemonsProvider(super._state) {
    _setup();
  }

  Future<void> _setup() async {
    List<String>? result =
        await _databaseService.getList(FAVOURITE_POKEMON_LIST_KEY);
    state = result ?? [];
  }

  void addFavouritePokemon(String url) {
    state = [...state, url];
    _databaseService.saveList(FAVOURITE_POKEMON_LIST_KEY, state);
  }

  void removePokemon(String url) {
    state = state.where((e) => e != url).toList();
    _databaseService.saveList(FAVOURITE_POKEMON_LIST_KEY, state);
  }
}
