import 'package:flutter/material.dart';

/// Clase helper con utilidades para trabajar con personajes
class CharacterHelper {
  /// Obtiene el color basado en el estado del personaje
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'alive':
        return Colors.green;
      case 'dead':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  /// Obtiene la etiqueta del estado del personaje en español
  static String getStatusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'alive':
        return 'Vivo';
      case 'dead':
        return 'Muerto';
      default:
        return 'Desconocido';
    }
  }

  /// Obtiene el color basado en la especie del personaje
  static Color getSpeciesColor(String species) {
    switch (species.toLowerCase()) {
      case 'human':
        return Colors.blue;
      case 'alien':
        return Colors.purple;
      case 'humanoid':
        return Colors.orange;
      case 'robot':
        return Colors.brown;
      case 'animal':
        return Colors.yellowAccent;
      case 'plant':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  /// Obtiene la etiqueta de la especie del personaje en español
  static String getSpeciesLabel(String species) {
    switch (species.toLowerCase()) {
      case 'human':
        return 'Humano';
      case 'alien':
        return 'Alien';
      case 'humanoid':
        return 'Humanoide';
      case 'robot':
        return 'Robot';
      case 'animal':
        return 'Animal';
      case 'plant':
        return 'Planta';
      default:
        return 'Desconocido';
    }
  }

  /// Extrae el número del episodio de la URL
  /// Ejemplo: "https://rickandmortyapi.com/api/episode/1" -> "1"
  static String extractEpisodeNumber(String episodeUrl) {
    final parts = episodeUrl.split('/');
    return parts.last;
  }
}
