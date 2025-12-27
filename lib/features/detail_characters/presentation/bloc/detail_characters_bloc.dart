import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rick_and_morty/core/error/failures.dart';
import 'package:rick_and_morty/features/detail_characters/domain/entities/detail_character.dart';
import 'package:rick_and_morty/features/detail_characters/domain/usecases/get_detail_characters_usecase.dart';

part 'detail_characters_event.dart';
part 'detail_characters_state.dart';

class DetailCharactersBloc
    extends Bloc<DetailCharactersEvent, DetailCharactersState> {
  final GetDetailCharactersUseCase getDetailCharacter;

  DetailCharactersBloc(this.getDetailCharacter)
    : super(DetailCharactersInitial()) {
    on<LoadDetailCharacterEvent>(_onLoadDetailCharacter);
  }

  Future<void> _onLoadDetailCharacter(
    LoadDetailCharacterEvent event,
    Emitter<DetailCharactersState> emit,
  ) async {
    // Prevenir múltiples cargas simultáneas
    if (state is DetailCharactersLoading) return;

    emit(DetailCharactersLoading());

    try {
      final result = await getDetailCharacter(id: event.id);

      emit(DetailCharactersLoaded(result));
    } on ServerFailure catch (failure) {
      emit(DetailCharactersError(_getErrorMessage(failure)));
    } on NetworkFailure catch (failure) {
      emit(DetailCharactersError(_getErrorMessage(failure)));
    } on CacheFailure catch (failure) {
      emit(DetailCharactersError(_getErrorMessage(failure)));
    } on ValidationFailure catch (failure) {
      emit(DetailCharactersError(_getErrorMessage(failure)));
    } on Failure catch (failure) {
      emit(DetailCharactersError(_getErrorMessage(failure)));
    } catch (e) {
      emit(
        DetailCharactersError(
          'Se produjo un error inesperado: ${e.toString()}',
        ),
      );
    }
  }

  /// Obtiene un mensaje de error amigable para el usuario basado en el tipo de fallo
  String _getErrorMessage(Failure failure) {
    if (failure is ServerFailure) {
      if (failure.statusCode == 404) {
        return 'Personaje no encontrado.';
      }
      if (failure.statusCode != null && failure.statusCode! >= 500) {
        return 'Error del servidor, por favor intente nuevamente más tarde.';
      }
      return failure.message;
    }

    if (failure is NetworkFailure) {
      if (failure.code == 'NO_CONNECTION') {
        return 'No hay conexión a internet, por favor revise sus configuraciones de red.';
      }
      if (failure.code == 'TIMEOUT') {
        return 'Tiempo de espera agotado, por favor intente nuevamente.';
      }
      return failure.message;
    }

    if (failure is CacheFailure) {
      return 'Error al acceder a los datos locales, por favor intente nuevamente.';
    }

    if (failure is ValidationFailure) {
      return 'Datos inválidos: ${failure.message}';
    }

    return failure.message;
  }
}
