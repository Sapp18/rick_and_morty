import 'package:rick_and_morty/core/error/exceptions.dart';
import 'package:rick_and_morty/core/error/failures.dart';
import 'package:rick_and_morty/features/characteres/data/datasources/favorites_local_datasource.dart';
import 'package:rick_and_morty/features/characteres/domain/repositories/favorites_repository.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesLocalDataSource local;

  FavoritesRepositoryImpl(this.local);

  @override
  Future<void> toggleFavorite(int characterId) async {
    try {
      await local.toggleFavorite(characterId);
    } on CacheException catch (e) {
      throw CacheFailure.fromException(e);
    } catch (e) {
      throw CacheFailure(
        'Error inesperado al actualizar favorito: ${e.toString()}',
        code: 'UNEXPECTED_ERROR',
      );
    }
  }

  @override
  Future<List<int>> getFavoritesIds() async {
    try {
      return await local.getFavoritesIds();
    } on CacheException catch (e) {
      throw CacheFailure.fromException(e);
    } catch (e) {
      throw CacheFailure(
        'Error inesperado al obtener favoritos: ${e.toString()}',
        code: 'UNEXPECTED_ERROR',
      );
    }
  }

  @override
  Future<bool> isFavorite(int characterId) async {
    try {
      return await local.isFavorite(characterId);
    } on CacheException catch (e) {
      throw CacheFailure.fromException(e);
    } catch (e) {
      throw CacheFailure(
        'Error inesperado al verificar favorito: ${e.toString()}',
        code: 'UNEXPECTED_ERROR',
      );
    }
  }
}

