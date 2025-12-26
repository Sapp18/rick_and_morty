import 'package:rick_and_morty/core/error/exceptions.dart';
import 'package:rick_and_morty/features/characteres/domain/entities/character.dart';

/// Modelo de datos para Character
/// Separa el modelo de dominio del modelo de API
/// Incluye validaciones estrictas para garantizar la integridad de los datos
class CharacterModel {
  final int id;
  final String name;
  final String image;
  final String species;
  final String status;
  final String origin;

  const CharacterModel({
    required this.id,
    required this.name,
    required this.image,
    required this.species,
    required this.status,
    required this.origin,
  });

  /// Factory constructor desde JSON con validaciones estrictas
  factory CharacterModel.fromJson(Map<String, dynamic> json) {
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
      final origin = _validateOrigin(originData);

      return CharacterModel(
        id: id,
        name: json['name'] as String,
        image: json['image'] as String,
        species: json['species'] as String,
        status: status,
        origin: origin,
      );
    } on ValidationException {
      rethrow;
    } catch (e) {
      throw ValidationException(
        'Error al parsear CharacterModel: ${e.toString()}',
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

  /// Valida y extrae el nombre del origin
  static String _validateOrigin(dynamic originData) {
    if (originData == null) {
      return 'unknown';
    }

    if (originData is Map<String, dynamic>) {
      final name = originData['name'] as String?;
      if (name != null && name.isNotEmpty) {
        return name;
      }
    }

    if (originData is String && originData.isNotEmpty) {
      return originData;
    }

    return 'unknown';
  }

  /// Convierte el modelo a entidad de dominio
  Character toEntity({bool isFavorite = false}) {
    return Character(
      id: id,
      name: name,
      image: image,
      species: species,
      status: status,
      origin: origin,
      isFavorite: isFavorite,
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
    };
  }

  /// Crea una copia del modelo con valores opcionales
  CharacterModel copyWith({
    int? id,
    String? name,
    String? image,
    String? species,
    String? status,
    String? origin,
  }) {
    return CharacterModel(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      species: species ?? this.species,
      status: status ?? this.status,
      origin: origin ?? this.origin,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CharacterModel &&
        other.id == id &&
        other.name == name &&
        other.image == image &&
        other.species == species &&
        other.status == status &&
        other.origin == origin;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        image.hashCode ^
        species.hashCode ^
        status.hashCode ^
        origin.hashCode;
  }

  @override
  String toString() {
    return 'CharacterModel(id: $id, name: $name, species: $species, status: $status)';
  }
}
