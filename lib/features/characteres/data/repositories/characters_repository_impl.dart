import 'package:rick_and_morty/core/error/exceptions.dart';
import 'package:rick_and_morty/core/error/failures.dart';
import 'package:rick_and_morty/features/characteres/data/models/all_characters_model.dart';
import 'package:rick_and_morty/features/characteres/data/models/character_model.dart';
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
    try {
      final response = await remote.getCharacters(page: page, name: name);

      // Validar que la respuesta tenga datos
      if (response.results == null || response.results!.isEmpty) {
        return CharactersResult(characters: [], hasReachedMax: true);
      }

      // Mapear usando el CharacterModel con validaciones estrictas
      final characters = response.results!
          .map((Result apiResult) {
            try {
              // Validar que los campos esenciales no sean null antes de mapear
              if (apiResult.id == null) {
                throw const ValidationException(
                  'Character id is null',
                  code: 'NULL_ID',
                );
              }

              // Convertir el Result de la API a un Map para el CharacterModel
              // CharacterModel.fromJson manejará las validaciones adicionales
              final jsonMap = {
                'id': apiResult.id,
                'name':
                    apiResult.name ??
                    '', // CharacterModel validará si está vacío
                'image':
                    apiResult.image ??
                    '', // CharacterModel validará si está vacío
                'species':
                    apiResult.species ??
                    '', // CharacterModel validará si está vacío
                'status': apiResult.status?.name ?? 'unknown',
                'origin': apiResult.origin?.toJson() ?? {'name': 'unknown'},
              };

              // Usar CharacterModel que tiene validaciones estrictas
              return CharacterModel.fromJson(jsonMap);
            } on ValidationException catch (e) {
              // Log del error pero continuar con otros personajes
              // En producción, podrías querer usar un logger apropiado
              print(
                'Error parsing character (id: ${apiResult.id}): ${e.message}',
              );
              return null;
            } catch (e) {
              print(
                'Unexpected error parsing character (id: ${apiResult.id}): $e',
              );
              return null;
            }
          })
          .whereType<CharacterModel>() // Filtrar nulls
          .map((model) => model.toEntity())
          .toList();

      // Validar que al menos algunos personajes se parsearon correctamente
      if (characters.isEmpty && response.results!.isNotEmpty) {
        throw const ValidationException(
          'Failed to parse any characters from the response',
          code: 'PARSE_FAILURE',
        );
      }

      return CharactersResult(
        characters: characters,
        hasReachedMax: response.info?.next == null,
      );
    } on ServerException catch (e) {
      throw ServerFailure.fromException(e);
    } on NetworkException catch (e) {
      throw NetworkFailure.fromException(e);
    } on ValidationException catch (e) {
      throw ValidationFailure.fromException(e);
    } on CacheException catch (e) {
      throw CacheFailure.fromException(e);
    } catch (e) {
      throw ServerFailure(
        'Unexpected error: ${e.toString()}',
        code: 'UNEXPECTED_ERROR',
      );
    }
  }
}
