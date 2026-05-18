import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app/data/models/genre_model.dart';
import 'package:movie_app/data/models/season_model.dart';
import 'package:movie_app/data/models/tv_series_detail_model.dart';
import 'package:movie_app/data/models/tv_series_model.dart';
import 'package:movie_app/domain/entities/genre.dart';
import 'package:movie_app/domain/entities/season.dart';
import 'package:movie_app/domain/entities/tv_series.dart';
import 'package:movie_app/domain/entities/tv_series_detail.dart';

void main() {
  test('TvSeriesModel should parse json and convert to entity', () {
    const json = {
      'backdrop_path': '/backdrop.jpg',
      'first_air_date': '2024-01-01',
      'genre_ids': [1, 2],
      'id': 1,
      'name': 'Sample TV Series',
      'original_name': 'Sample TV Series Original',
      'overview': 'Overview',
      'popularity': 100.0,
      'poster_path': '/poster.jpg',
      'vote_average': 8.5,
      'vote_count': 200,
    };

    final model = TvSeriesModel.fromJson(json);
    final expected = TvSeriesModel(
      backdropPath: '/backdrop.jpg',
      firstAirDate: '2024-01-01',
      genreIds: const [1, 2],
      id: 1,
      name: 'Sample TV Series',
      originalName: 'Sample TV Series Original',
      overview: 'Overview',
      popularity: 100.0,
      posterPath: '/poster.jpg',
      voteAverage: 8.5,
      voteCount: 200,
    );
    final expectedEntity = TvSeries(
      id: 1,
      name: 'Sample TV Series',
      overview: 'Overview',
      posterPath: '/poster.jpg',
      backdropPath: '/backdrop.jpg',
      genreIds: const [1, 2],
      originalName: 'Sample TV Series Original',
      firstAirDate: '2024-01-01',
      popularity: 100.0,
      voteAverage: 8.5,
      voteCount: 200,
    );

    expect(model, equals(expected));
    expect(model.toEntity(), expectedEntity);
  });

  test('TvSeriesDetailResponse should parse json and convert to entity', () {
    const json = {
      'backdrop_path': '/backdrop.jpg',
      'episode_run_time': [45],
      'first_air_date': '2024-01-01',
      'genres': [
        {'id': 1, 'name': 'Drama'},
      ],
      'id': 1,
      'name': 'Sample TV Series',
      'number_of_episodes': 8,
      'number_of_seasons': 1,
      'original_name': 'Sample TV Series Original',
      'overview': 'Overview',
      'poster_path': '/poster.jpg',
      'seasons': [
        {
          'id': 10,
          'name': 'Season 1',
          'episode_count': 8,
          'season_number': 1,
          'air_date': '2024-01-01',
          'poster_path': '/season.jpg',
        },
      ],
      'vote_average': 8.5,
      'vote_count': 200,
    };

    final response = TvSeriesDetailResponse.fromJson(json);
    final expected = TvSeriesDetailResponse(
      backdropPath: '/backdrop.jpg',
      episodeRunTime: const [45],
      firstAirDate: '2024-01-01',
      genres: [GenreModel(id: 1, name: 'Drama')],
      id: 1,
      name: 'Sample TV Series',
      numberOfEpisodes: 8,
      numberOfSeasons: 1,
      originalName: 'Sample TV Series Original',
      overview: 'Overview',
      posterPath: '/poster.jpg',
      seasons: [
        const SeasonModel(
          id: 10,
          name: 'Season 1',
          episodeCount: 8,
          seasonNumber: 1,
          airDate: '2024-01-01',
          posterPath: '/season.jpg',
        ),
      ],
      voteAverage: 8.5,
      voteCount: 200,
    );
    final expectedEntity = TvSeriesDetail(
      backdropPath: '/backdrop.jpg',
      episodeRunTime: const [45],
      firstAirDate: '2024-01-01',
      genres: [Genre(id: 1, name: 'Drama')],
      id: 1,
      name: 'Sample TV Series',
      numberOfEpisodes: 8,
      numberOfSeasons: 1,
      originalName: 'Sample TV Series Original',
      overview: 'Overview',
      posterPath: '/poster.jpg',
      seasons: [
        const Season(
          id: 10,
          name: 'Season 1',
          episodeCount: 8,
          seasonNumber: 1,
          airDate: '2024-01-01',
          posterPath: '/season.jpg',
        ),
      ],
      voteAverage: 8.5,
      voteCount: 200,
    );

    expect(response, equals(expected));
    expect(response.toEntity(), expectedEntity);
  });

  test('GenreModel should parse, serialize, and compare correctly', () {
    final model = GenreModel.fromJson(const {'id': 1, 'name': 'Drama'});
    final other = GenreModel(id: 1, name: 'Drama');
    final expectedEntity = Genre(id: 1, name: 'Drama');

    expect(model, equals(other));
    expect(model.toJson(), {'id': 1, 'name': 'Drama'});
    expect(model.toEntity(), expectedEntity);
  });

  test('SeasonModel should parse json and convert to entity', () {
    final model = SeasonModel.fromJson(const {
      'id': 10,
      'name': 'Season 1',
      'episode_count': 8,
      'season_number': 1,
      'air_date': '2024-01-01',
      'poster_path': '/season.jpg',
    });

    final expected = const SeasonModel(
      id: 10,
      name: 'Season 1',
      episodeCount: 8,
      seasonNumber: 1,
      airDate: '2024-01-01',
      posterPath: '/season.jpg',
    );
    final expectedEntity = const Season(
      id: 10,
      name: 'Season 1',
      episodeCount: 8,
      seasonNumber: 1,
      airDate: '2024-01-01',
      posterPath: '/season.jpg',
    );

    expect(model, equals(expected));
    expect(model.toEntity(), expectedEntity);
  });
}
