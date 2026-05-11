import 'package:equatable/equatable.dart';
import 'package:g/domain/entities/tv_series.dart';

class TvSeriesModel extends Equatable {
  const TvSeriesModel({
    required this.backdropPath,
    required this.firstAirDate,
    required this.genreIds,
    required this.id,
    required this.name,
    required this.originalName,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.voteAverage,
    required this.voteCount,
  });

  final String? backdropPath;
  final String? firstAirDate;
  final List<int> genreIds;
  final int id;
  final String name;
  final String originalName;
  final String overview;
  final double popularity;
  final String? posterPath;
  final double voteAverage;
  final int voteCount;

  factory TvSeriesModel.fromJson(Map<String, dynamic> json) => TvSeriesModel(
        backdropPath: json['backdrop_path'],
        firstAirDate: json['first_air_date'],
        genreIds: List<int>.from((json['genre_ids'] ?? []).map((x) => x)),
        id: json['id'],
        name: json['name'] ?? '',
        originalName: json['original_name'] ?? '',
        overview: json['overview'] ?? '',
        popularity: (json['popularity'] ?? 0).toDouble(),
        posterPath: json['poster_path'],
        voteAverage: (json['vote_average'] ?? 0).toDouble(),
        voteCount: json['vote_count'] ?? 0,
      );

  TvSeries toEntity() => TvSeries(
        id: id,
        name: name,
        overview: overview,
        posterPath: posterPath,
        backdropPath: backdropPath,
        genreIds: genreIds,
        originalName: originalName,
        firstAirDate: firstAirDate,
        popularity: popularity,
        voteAverage: voteAverage,
        voteCount: voteCount,
      );

  @override
  List<Object?> get props => [
        backdropPath,
        firstAirDate,
        genreIds,
        id,
        name,
        originalName,
        overview,
        popularity,
        posterPath,
        voteAverage,
        voteCount,
      ];
}
