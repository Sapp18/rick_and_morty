import 'package:rick_and_morty/core/error/exceptions.dart';
import 'package:rick_and_morty/features/detail_characters/domain/entities/detail_character.dart';

/// Modelo de datos para DetailCharacter
/// Separa el modelo de dominio del modelo de API
/// Incluye validaciones estrictas para garantizar la integridad de los datos
class DetailCharacterModel {
  final int id;
  final String name;
  final String image;
  final String species;
  final String status;
  final String origin;
  final String location;
  final List<String> episodes;

  const DetailCharacterModel({
    required this.id,
    required this.name,
    required this.image,
    required this.species,
    required this.status,
    required this.origin,
    required this.location,
    required this.episodes,
  });

  /// Factory constructor desde JSON con validaciones estrictas
  factory DetailCharacterModel.fromJson(Map<String, dynamic> json) {
    try {
      // Validar que los campos requeridos existan y no sean null
      if (json['id'] == null) {
        throw const ValidationException(
          'El id del personaje es requerido y no puede ser null',
          code: 'MISSING_ID',
        );
      }

      if (json['name'] == null || (json['name'] as String).isEmpty) {
        throw const ValidationException(
          'El nombre del personaje es requerido y no puede estar vacío',
          code: 'MISSING_NAME',
        );
      }

      if (json['image'] == null || (json['image'] as String).isEmpty) {
        throw const ValidationException(
          'La imagen del personaje es requerida y no puede estar vacía',
          code: 'MISSING_IMAGE',
        );
      }

      if (json['species'] == null || (json['species'] as String).isEmpty) {
        throw const ValidationException(
          'La especie del personaje es requerida y no puede estar vacía',
          code: 'MISSING_SPECIES',
        );
      }

      // Validar tipos
      final id = json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id'].toString());

      if (id == null || id <= 0) {
        throw const ValidationException(
          'El id del personaje debe ser un entero positivo',
          code: 'INVALID_ID',
        );
      }

      // Validar status
      final statusValue = json['status'] as String?;
      final status = _validateStatus(statusValue);

      // Validar origin
      final originData = json['origin'];
      final origin = _validateLocation(originData);

      // Validar location
      final locationData = json['location'];
      final location = _validateLocation(locationData);

      // Validar episodes
      final episodesData = json['episode'] as List<dynamic>?;
      final episodes = _validateEpisodes(episodesData);

      return DetailCharacterModel(
        id: id,
        name: json['name'] as String,
        image: json['image'] as String,
        species: json['species'] as String,
        status: status,
        origin: origin,
        location: location,
        episodes: episodes,
      );
    } on ValidationException {
      rethrow;
    } catch (e) {
      throw ValidationException(
        'Error al parsear DetailCharacterModel: ${e.toString()}',
        code: 'PARSE_ERROR',
      );
    }
  }

  /// Valida y normaliza el status del personaje
  static String _validateStatus(String? status) {
    if (status == null || status.isEmpty) {
      return 'unknown';
    }

    final normalizedStatus = status.toLowerCase().trim();
    final validStatuses = ['alive', 'dead', 'unknown'];

    if (validStatuses.contains(normalizedStatus)) {
      return normalizedStatus;
    }

    // Si el status viene con mayúscula inicial desde la API
    if (status == 'Alive') return 'alive';
    if (status == 'Dead') return 'dead';

    return 'unknown';
  }

  /// Valida y extrae el nombre de la ubicación (origin o location)
  static String _validateLocation(dynamic locationData) {
    if (locationData == null) {
      return 'unknown';
    }

    if (locationData is Map<String, dynamic>) {
      final name = locationData['name'] as String?;
      if (name != null && name.isNotEmpty) {
        return name;
      }
    }

    if (locationData is String && locationData.isNotEmpty) {
      return locationData;
    }

    return 'unknown';
  }

  /// Valida y normaliza la lista de episodios
  static List<String> _validateEpisodes(List<dynamic>? episodesData) {
    if (episodesData == null) {
      return [];
    }

    return episodesData
        .map((e) => e.toString())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  /// Convierte el modelo a entidad de dominio
  DetailCharacter toEntity() {
    return DetailCharacter(
      id: id,
      name: name,
      image: image,
      species: species,
      status: status,
      origin: origin,
      location: location,
      episodes: episodes,
    );
  }

  /// Convierte el modelo a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'species': species,
      'status': status,
      'origin': {'name': origin},
      'location': {'name': location},
      'episode': episodes,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DetailCharacterModel &&
        other.id == id &&
        other.name == name &&
        other.image == image &&
        other.species == species &&
        other.status == status &&
        other.origin == origin &&
        other.location == location &&
        other.episodes == episodes;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        image.hashCode ^
        species.hashCode ^
        status.hashCode ^
        origin.hashCode ^
        location.hashCode ^
        episodes.hashCode;
  }

  @override
  String toString() {
    return 'DetailCharacterModel(id: $id, name: $name, species: $species, status: $status)';
  }
}
