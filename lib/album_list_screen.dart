import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'album_bloc.dart';
import 'models.dart';

class AlbumListScreen extends StatelessWidget {
  final void Function(BuildContext, Album) onAlbumTap;
  const AlbumListScreen({super.key, required this.onAlbumTap});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Albums')),
      body: BlocBuilder<AlbumListBloc, AlbumListState>(
        buildWhen: (previous, current) {
          // Always rebuild on state change
          return true;
        },
        builder: (context, state) {
          if (state is AlbumListInitial) {
            // Show loading indicator immediately on app start
            return const Center(child: CircularProgressIndicator());
          } else if (state is AlbumListLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AlbumListError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.message}'),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<AlbumListBloc>().add(FetchAlbums()),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (state is AlbumListLoaded) {
            return ListView.builder(
              itemCount: state.albums.length,
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final album = state.albums[index];
                final photo = state.albumThumbnails[album.id];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(4),
                    onTap: () => onAlbumTap(context, album),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (photo != null)
                            Center(
                              child: Image.network(
                                photo.thumbnailUrl,
                                width: 100,
                                height: 100,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Text('Image not found'),
                              ),
                            ),
                          if (photo != null) const SizedBox(height: 8),
                          const Divider(),
                          Text(
                            album.title,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
