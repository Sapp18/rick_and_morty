import 'package:rick_and_morty/features/characteres/domain/entities/character_filters.dart';
import 'package:rick_and_morty/features/characteres/domain/entities/characters_result.dart';

abstract class CharactersRepository {
  Future<CharactersResult> getCharacters({
    required int page,
    CharacterFilters? filters,
  });
}
