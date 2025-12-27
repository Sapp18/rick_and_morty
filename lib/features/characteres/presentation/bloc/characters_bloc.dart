import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rick_and_morty/core/error/failures.dart';
import 'package:rick_and_morty/features/characteres/domain/entities/character.dart';
import 'package:rick_and_morty/features/characteres/domain/usecases/get_characters_usecase.dart';

part 'characters_event.dart';
part 'characters_state.dart';

class CharactersBloc extends Bloc<CharactersEvent, CharactersState> {
  final GetCharactersUseCase getCharacters;

  CharactersBloc(this.getCharacters) : super(CharactersInitial()) {
    on<LoadCharactersEvent>(_onLoadCharacters);
  }

  Future<void> _onLoadCharacters(
    LoadCharactersEvent event,
    Emitter<CharactersState> emit,
  ) async {
    // Prevenir múltiples cargas simultáneas
    if (state is CharactersLoading) return;

    final currentState = state;
    CharactersLoaded? loadedState;
    if (currentState is CharactersLoaded) {
      loadedState = currentState;
    }
    final isScrollInfinite = event.page == null && loadedState != null;
    // Variable final para usar en los catch blocks
    final previousLoadedState = isScrollInfinite ? loadedState : null;

    List<Character> oldCharacters = [];
    int nextPage;

    // Si page es null, significa "siguiente página" (scroll infinito)
    // Si page es 1, significa "resetear desde el inicio" (refresh)
    // Si page tiene otro valor, usar ese valor específico
    if (event.page == null) {
      // Scroll infinito: continuar desde donde estábamos
      if (loadedState != null) {
        if (loadedState.hasReachedMax || loadedState.isLoadingMore) return;
        oldCharacters = loadedState.characters;
        // Calcular la siguiente página basándonos en cuántos personajes tenemos
        // La API de Rick and Morty devuelve 20 personajes por página
        nextPage = (oldCharacters.length ~/ 20) + 1;
        // Emitir estado manteniendo la lista actual y activando isLoadingMore
        emit(loadedState.copyWith(isLoadingMore: true));
      } else {
        // Primera carga si no hay estado
        oldCharacters = [];
        nextPage = 1;
        emit(CharactersLoading());
      }
    } else if (event.page == 1) {
      // Refresh: resetear la lista
      oldCharacters = [];
      nextPage = 1;
      emit(CharactersLoading());
    } else {
      // Página específica
      oldCharacters = loadedState?.characters ?? [];
      nextPage = event.page!;
      emit(CharactersLoading());
    }

    try {
      final result = await getCharacters(page: nextPage, name: event.name);

      emit(
        CharactersLoaded(
          characters: oldCharacters + result.characters,
          hasReachedMax: result.hasReachedMax,
          isLoadingMore: false,
        ),
      );
    } on ServerFailure catch (failure) {
      // Si es scroll infinito, restaurar el estado anterior (desactivar isLoadingMore)
      if (previousLoadedState != null) {
        emit(previousLoadedState.copyWith(isLoadingMore: false));
      } else {
        emit(CharactersError(_getErrorMessage(failure)));
      }
    } on NetworkFailure catch (failure) {
      if (previousLoadedState != null) {
        emit(previousLoadedState.copyWith(isLoadingMore: false));
      } else {
        emit(CharactersError(_getErrorMessage(failure)));
      }
    } on CacheFailure catch (failure) {
      if (previousLoadedState != null) {
        emit(previousLoadedState.copyWith(isLoadingMore: false));
      } else {
        emit(CharactersError(_getErrorMessage(failure)));
      }
    } on ValidationFailure catch (failure) {
      if (previousLoadedState != null) {
        emit(previousLoadedState.copyWith(isLoadingMore: false));
      } else {
        emit(CharactersError(_getErrorMessage(failure)));
      }
    } on Failure catch (failure) {
      if (previousLoadedState != null) {
        emit(previousLoadedState.copyWith(isLoadingMore: false));
      } else {
        emit(CharactersError(_getErrorMessage(failure)));
      }
    } catch (e) {
      if (previousLoadedState != null) {
        emit(previousLoadedState.copyWith(isLoadingMore: false));
      } else {
        emit(
          CharactersError('Se produjo un error inesperado: ${e.toString()}'),
        );
      }
    }
  }

  /// Obtiene un mensaje de error amigable para el usuario basado en el tipo de fallo
  String _getErrorMessage(Failure failure) {
    if (failure is ServerFailure) {
      if (failure.statusCode == 404) {
        return 'No se encontraron personajes, intente ajustar su búsqueda.';
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
