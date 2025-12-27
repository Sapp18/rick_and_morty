import 'package:rick_and_morty/core/database/database_helper.dart';
import 'package:rick_and_morty/core/network/dio_client.dart';
import 'package:rick_and_morty/features/characteres/data/datasources/characters_remote_datasource.dart';
import 'package:rick_and_morty/features/characteres/data/datasources/favorites_local_datasource.dart';
import 'package:rick_and_morty/features/characteres/data/repositories/characters_repository_impl.dart';
import 'package:rick_and_morty/features/characteres/data/repositories/favorites_repository_impl.dart';
import 'package:rick_and_morty/features/characteres/domain/usecases/get_characters_usecase.dart';
import 'package:rick_and_morty/features/characteres/domain/usecases/get_favorites_ids_usecase.dart';
import 'package:rick_and_morty/features/characteres/domain/usecases/toggle_favorite_usecase.dart';
import 'package:rick_and_morty/features/detail_characters/data/datasources/detail_characters_remote_datasource.dart';
import 'package:rick_and_morty/features/detail_characters/data/repositories/detail_characters_repository_impl.dart';
import 'package:rick_and_morty/features/detail_characters/domain/usecases/get_detail_characters_usecase.dart';

final dio = DioClient.create();

// Database
final databaseHelper = DatabaseHelper.instance;

// Favorites dependencies
final favoritesLocal = FavoritesLocalDataSourceImpl(databaseHelper);
final favoritesRepository = FavoritesRepositoryImpl(favoritesLocal);
final toggleFavoriteUseCase = ToggleFavoriteUseCase(favoritesRepository);
final getFavoritesIdsUseCase = GetFavoritesIdsUseCase(favoritesRepository);

// Characters dependencies
final charactersRemote = CharactersRemoteDataSourceImpl(dio);
final charactersRepository = CharactersRepositoryImpl(
  charactersRemote,
  favoritesRepository,
);
final getCharactersUseCase = GetCharactersUseCase(charactersRepository);

// Detail Characters dependencies
final detailCharactersRemote = DetailCharactersRemoteDataSourceImpl(dio);
final detailCharactersRepository = DetailCharactersRepositoryImpl(
  detailCharactersRemote,
);
final getDetailCharactersUseCase = GetDetailCharactersUseCase(
  detailCharactersRepository,
);
