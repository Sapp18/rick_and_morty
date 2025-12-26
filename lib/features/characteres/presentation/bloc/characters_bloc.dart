import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
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
    } catch (_) {
      emit(const CharactersError('Error loading characters'));
    }
  }
}
