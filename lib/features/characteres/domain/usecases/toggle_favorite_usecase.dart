import 'package:rick_and_morty/core/error/failures.dart';
import 'package:rick_and_morty/features/characteres/domain/repositories/favorites_repository.dart';

class ToggleFavoriteUseCase {
  final FavoritesRepository repository;

  ToggleFavoriteUseCase(this.repository);

  Future<void> call({required int characterId}) {
    if (characterId < 1) {
      throw const ValidationFailure(
        'El id del personaje debe ser mayor que 0',
        code: 'INVALID_ID',
      );
    }
    return repository.toggleFavorite(characterId);
  }
}

