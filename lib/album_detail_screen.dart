import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'album_bloc.dart';
import 'models.dart';

class AlbumDetailScreen extends StatelessWidget {
  final Album album;
  const AlbumDetailScreen({super.key, required this.album});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Album Details')),
      body: BlocBuilder<AlbumDetailBloc, AlbumDetailState>(
        builder: (context, state) {
          if (state is AlbumDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AlbumDetailError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.message}'),
                  ElevatedButton(
                    onPressed: () => context.read<AlbumDetailBloc>().add(
                      FetchAlbumDetail(album),
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (state is AlbumDetailLoaded) {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    state.album.title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                ...state.photos.map(
                  (photo) => Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Image.network(
                              photo.thumbnailUrl,
                              width: 100,
                              height: 100,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Text('Image not found'),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Divider(),
                          Text(
                            photo.title,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
