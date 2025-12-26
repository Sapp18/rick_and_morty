import 'package:rick_and_morty/features/characteres/domain/entities/characters_result.dart';
import 'package:rick_and_morty/features/characteres/domain/repositories/characters_repository.dart';

class GetCharactersUseCase {
  final CharactersRepository repository;

  GetCharactersUseCase(this.repository);

  Future<CharactersResult> call({required int page, String? name}) {
    return repository.getCharacters(page: page, name: name);
  }
}
