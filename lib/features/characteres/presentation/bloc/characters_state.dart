part of 'characters_bloc.dart';

abstract class CharactersState extends Equatable {
  const CharactersState();

  @override
  List<Object?> get props => [];
}

class CharactersInitial extends CharactersState {}

class CharactersLoading extends CharactersState {}

class CharactersLoaded extends CharactersState {
  final List<Character> characters;
  final bool hasReachedMax;

  const CharactersLoaded({
    required this.characters,
    required this.hasReachedMax,
  });

  CharactersLoaded copyWith({
    List<Character>? characters,
    bool? hasReachedMax,
  }) {
    return CharactersLoaded(
      characters: characters ?? this.characters,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props => [characters, hasReachedMax];
}

class CharactersError extends CharactersState {
  final String message;

  const CharactersError(this.message);

  @override
  List<Object?> get props => [message];
}
