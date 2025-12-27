import 'package:rick_and_morty/core/error/exceptions.dart';
import 'package:rick_and_morty/core/error/failures.dart';
import 'package:rick_and_morty/features/detail_characters/data/datasources/detail_characters_remote_datasource.dart';
import 'package:rick_and_morty/features/detail_characters/domain/entities/detail_character.dart';
import 'package:rick_and_morty/features/detail_characters/domain/repositories/detail_characters_repository.dart';

class DetailCharactersRepositoryImpl implements DetailCharactersRepository {
  final DetailCharactersRemoteDataSource remote;

  DetailCharactersRepositoryImpl(this.remote);

  @override
  Future<DetailCharacter> getDetailCharacter(int id) async {
    try {
      // El datasource ya retorna DetailCharacterModel validado
      final model = await remote.getDetailCharacter(id);

      return model.toEntity();
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
        'Error inesperado: ${e.toString()}',
        code: 'UNEXPECTED_ERROR',
      );
    }
  }
}
