import 'package:sqflite/sqflite.dart';

class FavoritesLocalDataSource {
  final Database db;

  FavoritesLocalDataSource(this.db);

  Future<void> toggleFavorite(int characterId) async {
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
  }

  Future<List<int>> getFavoritesIds() async {
    final result = await db.query('favorites');
    return result.map((e) => e['id'] as int).toList();
  }
}
