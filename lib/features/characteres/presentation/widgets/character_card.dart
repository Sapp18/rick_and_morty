import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty/features/characteres/domain/entities/character.dart';
import 'package:rick_and_morty/features/characteres/presentation/bloc/characters_bloc.dart';
import 'package:rick_and_morty/features/detail_characters/presentation/pages/detail_characters_page.dart';

class CharacterCard extends StatelessWidget {
  final Character character;

  const CharacterCard({super.key, required this.character});

  Color _getStatusColor() {
    // Colores basados en el estado para el punto indicador del avatar
    switch (character.status.toLowerCase()) {
      case 'alive':
        return Colors.green;
      case 'dead':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _getSpeciesColor() {
    // Colores basados en especie para el punto indicador
    switch (character.species.toLowerCase()) {
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

  String _getSpeciesLabel() {
    return character.species;
  }

  @override
  Widget build(BuildContext context) {
    final double avatarSize = 80.0;
    return InkWell(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailCharactersPage(character: character),
          ),
        );
        // Refrescar favoritos cuando se regrese de la pantalla de detalle
        if (context.mounted) {
          final bloc = context.read<CharactersBloc>();
          bloc.add(const RefreshFavoritesEvent());
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Avatar circular con punto de estado superpuesto
            Stack(
              clipBehavior: Clip.none,
              children: [
                Hero(
                  tag: 'character_image_${character.id}',
                  child: ClipOval(
                    child: Image.network(
                      character.image,
                      width: avatarSize,
                      height: avatarSize,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: avatarSize,
                          height: avatarSize,
                          color: Colors.grey[700],
                          child: Icon(
                            Icons.person,
                            size: avatarSize / 2,
                            color: Colors.white,
                          ),
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          width: avatarSize,
                          height: avatarSize,
                          color: Colors.grey[800],
                          child: const Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                // Punto de estado/especie en la esquina inferior derecha
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: _getStatusColor(),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            // Información del personaje
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Nombre con icono de favorito
                  Row(
                    children: [
                      Text(
                        character.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (character.isFavorite) ...[
                        SizedBox(width: 10),
                        const Icon(Icons.favorite, color: Colors.red, size: 16),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Especie con punto de color
                  Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: _getSpeciesColor(),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _getSpeciesLabel(),
                        style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Icono de flecha
            Icon(Icons.chevron_right, color: Colors.grey[600], size: 24),
          ],
        ),
      ),
    );
  }
}
