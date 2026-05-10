import 'package:equatable/equatable.dart';

class TvSeries extends Equatable {
  const TvSeries({
    required this.id,
    required this.name,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.genreIds,
    required this.originalName,
    required this.firstAirDate,
    required this.popularity,
    required this.voteAverage,
    required this.voteCount,
  });

  const TvSeries.watchlist({
    required this.id,
    required this.name,
    required this.overview,
    required this.posterPath,
  })  : backdropPath = null,
        genreIds = null,
        originalName = null,
        firstAirDate = null,
        popularity = null,
        voteAverage = null,
        voteCount = null;

  final int id;
  final String? name;
  final String? overview;
  final String? posterPath;
  final String? backdropPath;
  final List<int>? genreIds;
  final String? originalName;
  final String? firstAirDate;
  final double? popularity;
  final double? voteAverage;
  final int? voteCount;

  @override
  List<Object?> get props => [
        id,
        name,
        overview,
        posterPath,
        backdropPath,
        genreIds,
        originalName,
        firstAirDate,
        popularity,
        voteAverage,
        voteCount,
      ];
}