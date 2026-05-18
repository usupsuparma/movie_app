import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app/data/models/genre_model.dart';
import 'package:movie_app/data/models/movie_detail_model.dart';
import 'package:movie_app/domain/entities/genre.dart';
import 'package:movie_app/domain/entities/movie_detail.dart';

void main() {
  test('MovieDetailResponse should parse json and convert to entity', () {
    const json = {
      'adult': false,
      'backdrop_path': '/backdrop.jpg',
      'budget': 100,
      'genres': [
        {'id': 1, 'name': 'Action'},
      ],
      'homepage': 'https://example.com',
      'id': 1,
      'imdb_id': 'tt0000001',
      'original_language': 'en',
      'original_title': 'Original Title',
      'overview': 'Overview',
      'popularity': 100.0,
      'poster_path': '/poster.jpg',
      'release_date': '2024-01-01',
      'revenue': 200,
      'runtime': 120,
      'status': 'Released',
      'tagline': 'Tagline',
      'title': 'Movie Title',
      'video': false,
      'vote_average': 8.5,
      'vote_count': 300,
    };

    final model = MovieDetailResponse.fromJson(json);
    final expected = MovieDetailResponse(
      adult: false,
      backdropPath: '/backdrop.jpg',
      budget: 100,
      genres: [GenreModel(id: 1, name: 'Action')],
      homepage: 'https://example.com',
      id: 1,
      imdbId: 'tt0000001',
      originalLanguage: 'en',
      originalTitle: 'Original Title',
      overview: 'Overview',
      popularity: 100.0,
      posterPath: '/poster.jpg',
      releaseDate: '2024-01-01',
      revenue: 200,
      runtime: 120,
      status: 'Released',
      tagline: 'Tagline',
      title: 'Movie Title',
      video: false,
      voteAverage: 8.5,
      voteCount: 300,
    );
    final expectedEntity = MovieDetail(
      adult: false,
      backdropPath: '/backdrop.jpg',
      genres: [Genre(id: 1, name: 'Action')],
      id: 1,
      originalTitle: 'Original Title',
      overview: 'Overview',
      posterPath: '/poster.jpg',
      releaseDate: '2024-01-01',
      runtime: 120,
      title: 'Movie Title',
      voteAverage: 8.5,
      voteCount: 300,
    );

    expect(model, equals(expected));
    expect(model.toJson(), json);
    expect(model.toEntity(), expectedEntity);
  });
}
