import 'package:bloc/bloc.dart';
import 'package:breaking_bad/data/models/characters.dart';
import 'package:breaking_bad/data/models/quote.dart';
import 'package:breaking_bad/data/repositories/characters_repositories.dart';
import 'package:meta/meta.dart';

part 'characters_state.dart';

class CharactersCubit extends Cubit<CharactersState> {
  final CharactersRepositories charactersRepositories;
   List<Character> characters=[];

  CharactersCubit(this.charactersRepositories) : super(CharactersInitial());

  List<Character> getAllCharacters() {
    charactersRepositories.getAllCharacters().then((characters){
      emit(CharactersLoaded(characters));
      this.characters = characters;
        print('Cubit: ${characters[0].charName}');
    }).catchError((error){
      print("Error in cubit: $error");
    });
    return characters;
  }

  void getCharactersQuotes(String charName) {
    charactersRepositories.getCharactersQuote(charName).then((quotes){
      emit(QuotesLoaded(quotes));
    }).catchError((error){
      print("Error in cubit: $error");
    });
  }
}
