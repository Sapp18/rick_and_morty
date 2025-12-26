part of 'characters_bloc.dart';

abstract class CharactersEvent extends Equatable {
  const CharactersEvent();

  @override
  List<Object?> get props => [];
}

class LoadCharactersEvent extends CharactersEvent {
  final int page;
  final String? name;

  const LoadCharactersEvent({this.page = 1, this.name});
}
