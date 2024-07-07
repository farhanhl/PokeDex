import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/pages/home_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokedex/services/database_service.dart';
import 'package:pokedex/services/http_service.dart';

void main() async {
  await _setupServices();
  runApp(const MainApp());
}

Future<void> _setupServices() async {
  GetIt.instance.registerSingleton<HTTPService>(
    HTTPService(),
  );
  GetIt.instance.registerSingleton<DatabaseService>(
    DatabaseService(),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "PokeDex",
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),
          textTheme: GoogleFonts.quattrocentoSansTextTheme(),
          useMaterial3: true,
        ),
        home: HomePage(),
      ),
    );
  }
}
