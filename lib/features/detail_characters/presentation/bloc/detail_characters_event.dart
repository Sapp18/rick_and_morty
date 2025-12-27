part of 'detail_characters_bloc.dart';

abstract class DetailCharactersEvent extends Equatable {
  const DetailCharactersEvent();

  @override
  List<Object?> get props => [];
}

class LoadDetailCharacterEvent extends DetailCharactersEvent {
  final int id;

  const LoadDetailCharacterEvent(this.id);

  @override
  List<Object?> get props => [id];
}
