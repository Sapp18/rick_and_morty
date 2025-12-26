import 'package:equatable/equatable.dart';

class Character extends Equatable {
  final int id;
  final String name;
  final String image;
  final String species;
  final String status;
  final String origin;
  final bool isFavorite;

  const Character({
    required this.id,
    required this.name,
    required this.image,
    required this.species,
    required this.status,
    required this.origin,
    this.isFavorite = false,
  });

  @override
  List<Object?> get props => [id, isFavorite];
}
