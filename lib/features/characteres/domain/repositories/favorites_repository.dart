abstract class FavoritesRepository {
  Future<void> toggleFavorite(int characterId);
  Future<List<int>> getFavoritesIds();
  Future<bool> isFavorite(int characterId);
}

