import 'package:dio/dio.dart';
import 'package:rick_and_morty/core/error/exceptions.dart';
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
    try {
      // Validar parámetros de entrada
      if (page < 1) {
        throw const ValidationException(
          'Page number must be greater than 0',
          code: 'INVALID_PAGE',
        );
      }

      if (name != null && name.trim().isEmpty) {
        throw const ValidationException(
          'Name cannot be empty if provided',
          code: 'INVALID_NAME',
        );
      }

      final response = await dio.get(
        '/character',
        queryParameters: {
          'page': page,
          if (name != null && name.isNotEmpty) 'name': name.trim(),
        },
      );

      // Validar respuesta
      if (response.data == null) {
        throw const ServerException(
          'Empty response from server',
          code: 'EMPTY_RESPONSE',
        );
      }

      if (response.statusCode == null) {
        throw const ServerException(
          'Invalid response status code',
          code: 'INVALID_STATUS',
        );
      }

      // Validar código de estado HTTP
      if (response.statusCode! >= 400) {
        throw ServerException.fromStatusCode(response.statusCode!);
      }

      return AllCharactersModel.fromJson(response.data);
    } on DioException catch (e) {
      // Manejar errores específicos de Dio
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw NetworkException.timeout();
      }

      if (e.type == DioExceptionType.connectionError) {
        throw NetworkException.noConnection();
      }

      if (e.type == DioExceptionType.cancel) {
        throw NetworkException.canceled();
      }

      if (e.response != null && e.response!.statusCode != null) {
        throw ServerException.fromStatusCode(e.response!.statusCode!);
      }

      throw NetworkException(
        e.message ?? 'Network error occurred',
        code: 'NETWORK_ERROR',
      );
    } on ValidationException {
      rethrow;
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ServerException(
        'Unexpected error: ${e.toString()}',
        code: 'UNEXPECTED_ERROR',
      );
    }
  }
}
