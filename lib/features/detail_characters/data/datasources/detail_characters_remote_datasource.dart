import 'package:dio/dio.dart';
import 'package:rick_and_morty/core/error/exceptions.dart';
import 'package:rick_and_morty/features/detail_characters/data/models/detail_character_model.dart';

abstract class DetailCharactersRemoteDataSource {
  Future<DetailCharacterModel> getDetailCharacter(int id);
}

class DetailCharactersRemoteDataSourceImpl
    implements DetailCharactersRemoteDataSource {
  final Dio dio;

  DetailCharactersRemoteDataSourceImpl(this.dio);

  @override
  Future<DetailCharacterModel> getDetailCharacter(int id) async {
    try {
      // Validar parámetros de entrada
      if (id < 1) {
        throw const ValidationException(
          'El id del personaje debe ser mayor que 0',
          code: 'INVALID_ID',
        );
      }

      final response = await dio.get('/character/$id');

      // Validar respuesta
      if (response.data == null) {
        throw const ServerException(
          'Respuesta vacía del servidor',
          code: 'EMPTY_RESPONSE',
        );
      }

      if (response.statusCode == null) {
        throw const ServerException(
          'Código de estado de respuesta inválido',
          code: 'INVALID_STATUS',
        );
      }

      // Validar código de estado HTTP
      if (response.statusCode! >= 400) {
        throw ServerException.fromStatusCode(response.statusCode!);
      }

      return DetailCharacterModel.fromJson(response.data);
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
        e.message ?? 'Error de red ocurrido',
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
        'Error inesperado: ${e.toString()}',
        code: 'UNEXPECTED_ERROR',
      );
    }
  }
}
