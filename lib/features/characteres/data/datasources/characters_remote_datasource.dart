import 'package:dio/dio.dart';
import 'package:rick_and_morty/features/characteres/data/models/all_characters_model.dart';

abstract class CharactersRemoteDataSource {
  Future<AllCharactersModel> getCharacters({required int page, String? name});
}

class CharactersRemoteDataSourceImpl implements CharactersRemoteDataSource {
  final Dio dio;

  CharactersRemoteDataSourceImpl(this.dio);

  @override
  Future<AllCharactersModel> getCharacters({
    required int page,
    String? name,
  }) async {
    final response = await dio.get(
      '/character',
      queryParameters: {
        'page': page,
        if (name != null && name.isNotEmpty) 'name': name,
      },
    );

    return AllCharactersModel.fromJson(response.data);
  }
}
