import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rick_and_morty/core/error/failures.dart';
import 'package:rick_and_morty/features/detail_characters/domain/entities/detail_character.dart';
import 'package:rick_and_morty/features/detail_characters/domain/usecases/get_detail_characters_usecase.dart';
import 'package:rick_and_morty/features/characteres/domain/usecases/toggle_favorite_usecase.dart';
import 'package:rick_and_morty/features/characteres/domain/usecases/get_favorites_ids_usecase.dart';

part 'detail_characters_event.dart';
part 'detail_characters_state.dart';

class DetailCharactersBloc
    extends Bloc<DetailCharactersEvent, DetailCharactersState> {
  final GetDetailCharactersUseCase getDetailCharacter;
  final ToggleFavoriteUseCase? toggleFavorite;
  final GetFavoritesIdsUseCase? getFavoritesIds;
  bool _isFavorite = false;

  DetailCharactersBloc(
    this.getDetailCharacter, [
    this.toggleFavorite,
    this.getFavoritesIds,
  ]) : super(DetailCharactersInitial()) {
    on<LoadDetailCharacterEvent>(_onLoadDetailCharacter);
    on<ToggleFavoriteDetailEvent>(_onToggleFavorite);
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

      // Verificar si es favorito
      if (getFavoritesIds != null) {
        try {
          final favoritesIds = await getFavoritesIds!();
          _isFavorite = favoritesIds.contains(event.id);
        } catch (e) {
          _isFavorite = false;
        }
      }

      emit(DetailCharactersLoaded(result, isFavorite: _isFavorite));
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

  Future<void> _onToggleFavorite(
    ToggleFavoriteDetailEvent event,
    Emitter<DetailCharactersState> emit,
  ) async {
    if (toggleFavorite == null) return;

    final currentState = state;
    if (currentState is! DetailCharactersLoaded) return;

    try {
      await toggleFavorite!(characterId: event.characterId);
      _isFavorite = !_isFavorite;

      emit(currentState.copyWith(isFavorite: _isFavorite));
    } catch (e) {
      // Si hay error, no hacer nada o mostrar un mensaje
      print('Error al actualizar favorito: $e');
    }
  }
}
