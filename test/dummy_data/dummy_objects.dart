import 'package:movie_app/data/models/movie_table.dart';
import 'package:movie_app/domain/entities/genre.dart';
import 'package:movie_app/data/models/genre_model.dart';
import 'package:movie_app/data/models/season_model.dart';
import 'package:movie_app/data/models/tv_series_detail_model.dart';
import 'package:movie_app/data/models/tv_series_model.dart';
import 'package:movie_app/data/models/tv_series_table.dart';
import 'package:movie_app/domain/entities/movie.dart';
import 'package:movie_app/domain/entities/movie_detail.dart';
import 'package:movie_app/domain/entities/season.dart';
import 'package:movie_app/domain/entities/tv_series.dart';
import 'package:movie_app/domain/entities/tv_series_detail.dart';

final testMovie = Movie(
  adult: false,
  backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
  genreIds: [14, 28],
  id: 557,
  originalTitle: 'Spider-Man',
  overview:
      'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
  popularity: 60.441,
  posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
  releaseDate: '2002-05-01',
  title: 'Spider-Man',
  video: false,
  voteAverage: 7.2,
  voteCount: 13507,
);

final testMovieList = [testMovie];

final testMovieDetail = MovieDetail(
  adult: false,
  backdropPath: 'backdropPath',
  genres: [Genre(id: 1, name: 'Action')],
  id: 1,
  originalTitle: 'originalTitle',
  overview: 'overview',
  posterPath: 'posterPath',
  releaseDate: 'releaseDate',
  runtime: 120,
  title: 'title',
  voteAverage: 1,
  voteCount: 1,
);

final testWatchlistMovie = Movie.watchlist(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testMovieTable = MovieTable(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testMovieMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'title': 'title',
  'mediaType': MovieTable.movieMediaType,
};

const tTvSeries = TvSeries(
  id: 1,
  name: 'name',
  overview: 'overview',
  posterPath: 'posterPath',
  backdropPath: 'backdropPath',
  genreIds: [1, 2],
  originalName: 'originalName',
  firstAirDate: '2020-01-01',
  popularity: 12.3,
  voteAverage: 8.1,
  voteCount: 1200,
);

const tTvSeriesList = [tTvSeries];

const tTvSeriesModel = TvSeriesModel(
  id: 1,
  name: 'name',
  overview: 'overview',
  posterPath: 'posterPath',
  backdropPath: 'backdropPath',
  genreIds: [1, 2],
  originalName: 'originalName',
  firstAirDate: '2020-01-01',
  popularity: 12.3,
  voteAverage: 8.1,
  voteCount: 1200,
);

const tTvSeriesModelList = [tTvSeriesModel];

final tTvSeriesDetail = TvSeriesDetail(
  backdropPath: 'backdropPath',
  episodeRunTime: [45],
  firstAirDate: '2020-01-01',
  genres: [Genre(id: 1, name: 'Drama')],
  id: 1,
  name: 'name',
  numberOfEpisodes: 10,
  numberOfSeasons: 1,
  originalName: 'originalName',
  overview: 'overview',
  posterPath: 'posterPath',
  seasons: [
    Season(
      airDate: '2020-01-01',
      episodeCount: 10,
      id: 11,
      name: 'Season 1',
      posterPath: 'posterPath',
      seasonNumber: 1,
    ),
  ],
  voteAverage: 8.1,
  voteCount: 1200,
);

final tTvSeriesDetailResponse = TvSeriesDetailResponse(
  backdropPath: 'backdropPath',
  episodeRunTime: [45],
  firstAirDate: '2020-01-01',
  genres: [GenreModel(id: 1, name: 'Drama')],
  id: 1,
  name: 'name',
  numberOfEpisodes: 10,
  numberOfSeasons: 1,
  originalName: 'originalName',
  overview: 'overview',
  posterPath: 'posterPath',
  seasons: [
    SeasonModel(
      airDate: '2020-01-01',
      episodeCount: 10,
      id: 11,
      name: 'Season 1',
      posterPath: 'posterPath',
      seasonNumber: 1,
    ),
  ],
  voteAverage: 8.1,
  voteCount: 1200,
);

const tTvSeriesTable = TvSeriesTable(
  id: 1,
  name: 'name',
  posterPath: 'posterPath',
  overview: 'overview',
);

const tTvSeriesMap = {
  'id': 1,
  'title': 'name',
  'posterPath': 'posterPath',
  'overview': 'overview',
  'mediaType': TvSeriesTable.tvMediaType,
};
