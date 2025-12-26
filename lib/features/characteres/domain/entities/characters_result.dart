import 'package:rick_and_morty/features/characteres/domain/entities/character.dart';

class CharactersResult {
  final List<Character> characters;
  final bool hasReachedMax;

  CharactersResult({required this.characters, required this.hasReachedMax});
}
