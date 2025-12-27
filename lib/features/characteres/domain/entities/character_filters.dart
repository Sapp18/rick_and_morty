/// Modelo para los filtros de búsqueda de personajes
class CharacterFilters {
  final String? name;
  final String? status; // 'alive', 'dead', 'unknown'
  final String? species;
  final String? type;
  final String? gender; // 'female', 'male', 'genderless', 'unknown'

  const CharacterFilters({
    this.name,
    this.status,
    this.species,
    this.type,
    this.gender,
  });

  /// Crea un CharacterFilters vacío (sin filtros)
  const CharacterFilters.empty()
      : name = null,
        status = null,
        species = null,
        type = null,
        gender = null;

  /// Verifica si hay algún filtro activo
  bool get hasFilters {
    return name != null ||
        status != null ||
        species != null ||
        type != null ||
        gender != null;
  }

  /// Crea una copia con valores opcionales
  CharacterFilters copyWith({
    String? name,
    String? status,
    String? species,
    String? type,
    String? gender,
  }) {
    return CharacterFilters(
      name: name ?? this.name,
      status: status ?? this.status,
      species: species ?? this.species,
      type: type ?? this.type,
      gender: gender ?? this.gender,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CharacterFilters &&
        other.name == name &&
        other.status == status &&
        other.species == species &&
        other.type == type &&
        other.gender == gender;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        status.hashCode ^
        species.hashCode ^
        type.hashCode ^
        gender.hashCode;
  }
}

