import 'package:equatable/equatable.dart';

class DetailCharacter extends Equatable {
  final int id;
  final String name;
  final String image;
  final String species;
  final String status;
  final String origin;
  final String location;
  final List<String> episodes;

  const DetailCharacter({
    required this.id,
    required this.name,
    required this.image,
    required this.species,
    required this.status,
    required this.origin,
    required this.location,
    required this.episodes,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    image,
    species,
    status,
    origin,
    location,
    episodes,
  ];
}
