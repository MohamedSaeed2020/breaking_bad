import 'package:breaking_bad/business_logic/characters_cubit.dart';
import 'package:breaking_bad/constants/strings.dart';
import 'package:breaking_bad/data/models/characters.dart';
import 'package:breaking_bad/data/repositories/characters_repositories.dart';
import 'package:breaking_bad/data/web_services/characters_web_services.dart';
import 'package:breaking_bad/presentation/screens/characters_details_screen.dart';
import 'package:breaking_bad/presentation/screens/characters_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRouter {
  late CharactersRepositories charactersRepositories;
  late CharactersCubit charactersCubit;

  AppRouter() {
    charactersRepositories = CharactersRepositories(CharactersWebServices());
    charactersCubit = CharactersCubit(charactersRepositories);
  }

  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case charactersScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => charactersCubit,
            child: CharactersScreen(),
          ),
        );
      case charactersDetailsScreen:
        final Character selectedCharacter = settings.arguments as Character;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => CharactersCubit(charactersRepositories),
            child: CharacterDetailsScreen(character: selectedCharacter),
          ),
        );
    }
  }
}
