import 'package:rick_and_morty/core/network/dio_client.dart';
import 'package:rick_and_morty/features/characteres/data/datasources/characters_remote_datasource.dart';
import 'package:rick_and_morty/features/characteres/data/repositories/characters_repository_impl.dart';
import 'package:rick_and_morty/features/characteres/domain/usecases/get_characters_usecase.dart';

final dio = DioClient.create();

final charactersRemote = CharactersRemoteDataSourceImpl(dio);
final charactersRepository = CharactersRepositoryImpl(charactersRemote);

final getCharactersUseCase = GetCharactersUseCase(charactersRepository);
