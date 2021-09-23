import 'package:breaking_bad/data/models/characters.dart';
import 'package:breaking_bad/data/models/quote.dart';
import 'package:breaking_bad/data/web_services/characters_web_services.dart';

class CharactersRepositories {
  final CharactersWebServices charactersWebServices;

  CharactersRepositories(this.charactersWebServices);

  Future<List<Character>> getAllCharacters() async {
    final characters = await charactersWebServices.getAllCharacters();
    return characters
        .map((character) => Character.fromJson(character))
        .toList();
  }

  Future<List<Quote>> getCharactersQuote(String charName) async {
    final quotes = await charactersWebServices.getCharactersQuotes(charName);
    return quotes
        .map((quote) => Quote.fromJson(quote))
        .toList();
  }
}
