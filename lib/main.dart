import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'album_service.dart';
import 'album_bloc.dart';
import 'album_list_screen.dart';
import 'album_detail_screen.dart';
import 'models.dart';

// ViewModel for Album List (using Bloc)
class AlbumListViewModel {
  final AlbumListBloc bloc;
  AlbumListViewModel(AlbumService service) : bloc = AlbumListBloc(service);
}

// ViewModel for Album Detail (using Bloc)
class AlbumDetailViewModel {
  final AlbumDetailBloc bloc;
  AlbumDetailViewModel(AlbumService service) : bloc = AlbumDetailBloc(service);
}

void main() {
  final albumService = AlbumService();
  runApp(MyApp(albumService: albumService));
}

class MyApp extends StatelessWidget {
  final AlbumService albumService;
  const MyApp({super.key, required this.albumService});

  @override
  Widget build(BuildContext context) {
    final GoRouter _router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => BlocProvider(
            create: (_) =>
                AlbumListViewModel(albumService).bloc..add(FetchAlbums()),
            child: AlbumListScreen(
              onAlbumTap: (context, album) {
                context.push('/detail', extra: album);
              },
            ),
          ),
        ),
        GoRoute(
          path: '/detail',
          builder: (context, state) {
            final album = state.extra as Album;
            return BlocProvider(
              create: (_) =>
                  AlbumDetailViewModel(albumService).bloc
                    ..add(FetchAlbumDetail(album)),
              child: AlbumDetailScreen(album: album),
            );
          },
        ),
      ],
    );
    return MaterialApp.router(
      title: 'Flutter Album App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      routerConfig: _router,
    );
  }
}
