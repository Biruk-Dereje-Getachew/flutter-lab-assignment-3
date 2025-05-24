import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models.dart';

class AlbumService {
  final String albumsUrl = 'https://jsonplaceholder.typicode.com/albums';
  final String photosUrl = 'https://jsonplaceholder.typicode.com/photos';

  Future<List<Album>> fetchAlbums() async {
    final response = await http.get(Uri.parse(albumsUrl));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Album.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load albums');
    }
  }

  Future<List<Photo>> fetchPhotos() async {
    final response = await http.get(Uri.parse(photosUrl));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Photo.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load photos');
    }
  }

  Future<List<Photo>> fetchPhotosByAlbumId(int albumId) async {
    final response = await http.get(Uri.parse('$photosUrl?albumId=$albumId'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Photo.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load album photos');
    }
  }
}
