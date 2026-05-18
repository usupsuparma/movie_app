import 'package:equatable/equatable.dart';
import 'package:movie_app/domain/entities/season.dart';

class SeasonModel extends Equatable {
  const SeasonModel({
    required this.id,
    required this.name,
    required this.episodeCount,
    required this.seasonNumber,
    this.airDate,
    this.posterPath,
  });

  final int id;
  final String name;
  final int episodeCount;
  final int seasonNumber;
  final String? airDate;
  final String? posterPath;

  factory SeasonModel.fromJson(Map<String, dynamic> json) => SeasonModel(
    id: json['id'],
    name: json['name'] ?? '',
    episodeCount: json['episode_count'] ?? 0,
    seasonNumber: json['season_number'] ?? 0,
    airDate: json['air_date'],
    posterPath: json['poster_path'],
  );

  Season toEntity() => Season(
    id: id,
    name: name,
    episodeCount: episodeCount,
    seasonNumber: seasonNumber,
    airDate: airDate,
    posterPath: posterPath,
  );

  @override
  List<Object?> get props => [
    id,
    name,
    episodeCount,
    seasonNumber,
    airDate,
    posterPath,
  ];
}
