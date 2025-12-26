import 'package:rick_and_morty/features/characteres/data/models/all_characters_model.dart';
import 'package:rick_and_morty/features/characteres/domain/entities/character.dart';
import 'package:rick_and_morty/features/characteres/domain/entities/characters_result.dart';
import 'package:rick_and_morty/features/characteres/domain/repositories/characters_repository.dart';
import 'package:rick_and_morty/features/characteres/data/datasources/characters_remote_datasource.dart';

class CharactersRepositoryImpl implements CharactersRepository {
  final CharactersRemoteDataSource remote;

  CharactersRepositoryImpl(this.remote);

  @override
  Future<CharactersResult> getCharacters({
    required int page,
    String? name,
  }) async {
    final response = await remote.getCharacters(page: page, name: name);

    final characters = (response.results ?? [])
        .map(
          (Result model) => Character(
            id: model.id ?? 0,
            name: model.name ?? '',
            image: model.image ?? '',
            species: model.species ?? '',
            status: model.status?.name ?? 'unknown',
            origin: model.origin?.name ?? 'unknown',
          ),
        )
        .toList();

    return CharactersResult(
      characters: characters,
      hasReachedMax: response.info?.next == null,
    );
  }
}
