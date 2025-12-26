import 'package:rick_and_morty/core/error/failures.dart';
import 'package:rick_and_morty/features/characteres/domain/entities/characters_result.dart';
import 'package:rick_and_morty/features/characteres/domain/repositories/characters_repository.dart';

class GetCharactersUseCase {
  final CharactersRepository repository;

  GetCharactersUseCase(this.repository);

  /// Ejecuta el caso de uso para obtener personajes
  /// 
  /// Lanza [Failure] si ocurre un error durante la operación
  /// 
  /// Parámetros:
  /// - [page]: Número de página (debe ser >= 1)
  /// - [name]: Nombre opcional para filtrar personajes
  Future<CharactersResult> call({
    required int page,
    String? name,
  }) {
    // Validación de entrada
    if (page < 1) {
      throw const ValidationFailure(
        'Page number must be greater than 0',
        code: 'INVALID_PAGE',
      );
    }

    if (name != null && name.trim().isEmpty) {
      throw const ValidationFailure(
        'Name cannot be empty if provided',
        code: 'INVALID_NAME',
      );
    }

    return repository.getCharacters(
      page: page,
      name: name?.trim(),
    );
  }
}
