import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty/app/app_module.dart';
import 'package:rick_and_morty/features/characteres/presentation/bloc/characters_bloc.dart';
import 'package:rick_and_morty/features/characteres/presentation/widgets/character_card.dart';

class CharactersPage extends StatefulWidget {
  const CharactersPage({super.key});

  @override
  State<CharactersPage> createState() => _CharactersPageState();
}

class _CharactersPageState extends State<CharactersPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          CharactersBloc(getCharactersUseCase)
            ..add(const LoadCharactersEvent(page: 1)),
      child: const _CharactersView(),
    );
  }
}

class _CharactersView extends StatefulWidget {
  const _CharactersView();

  @override
  State<_CharactersView> createState() => _CharactersViewState();
}

class _CharactersViewState extends State<_CharactersView> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      final state = context.read<CharactersBloc>().state;
      // Solo cargar más si no estamos cargando y no hemos alcanzado el máximo
      if (state is CharactersLoaded && !state.hasReachedMax) {
        // Cargar más personajes cuando llegamos al final (null = siguiente página)
        context.read<CharactersBloc>().add(const LoadCharactersEvent());
      }
    }
  }

  void _onSearchChanged(String query) {
    // Usar un debounce para evitar búsquedas excesivas
    Future.delayed(const Duration(milliseconds: 500), () {
      if (_searchController.text == query) {
        context.read<CharactersBloc>().add(SearchCharactersEvent(query));
      }
    });
  }

  void _clearSearch() {
    _searchController.clear();
    context.read<CharactersBloc>().add(const SearchCharactersEvent(''));
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  Future<void> _onRefresh() async {
    // Resetear y cargar desde el inicio
    final bloc = context.read<CharactersBloc>();
    bloc.add(const LoadCharactersEvent(page: 1));
    // Esperar un momento para que el estado se actualice
    await Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personajes'),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ValueListenableBuilder<TextEditingValue>(
              valueListenable: _searchController,
              builder: (context, value, child) {
                return TextField(
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  decoration: InputDecoration(
                    hintText: 'Buscar personaje...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: value.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: _clearSearch,
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Theme.of(context).cardColor,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  onChanged: _onSearchChanged,
                  textInputAction: TextInputAction.search,
                  onSubmitted: (query) {
                    context.read<CharactersBloc>().add(SearchCharactersEvent(query));
                  },
                );
              },
            ),
          ),
        ),
      ),
      body: BlocBuilder<CharactersBloc, CharactersState>(
        builder: (context, state) {
          if (state is CharactersInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CharactersError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<CharactersBloc>().add(
                        const LoadCharactersEvent(),
                      );
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          if (state is CharactersLoaded) {
            if (state.characters.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      'No se encontraron personajes',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: _onRefresh,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Recargar'),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: _onRefresh,
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: state.hasReachedMax
                    ? state.characters.length
                    : state.characters.length + (state.isLoadingMore ? 1 : 0),
                itemBuilder: (context, index) {
                  // Mostrar indicador de carga al final solo si isLoadingMore es true
                  if (index >= state.characters.length && state.isLoadingMore) {
                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  final character = state.characters[index];
                  return CharacterCard(
                    character: character,
                    onTap: () {
                      // TODO: Navegar a detalle del personaje
                      // Navigator.push(context, ...);
                    },
                  );
                },
              ),
            );
          }

          // Si es CharactersLoading pero no CharactersLoaded, mostrar loading
          if (state is CharactersLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
