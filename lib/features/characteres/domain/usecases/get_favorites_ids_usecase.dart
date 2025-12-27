import 'package:rick_and_morty/features/characteres/domain/repositories/favorites_repository.dart';

class GetFavoritesIdsUseCase {
  final FavoritesRepository repository;

  GetFavoritesIdsUseCase(this.repository);

  Future<List<int>> call() {
    return repository.getFavoritesIds();
  }
}

