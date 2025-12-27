import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty/app/app_module.dart';
import 'package:rick_and_morty/features/characteres/domain/entities/character.dart';
import 'package:rick_and_morty/features/detail_characters/domain/entities/detail_character.dart';
import 'package:rick_and_morty/features/detail_characters/presentation/bloc/detail_characters_bloc.dart';

class DetailCharactersPage extends StatelessWidget {
  final Character character;

  const DetailCharactersPage({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          DetailCharactersBloc(
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
              return _buildInitialView();
            }

            if (state is DetailCharactersLoading) {
              return _buildLoadingView();
            }

            if (state is DetailCharactersError) {
              return _buildErrorView(context, state.message);
            }

            if (state is DetailCharactersLoaded) {
              return _buildLoadedView(context, state.character);
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildInitialView() {
    return _buildBasicInfo();
  }

  Widget _buildLoadingView() {
    return Column(
      children: [
        _buildBasicInfo(),
        const Expanded(child: Center(child: CircularProgressIndicator())),
      ],
    );
  }

  Widget _buildErrorView(BuildContext context, String message) {
    return Column(
      children: [
        _buildBasicInfo(),
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

  Widget _buildLoadedView(
    BuildContext context,
    DetailCharacter detailCharacter,
  ) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen del personaje
          Hero(
            tag: 'character_image_${character.id}',
            child: Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(detailCharacter.image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nombre
                Text(
                  detailCharacter.name,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                // Status y Species
                Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: _getStatusColor(detailCharacter.status),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _getStatusLabel(detailCharacter.status),
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      detailCharacter.species,
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Origen
                _buildInfoSection(
                  icon: Icons.public,
                  title: 'Origen',
                  value: detailCharacter.origin,
                ),
                const SizedBox(height: 16),
                // Última ubicación conocida
                _buildInfoSection(
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
                _buildEpisodesList(detailCharacter.episodes),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfo() {
    return Column(
      children: [
        Hero(
          tag: 'character_image_${character.id}',
          child: Container(
            width: double.infinity,
            height: 300,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(character.image),
                fit: BoxFit.cover,
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
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: _getStatusColor(character.status),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _getStatusLabel(character.status),
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    character.species,
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoSection({
    required IconData icon,
    required String title,
    required String value,
  }) {
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

  Widget _buildEpisodesList(List<String> episodes) {
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
        final episodeNumber = _extractEpisodeNumber(episodeUrl);
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

  String _extractEpisodeNumber(String episodeUrl) {
    // Extraer el número del episodio de la URL
    // Ejemplo: "https://rickandmortyapi.com/api/episode/1" -> "1"
    final parts = episodeUrl.split('/');
    return parts.last;
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'alive':
        return Colors.green;
      case 'dead':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'alive':
        return 'Vivo';
      case 'dead':
        return 'Muerto';
      default:
        return 'Desconocido';
    }
  }
}
