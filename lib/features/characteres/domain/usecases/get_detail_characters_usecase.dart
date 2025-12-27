import 'package:rick_and_morty/core/error/failures.dart';
import 'package:rick_and_morty/features/characteres/domain/entities/detail_character.dart';
import 'package:rick_and_morty/features/characteres/domain/repositories/detail_characters_repository.dart';

class GetDetailCharactersUseCase {
  final DetailCharactersRepository repository;

  GetDetailCharactersUseCase(this.repository);

  /// Ejecuta el caso de uso para obtener el detalle de un personaje
  ///
  /// Lanza [Failure] si ocurre un error durante la operación
  ///
  /// Parámetros:
  /// - [id]: ID del personaje (debe ser >= 1)
  Future<DetailCharacter> call({required int id}) {
    // Validación de entrada
    if (id < 1) {
      throw const ValidationFailure(
        'El id del personaje debe ser mayor que 0',
        code: 'INVALID_ID',
      );
    }

    return repository.getDetailCharacter(id);
  }
}
