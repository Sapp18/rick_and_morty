import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty/core/utils/character_helper.dart';
import 'package:rick_and_morty/features/characteres/domain/entities/character.dart';
import 'package:rick_and_morty/features/characteres/presentation/bloc/characters_bloc.dart';
import 'package:rick_and_morty/features/detail_characters/presentation/pages/detail_characters_page.dart';

class CharacterCard extends StatelessWidget {
  final Character character;

  const CharacterCard({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    final double avatarSize = 56.0;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: SizedBox(
        width: avatarSize,
        height: avatarSize,
        child: Stack(
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
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: CharacterHelper.getStatusColor(character.status),
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
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              character.name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (character.isFavorite) ...[
            const SizedBox(width: 8),
            const Icon(Icons.favorite, color: Colors.red, size: 16),
          ],
        ],
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: CircleBasicInfo(
          color: CharacterHelper.getSpeciesColor(character.species),
          label: CharacterHelper.getSpeciesLabel(character.species),
        ),
      ),
      trailing: Icon(Icons.chevron_right, color: Colors.grey[600], size: 24),
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
    );
  }
}
