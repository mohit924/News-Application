import 'package:dio/dio.dart';
import 'package:news_app/features/model/article_model.dart';
import 'package:news_app/network/api_endpoints.dart';
import 'package:news_app/network/dio_client.dart';
import 'news_repository.dart';

class NewsRepositoryImpl implements NewsRepository {
  final Dio dio = DioClient().dio;

@override
  Future<List<Article>> getNews(String category, int page) async {
    final res = await dio.get(
      ApiEndpoints.topHeadlines,
      queryParameters: {
        "country": "us",
        "category": category,
        "page": page,
        "pageSize": 10,
        "apiKey": ApiEndpoints.apiKey,
      },
    );

    final list = res.data['articles'] as List;

    return list.map((e) => Article.fromJson(e)).toList();
  }

@override
  Future<List<Article>> searchNews(String query, int page) async {
    final res = await dio.get(
      "/everything",
      queryParameters: {
        "q": query,
        "page": page,
        "pageSize": 10,
        "apiKey": ApiEndpoints.apiKey,
      },
    );

    final list = res.data['articles'] as List;

    return list.map((e) => Article.fromJson(e)).toList();
  }
}
