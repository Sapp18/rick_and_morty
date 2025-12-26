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

    List<Character> oldCharacters = [];
    int nextPage = event.page;

    if (currentState is CharactersLoaded) {
      if (currentState.hasReachedMax) return;
      oldCharacters = currentState.characters;
      nextPage++;
    }

    emit(CharactersLoading());

    try {
      final result = await getCharacters(page: nextPage, name: event.name);

      emit(
        CharactersLoaded(
          characters: oldCharacters + result.characters,
          hasReachedMax: result.hasReachedMax,
        ),
      );
    } on ServerFailure catch (failure) {
      emit(CharactersError(_getErrorMessage(failure)));
    } on NetworkFailure catch (failure) {
      emit(CharactersError(_getErrorMessage(failure)));
    } on CacheFailure catch (failure) {
      emit(CharactersError(_getErrorMessage(failure)));
    } on ValidationFailure catch (failure) {
      emit(CharactersError(_getErrorMessage(failure)));
    } on Failure catch (failure) {
      emit(CharactersError(_getErrorMessage(failure)));
    } catch (e) {
      emit(CharactersError(
        'An unexpected error occurred: ${e.toString()}',
      ));
    }
  }

  /// Obtiene un mensaje de error amigable para el usuario basado en el tipo de fallo
  String _getErrorMessage(Failure failure) {
    if (failure is ServerFailure) {
      if (failure.statusCode == 404) {
        return 'No characters found. Try adjusting your search.';
      }
      if (failure.statusCode != null && failure.statusCode! >= 500) {
        return 'Server error. Please try again later.';
      }
      return failure.message;
    }

    if (failure is NetworkFailure) {
      if (failure.code == 'NO_CONNECTION') {
        return 'No internet connection. Please check your network.';
      }
      if (failure.code == 'TIMEOUT') {
        return 'Request timed out. Please try again.';
      }
      return failure.message;
    }

    if (failure is CacheFailure) {
      return 'Error accessing local data. Please try again.';
    }

    if (failure is ValidationFailure) {
      return 'Invalid data: ${failure.message}';
    }

    return failure.message;
  }
}
