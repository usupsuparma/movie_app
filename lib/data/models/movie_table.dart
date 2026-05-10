
import 'package:equatable/equatable.dart';
import 'package:movie_app/domain/entities/movie.dart';
import 'package:movie_app/domain/entities/movie_detail.dart';

class MovieTable extends Equatable {
  static const movieMediaType = 'movie';

  final int id;
  final String? title;
  final String? posterPath;
  final String? overview;
  final String mediaType;

  MovieTable({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.overview,
    this.mediaType = movieMediaType,
  });

  factory MovieTable.fromEntity(MovieDetail movie) => MovieTable(
        id: movie.id,
        title: movie.title,
        posterPath: movie.posterPath,
        overview: movie.overview,
      );

  factory MovieTable.fromMap(Map<String, dynamic> map) => MovieTable(
        id: map['id'],
        title: map['title'],
        posterPath: map['posterPath'],
        overview: map['overview'],
        mediaType: map['mediaType'] ?? movieMediaType,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'posterPath': posterPath,
        'overview': overview,
        'mediaType': mediaType,
      };

  Movie toEntity() => Movie.watchlist(
        id: id,
        overview: overview,
        posterPath: posterPath,
        title: title,
      );

  @override
  List<Object?> get props => [id, title, posterPath, overview, mediaType];
}
