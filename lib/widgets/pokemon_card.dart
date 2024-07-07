import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:pokedex/providers/pokemon_data_provider.dart';
import 'package:pokedex/widgets/pokemon_stats_dialog.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PokemonCard extends ConsumerWidget {
  final String pokemonURL;
  PokemonCard({
    super.key,
    required this.pokemonURL,
  });
  late FavouritePokemonsProvider _favouritePokemonsProvider;
  late List<String> _favouritePokemons;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pokemon = ref.watch(
      pokemonDataProvider(pokemonURL),
    );
    _favouritePokemonsProvider = ref.watch(favouritePokemonsProvider.notifier);
    return pokemon.when(
      data: (data) {
        return _card(context, false, data);
      },
      error: (error, stackTrace) => Text("Error: $error"),
      loading: () {
        return _card(context, true, null);
      },
    );
  }

  Widget _card(
    BuildContext context,
    bool isLoading,
    Pokemon? pokemon,
  ) {
    double getWidth = MediaQuery.sizeOf(context).width;
    double getHeight = MediaQuery.sizeOf(context).height;
    return Skeletonizer(
      enabled: isLoading,
      child: GestureDetector(
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
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: getWidth * 0.03,
            vertical: getHeight * 0.01,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: getWidth * 0.03,
            vertical: getHeight * 0.01,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    pokemon?.name?.toUpperCase() ?? "",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "#${pokemon?.id}",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: CircleAvatar(
                  radius: getHeight * 0.06,
                  backgroundImage:
                      NetworkImage(pokemon?.sprites?.frontDefault ?? ""),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Has ${pokemon?.moves?.length ?? 0} moves",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _favouritePokemonsProvider.removePokemon(pokemonURL);
                    },
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
