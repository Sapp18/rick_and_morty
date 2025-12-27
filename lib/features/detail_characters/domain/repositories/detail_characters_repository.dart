import 'package:rick_and_morty/features/detail_characters/domain/entities/detail_character.dart';

abstract class DetailCharactersRepository {
  Future<DetailCharacter> getDetailCharacter(int id);
}
