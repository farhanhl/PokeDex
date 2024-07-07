import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokedex/providers/pokemon_data_provider.dart';

class PokemonStatsDialog extends ConsumerWidget {
  late String pokemonURL;
  PokemonStatsDialog({
    super.key,
    required this.pokemonURL,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pokemon = ref.watch(
      pokemonDataProvider(pokemonURL),
    );
    return AlertDialog(
      title: const Text("Statistics"),
      content: pokemon.when(
        data: (data) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: data?.stats?.map((s) {
                  return Text(
                    "${s.stat?.name?.toUpperCase()}: ${s.baseStat}",
                  );
                }).toList() ??
                [],
          );
        },
        error: (error, stackTrace) => Text("Error: $error"),
        loading: () => const CircularProgressIndicator(
          color: Colors.white,
        ),
      ),
    );
  }
}
