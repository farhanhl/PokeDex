import 'package:flutter/material.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:pokedex/widgets/pokemon_stats_dialog.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokedex/providers/pokemon_data_provider.dart';

class PokemonListTile extends ConsumerWidget {
  final String pokemonURL;
  late List<String> _favouritePokemons;
  PokemonListTile({super.key, required this.pokemonURL});
  late FavouritePokemonsProvider _favouritePokemonsProvider;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _favouritePokemonsProvider = ref.watch(favouritePokemonsProvider.notifier);
    _favouritePokemons = ref.watch(favouritePokemonsProvider);
    final pokemon = ref.watch(pokemonDataProvider(pokemonURL));
    return pokemon.when(
      data: (data) {
        return _tile(context, false, data);
      },
      error: (error, stackTrace) => Text("Error: $error"),
      loading: () {
        return _tile(context, true, null);
      },
    );
  }

  Widget _tile(
    BuildContext context,
    bool isLoading,
    Pokemon? pokemon,
  ) {
    return Skeletonizer(
      enabled: isLoading,
      child: ListTile(
        onTap: () {
          if (!isLoading) {
            showDialog(
              context: context,
              builder: (context) {
                return PokemonStatsDialog(
                  pokemonURL: pokemonURL,
                );
              },
            );
          }
        },
        leading: CircleAvatar(
          backgroundImage: NetworkImage(pokemon?.sprites?.frontDefault ?? ""),
        ),
        title: Text(pokemon?.name?.toUpperCase() ?? ""),
        subtitle: Text("Has ${pokemon?.moves?.length ?? 0} moves"),
        trailing: IconButton(
          onPressed: () {
            _favouritePokemons.contains(pokemonURL)
                ? _favouritePokemonsProvider.removePokemon(pokemonURL)
                : _favouritePokemonsProvider.addFavouritePokemon(pokemonURL);
          },
          icon: Icon(
            _favouritePokemons.contains(pokemonURL)
                ? Icons.favorite
                : Icons.favorite_border,
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}
