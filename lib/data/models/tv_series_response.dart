import 'package:movie_app/data/models/tv_series_model.dart';

class TvSeriesResponse {
  const TvSeriesResponse({required this.tvSeriesList});

  final List<TvSeriesModel> tvSeriesList;

  factory TvSeriesResponse.fromJson(Map<String, dynamic> json) =>
      TvSeriesResponse(
        tvSeriesList: List<TvSeriesModel>.from(
          (json['results'] ?? []).map((x) => TvSeriesModel.fromJson(x)),
        ),
      );
}
