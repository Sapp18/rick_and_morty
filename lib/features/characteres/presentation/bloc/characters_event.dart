part of 'characters_bloc.dart';

abstract class CharactersEvent extends Equatable {
  const CharactersEvent();

  @override
  List<Object?> get props => [];
}

class LoadCharactersEvent extends CharactersEvent {
  final int? page;
  final CharacterFilters? filters;

  const LoadCharactersEvent({this.page, this.filters});

  @override
  List<Object?> get props => [page, filters];
}

class SearchCharactersEvent extends CharactersEvent {
  final String query;

  const SearchCharactersEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class ToggleFavoriteEvent extends CharactersEvent {
  final int characterId;

  const ToggleFavoriteEvent(this.characterId);

  @override
  List<Object?> get props => [characterId];
}

class RefreshFavoritesEvent extends CharactersEvent {
  const RefreshFavoritesEvent();
}
