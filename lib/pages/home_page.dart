// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokedex/controllers/home_page_controller.dart';
import 'package:pokedex/models/page_data.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:pokedex/providers/pokemon_data_provider.dart';
import 'package:pokedex/widgets/pokemon_card.dart';
import 'package:pokedex/widgets/pokemon_list_tile.dart';

final homePageControllerProvider =
    StateNotifierProvider<HomePageController, HomePageData>((ref) {
  return HomePageController(HomePageData.initial());
});

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final _pokemonListScrollController = ScrollController();
  late HomePageController _homePageController;
  late HomePageData _homePageData;
  late List<String> _favouritePokemons;

  @override
  void initState() {
    super.initState();
    _pokemonListScrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _pokemonListScrollController.removeListener(_scrollListener);
    _pokemonListScrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_pokemonListScrollController.offset >=
            _pokemonListScrollController.position.maxScrollExtent * 1 &&
        !_pokemonListScrollController.position.outOfRange) {
      _homePageController.loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    _homePageController = ref.watch(homePageControllerProvider.notifier);
    _homePageData = ref.watch(homePageControllerProvider);
    _favouritePokemons = ref.watch(favouritePokemonsProvider);
    return Scaffold(
      body: _buildUi(context),
    );
  }

  Widget _buildUi(BuildContext context) {
    double getWidth = MediaQuery.sizeOf(context).width;
    double getHeight = MediaQuery.sizeOf(context).height;
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          width: getWidth,
          padding: EdgeInsets.symmetric(
            horizontal: getWidth * 0.02,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _favouritePokemonsList(context),
              _allPokemonList(context)
            ],
          ),
        ),
      ),
    );
  }

  Widget _favouritePokemonsList(BuildContext context) {
    double getWidth = MediaQuery.sizeOf(context).width;
    double getHeight = MediaQuery.sizeOf(context).height;
    return SizedBox(
      width: getWidth,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Favourite Pokemons",
            style: TextStyle(
              fontSize: 25,
            ),
          ),
          SizedBox(
            height: getHeight * 0.50,
            width: getWidth,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (_favouritePokemons.isNotEmpty)
                  SizedBox(
                    height: getHeight * 0.48,
                    child: GridView.builder(
                      scrollDirection: Axis.horizontal,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                      itemCount: _favouritePokemons.length,
                      itemBuilder: (context, index) {
                        return PokemonCard(
                          pokemonURL: _favouritePokemons[index],
                        );
                      },
                    ),
                  ),
                if (_favouritePokemons.isEmpty) const SizedBox.shrink()
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _allPokemonList(BuildContext context) {
    double getWidth = MediaQuery.sizeOf(context).width;
    double getHeight = MediaQuery.sizeOf(context).height;
    return SizedBox(
      width: getWidth,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "All Pokemons",
            style: TextStyle(
              fontSize: 25,
            ),
          ),
          SizedBox(
            height: getHeight * 0.60,
            child: ListView.builder(
              controller: _pokemonListScrollController,
              itemCount: _homePageData.data?.results?.length ?? 0,
              itemBuilder: (context, index) {
                PokemonListResult pokemon = _homePageData.data!.results![index];
                return PokemonListTile(
                  pokemonURL: pokemon.url ?? "",
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
