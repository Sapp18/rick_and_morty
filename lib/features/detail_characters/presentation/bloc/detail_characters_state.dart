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

  const DetailCharactersLoaded(this.character);

  @override
  List<Object?> get props => [character];
}

class DetailCharactersError extends DetailCharactersState {
  final String message;

  const DetailCharactersError(this.message);

  @override
  List<Object?> get props => [message];
}
