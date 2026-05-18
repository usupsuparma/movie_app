import 'package:equatable/equatable.dart';
import 'package:movie_app/domain/entities/tv_series.dart';
import 'package:movie_app/domain/entities/tv_series_detail.dart';

class TvSeriesTable extends Equatable {
  static const tvMediaType = 'tv';

  const TvSeriesTable({
    required this.id,
    required this.name,
    required this.posterPath,
    required this.overview,
    this.mediaType = tvMediaType,
  });

  final int id;
  final String? name;
  final String? posterPath;
  final String? overview;
  final String mediaType;

  factory TvSeriesTable.fromEntity(TvSeriesDetail tvSeries) => TvSeriesTable(
    id: tvSeries.id,
    name: tvSeries.name,
    posterPath: tvSeries.posterPath,
    overview: tvSeries.overview,
  );

  factory TvSeriesTable.fromMap(Map<String, dynamic> map) => TvSeriesTable(
    id: map['id'],
    name: map['title'],
    posterPath: map['posterPath'],
    overview: map['overview'],
    mediaType: map['mediaType'] ?? tvMediaType,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': name,
    'posterPath': posterPath,
    'overview': overview,
    'mediaType': mediaType,
  };

  TvSeries toEntity() => TvSeries.watchlist(
    id: id,
    name: name,
    overview: overview,
    posterPath: posterPath,
  );

  @override
  List<Object?> get props => [id, name, posterPath, overview, mediaType];
}
