import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:g/common/exception.dart';
import 'package:g/data/datasources/tv_series_remote_data_source.dart';

class FakeHttpClient extends http.BaseClient {
  final Map<String, http.Response> responses = {};

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final response = responses[request.url.toString()];
    if (response == null) {
      throw Exception('No stub for ${request.url}');
    }

    return http.StreamedResponse(
      Stream.value(Uint8List.fromList(response.bodyBytes)),
      response.statusCode,
      headers: response.headers,
    );
  }
}

void main() {
  late TvSeriesRemoteDataSourceImpl dataSource;
  late FakeHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = FakeHttpClient();
    dataSource = TvSeriesRemoteDataSourceImpl(client: mockHttpClient);
  });

  const apiKey = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  const baseUrl = 'https://api.themoviedb.org/3';
  final responseBody = json.encode({
    'results': [
      {
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
      },
    ],
  });

  final detailBody = json.encode({
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
  });

  group('getOnTheAirTvSeries', () {
    test(
      'should return list of tv series models when response code is 200',
      () async {
        mockHttpClient.responses['$baseUrl/tv/on_the_air?$apiKey'] =
            http.Response(responseBody, 200);

        final result = await dataSource.getOnTheAirTvSeries();

        expect(result.length, 1);
        expect(result.first.name, 'Sample TV Series');
      },
    );

    test(
      'should throw ServerException when response code is not 200',
      () async {
        mockHttpClient.responses['$baseUrl/tv/on_the_air?$apiKey'] =
            http.Response('Not Found', 404);

        expect(
          () => dataSource.getOnTheAirTvSeries(),
          throwsA(isA<ServerException>()),
        );
      },
    );
  });

  test('getPopularTvSeries should hit popular endpoint', () async {
    mockHttpClient.responses['$baseUrl/tv/popular?$apiKey'] = http.Response(
      responseBody,
      200,
    );

    final result = await dataSource.getPopularTvSeries();

    expect(result.first.id, 1);
  });

  test('getPopularTvSeries should throw ServerException on error', () async {
    mockHttpClient.responses['$baseUrl/tv/popular?$apiKey'] = http.Response(
      'Not Found',
      404,
    );

    expect(
      () => dataSource.getPopularTvSeries(),
      throwsA(isA<ServerException>()),
    );
  });

  test('getTopRatedTvSeries should hit top rated endpoint', () async {
    mockHttpClient.responses['$baseUrl/tv/top_rated?$apiKey'] = http.Response(
      responseBody,
      200,
    );

    final result = await dataSource.getTopRatedTvSeries();

    expect(result.first.voteAverage, 8.5);
  });

  test('getTopRatedTvSeries should throw ServerException on error', () async {
    mockHttpClient.responses['$baseUrl/tv/top_rated?$apiKey'] = http.Response(
      'Not Found',
      500,
    );

    expect(
      () => dataSource.getTopRatedTvSeries(),
      throwsA(isA<ServerException>()),
    );
  });

  test('getTvSeriesDetail should return tv series detail response', () async {
    mockHttpClient.responses['$baseUrl/tv/1?$apiKey'] = http.Response(
      detailBody,
      200,
    );

    final result = await dataSource.getTvSeriesDetail(1);

    expect(result.name, 'Sample TV Series');
    expect(result.numberOfEpisodes, 8);
  });

  test('getTvSeriesDetail should throw ServerException on error', () async {
    mockHttpClient.responses['$baseUrl/tv/1?$apiKey'] = http.Response(
      'Not Found',
      404,
    );

    expect(
      () => dataSource.getTvSeriesDetail(1),
      throwsA(isA<ServerException>()),
    );
  });

  test(
    'getTvSeriesRecommendations should return list of recommendations',
    () async {
      mockHttpClient.responses['$baseUrl/tv/1/recommendations?$apiKey'] =
          http.Response(responseBody, 200);

      final result = await dataSource.getTvSeriesRecommendations(1);

      expect(result, isNotEmpty);
    },
  );

  test(
    'getTvSeriesRecommendations should throw ServerException on error',
    () async {
      mockHttpClient.responses['$baseUrl/tv/1/recommendations?$apiKey'] =
          http.Response('Not Found', 500);

      expect(
        () => dataSource.getTvSeriesRecommendations(1),
        throwsA(isA<ServerException>()),
      );
    },
  );

  test('searchTvSeries should return search results', () async {
    mockHttpClient.responses['$baseUrl/search/tv?$apiKey&query=query'] =
        http.Response(responseBody, 200);

    final result = await dataSource.searchTvSeries('query');

    expect(result.first.name, 'Sample TV Series');
  });

  test('searchTvSeries should throw ServerException on error', () async {
    mockHttpClient.responses['$baseUrl/search/tv?$apiKey&query=query'] =
        http.Response('Not Found', 404);

    expect(
      () => dataSource.searchTvSeries('query'),
      throwsA(isA<ServerException>()),
    );
  });
}
