part of 'detail_characters_bloc.dart';

abstract class DetailCharactersState extends Equatable {
  const DetailCharactersState();

  @override
  List<Object?> get props => [];
}

class DetailCharactersInitial extends DetailCharactersState {}

class DetailCharactersLoading extends DetailCharactersState {}

class DetailCharactersLoaded extends DetailCharactersState {
  final DetailCharacter character;
  final bool isFavorite;

  const DetailCharactersLoaded(this.character, {this.isFavorite = false});

  DetailCharactersLoaded copyWith({
    DetailCharacter? character,
    bool? isFavorite,
  }) {
    return DetailCharactersLoaded(
      character ?? this.character,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  List<Object?> get props => [character, isFavorite];
}

class DetailCharactersError extends DetailCharactersState {
  final String message;

  const DetailCharactersError(this.message);

  @override
  List<Object?> get props => [message];
}
