import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'album_service.dart';
import 'models.dart';

// Album List Bloc
abstract class AlbumListEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchAlbums extends AlbumListEvent {}

abstract class AlbumListState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AlbumListInitial extends AlbumListState {}

class AlbumListLoading extends AlbumListState {}

class AlbumListLoaded extends AlbumListState {
  final List<Album> albums;
  final Map<int, Photo> albumThumbnails;
  AlbumListLoaded(this.albums, this.albumThumbnails);
  @override
  List<Object?> get props => [albums, albumThumbnails];
}

class AlbumListError extends AlbumListState {
  final String message;
  AlbumListError(this.message);
  @override
  List<Object?> get props => [message];
}

class AlbumListBloc extends Bloc<AlbumListEvent, AlbumListState> {
  final AlbumService service;
  AlbumListBloc(this.service) : super(AlbumListInitial()) {
    on<FetchAlbums>((event, emit) async {
      emit(AlbumListLoading());
      try {
        final albums = await service.fetchAlbums();
        final photos = await service.fetchPhotos();
        // Map albumId to first photo as thumbnail
        final Map<int, Photo> albumThumbnails = {};
        for (var photo in photos) {
          albumThumbnails.putIfAbsent(photo.albumId, () => photo);
        }
        emit(AlbumListLoaded(albums, albumThumbnails));
      } on http.ClientException {
        emit(
          AlbumListError(
            'Network error: Please check your internet connection.',
          ),
        );
      } on FormatException {
        emit(
          AlbumListError(
            'Data format error: Unable to process server response.',
          ),
        );
      } on TimeoutException {
        emit(AlbumListError('Request timed out. Please try again.'));
      } catch (e) {
        emit(AlbumListError('Unexpected error: ${e.toString()}'));
      }
    });
  }
}

// Album Detail Bloc
abstract class AlbumDetailEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchAlbumDetail extends AlbumDetailEvent {
  final Album album;
  FetchAlbumDetail(this.album);
  @override
  List<Object?> get props => [album];
}

abstract class AlbumDetailState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AlbumDetailInitial extends AlbumDetailState {}

class AlbumDetailLoading extends AlbumDetailState {}

class AlbumDetailLoaded extends AlbumDetailState {
  final Album album;
  final List<Photo> photos;
  AlbumDetailLoaded(this.album, this.photos);
  @override
  List<Object?> get props => [album, photos];
}

class AlbumDetailError extends AlbumDetailState {
  final String message;
  AlbumDetailError(this.message);
  @override
  List<Object?> get props => [message];
}

class AlbumDetailBloc extends Bloc<AlbumDetailEvent, AlbumDetailState> {
  final AlbumService service;
  AlbumDetailBloc(this.service) : super(AlbumDetailInitial()) {
    on<FetchAlbumDetail>((event, emit) async {
      emit(AlbumDetailLoading());
      try {
        final photos = await service.fetchPhotosByAlbumId(event.album.id);
        emit(AlbumDetailLoaded(event.album, photos));
      } on http.ClientException {
        emit(
          AlbumDetailError(
            'Network error: Please check your internet connection.',
          ),
        );
      } on FormatException {
        emit(
          AlbumDetailError(
            'Data format error: Unable to process server response.',
          ),
        );
      } on TimeoutException {
        emit(AlbumDetailError('Request timed out. Please try again.'));
      } catch (e) {
        emit(AlbumDetailError('Unexpected error: ${e.toString()}'));
      }
    });
  }
}
