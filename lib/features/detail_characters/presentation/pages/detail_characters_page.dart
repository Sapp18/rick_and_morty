import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty/app/app_module.dart';
import 'package:rick_and_morty/core/utils/character_helper.dart';
import 'package:rick_and_morty/features/characteres/domain/entities/character.dart';
import 'package:rick_and_morty/features/detail_characters/domain/entities/detail_character.dart';
import 'package:rick_and_morty/features/detail_characters/presentation/bloc/detail_characters_bloc.dart';

class DetailCharactersPage extends StatelessWidget {
  final Character character;

  const DetailCharactersPage({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DetailCharactersBloc(
        getDetailCharactersUseCase,
        toggleFavoriteUseCase,
        getFavoritesIdsUseCase,
      )..add(LoadDetailCharacterEvent(character.id)),
      child: Scaffold(
        appBar: AppBar(
          title: Text(character.name),
          centerTitle: true,
          actions: [
            BlocBuilder<DetailCharactersBloc, DetailCharactersState>(
              builder: (context, state) {
                final isFavorite = state is DetailCharactersLoaded
                    ? state.isFavorite
                    : character.isFavorite;
                return IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : null,
                  ),
                  onPressed: () {
                    context.read<DetailCharactersBloc>().add(
                      ToggleFavoriteDetailEvent(character.id),
                    );
                    // Notificar al BLoC de la lista para actualizar
                    // Esto se puede hacer con un callback o un evento global
                  },
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<DetailCharactersBloc, DetailCharactersState>(
          builder: (context, state) {
            if (state is DetailCharactersInitial) {
              return DetailBasicInfo(character: character);
            }

            if (state is DetailCharactersLoading) {
              // Widget para el estado de carga
              return Column(
                children: [
                  DetailBasicInfo(character: character),
                  const Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ],
              );
            }

            if (state is DetailCharactersError) {
              return DetailErrorView(
                character: character,
                message: state.message,
              );
            }

            if (state is DetailCharactersLoaded) {
              return DetailLoadedView(
                character: character,
                detailCharacter: state.character,
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

// Widget para el estado de error
class DetailErrorView extends StatelessWidget {
  final Character character;
  final String message;

  const DetailErrorView({
    super.key,
    required this.character,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DetailBasicInfo(character: character),
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    message,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    context.read<DetailCharactersBloc>().add(
                      LoadDetailCharacterEvent(character.id),
                    );
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reintentar'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// Widget para el estado cargado
class DetailLoadedView extends StatelessWidget {
  final Character character;
  final DetailCharacter detailCharacter;

  const DetailLoadedView({
    super.key,
    required this.character,
    required this.detailCharacter,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DetailBasicInfo(character: character),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Origen
                DetailInfoSection(
                  icon: Icons.public,
                  title: 'Origen',
                  value: detailCharacter.origin,
                ),
                const SizedBox(height: 16),
                // Última ubicación conocida
                DetailInfoSection(
                  icon: Icons.location_on,
                  title: 'Última ubicación conocida',
                  value: detailCharacter.location,
                ),
                const SizedBox(height: 24),
                // Episodios
                Text(
                  'Episodios (${detailCharacter.episodes.length})',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                DetailEpisodesList(episodes: detailCharacter.episodes),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Widget para información básica del personaje, esta informacion ya viene sobrecargada desde la pagina de personajes
class DetailBasicInfo extends StatelessWidget {
  final Character character;

  const DetailBasicInfo({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Imagen del personaje
        Hero(
          tag: 'character_image_${character.id}',
          child: Container(
            width: double.infinity,
            height: 300,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(character.image),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                character.name,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  CircleBasicInfo(
                    color: CharacterHelper.getStatusColor(character.status),
                    label: CharacterHelper.getStatusLabel(character.status),
                  ),
                  const SizedBox(width: 16),
                  CircleBasicInfo(
                    color: CharacterHelper.getSpeciesColor(character.species),
                    label: CharacterHelper.getSpeciesLabel(character.species),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CircleBasicInfo extends StatelessWidget {
  final Color color;
  final String label;
  const CircleBasicInfo({super.key, required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(label, style: TextStyle(fontSize: 16, color: Colors.grey[700])),
      ],
    );
  }
}

// Widget para sección de información
class DetailInfoSection extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const DetailInfoSection({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: Colors.grey[600]),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(left: 28),
          child: Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}

// Widget para lista de episodios
class DetailEpisodesList extends StatelessWidget {
  final List<String> episodes;

  const DetailEpisodesList({super.key, required this.episodes});

  @override
  Widget build(BuildContext context) {
    if (episodes.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(left: 28),
        child: Text(
          'No hay episodios disponibles',
          style: TextStyle(color: Colors.grey[600]),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: episodes.length,
      itemBuilder: (context, index) {
        final episodeUrl = episodes[index];
        final episodeNumber = CharacterHelper.extractEpisodeNumber(episodeUrl);
        return Padding(
          padding: const EdgeInsets.only(left: 28, bottom: 8),
          child: Row(
            children: [
              Icon(
                Icons.play_circle_outline,
                size: 20,
                color: Colors.grey[600],
              ),
              const SizedBox(width: 8),
              Text(
                'Episodio $episodeNumber',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        );
      },
    );
  }
}
