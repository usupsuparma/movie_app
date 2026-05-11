import 'package:equatable/equatable.dart';
import 'package:g/data/models/genre_model.dart';
import 'package:g/data/models/season_model.dart';
import 'package:g/domain/entities/tv_series_detail.dart';

class TvSeriesDetailResponse extends Equatable {
  const TvSeriesDetailResponse({
    required this.backdropPath,
    required this.episodeRunTime,
    required this.firstAirDate,
    required this.genres,
    required this.id,
    required this.name,
    required this.numberOfEpisodes,
    required this.numberOfSeasons,
    required this.originalName,
    required this.overview,
    required this.posterPath,
    required this.seasons,
    required this.voteAverage,
    required this.voteCount,
  });

  final String? backdropPath;
  final List<int> episodeRunTime;
  final String firstAirDate;
  final List<GenreModel> genres;
  final int id;
  final String name;
  final int numberOfEpisodes;
  final int numberOfSeasons;
  final String originalName;
  final String overview;
  final String posterPath;
  final List<SeasonModel> seasons;
  final double voteAverage;
  final int voteCount;

  factory TvSeriesDetailResponse.fromJson(Map<String, dynamic> json) =>
      TvSeriesDetailResponse(
        backdropPath: json['backdrop_path'],
        episodeRunTime: List<int>.from((json['episode_run_time'] ?? []).map((x) => x)),
        firstAirDate: json['first_air_date'] ?? '',
        genres: List<GenreModel>.from(
          (json['genres'] ?? []).map((x) => GenreModel.fromJson(x)),
        ),
        id: json['id'],
        name: json['name'] ?? '',
        numberOfEpisodes: json['number_of_episodes'] ?? 0,
        numberOfSeasons: json['number_of_seasons'] ?? 0,
        originalName: json['original_name'] ?? '',
        overview: json['overview'] ?? '',
        posterPath: json['poster_path'] ?? '',
        seasons: List<SeasonModel>.from(
          (json['seasons'] ?? []).map((x) => SeasonModel.fromJson(x)),
        ),
        voteAverage: (json['vote_average'] ?? 0).toDouble(),
        voteCount: json['vote_count'] ?? 0,
      );

  TvSeriesDetail toEntity() => TvSeriesDetail(
        backdropPath: backdropPath,
        episodeRunTime: episodeRunTime,
        firstAirDate: firstAirDate,
        genres: genres.map((genre) => genre.toEntity()).toList(),
        id: id,
        name: name,
        numberOfEpisodes: numberOfEpisodes,
        numberOfSeasons: numberOfSeasons,
        originalName: originalName,
        overview: overview,
        posterPath: posterPath,
        seasons: seasons.map((season) => season.toEntity()).toList(),
        voteAverage: voteAverage,
        voteCount: voteCount,
      );

  @override
  List<Object?> get props => [
        backdropPath,
        episodeRunTime,
        firstAirDate,
        genres,
        id,
        name,
        numberOfEpisodes,
        numberOfSeasons,
        originalName,
        overview,
        posterPath,
        seasons,
        voteAverage,
        voteCount,
      ];
}
