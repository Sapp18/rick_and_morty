import 'package:rick_and_morty/core/database/database_helper.dart';
import 'package:rick_and_morty/core/error/exceptions.dart';

abstract class FavoritesLocalDataSource {
  Future<void> toggleFavorite(int characterId);
  Future<List<int>> getFavoritesIds();
  Future<bool> isFavorite(int characterId);
}

class FavoritesLocalDataSourceImpl implements FavoritesLocalDataSource {
  final DatabaseHelper dbHelper;

  FavoritesLocalDataSourceImpl(this.dbHelper);

  @override
  Future<void> toggleFavorite(int characterId) async {
    try {
      final db = await dbHelper.database;
      final result = await db.query(
        'favorites',
        where: 'id = ?',
        whereArgs: [characterId],
      );

      if (result.isEmpty) {
        await db.insert('favorites', {'id': characterId});
      } else {
        await db.delete('favorites', where: 'id = ?', whereArgs: [characterId]);
      }
    } catch (e) {
      throw CacheException(
        'Error al actualizar favorito: ${e.toString()}',
        code: 'FAVORITE_TOGGLE_ERROR',
      );
    }
  }

  @override
  Future<List<int>> getFavoritesIds() async {
    try {
      final db = await dbHelper.database;
      final result = await db.query('favorites');
      return result.map((e) => e['id'] as int).toList();
    } catch (e) {
      throw CacheException(
        'Error al obtener favoritos: ${e.toString()}',
        code: 'FAVORITES_GET_ERROR',
      );
    }
  }

  @override
  Future<bool> isFavorite(int characterId) async {
    try {
      final db = await dbHelper.database;
      final result = await db.query(
        'favorites',
        where: 'id = ?',
        whereArgs: [characterId],
      );
      return result.isNotEmpty;
    } catch (e) {
      throw CacheException(
        'Error al verificar favorito: ${e.toString()}',
        code: 'FAVORITE_CHECK_ERROR',
      );
    }
  }
}

