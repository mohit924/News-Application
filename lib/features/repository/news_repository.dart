import 'package:news_app/features/model/article_model.dart';

abstract class NewsRepository {
  Future<List<Article>> getNews(String category, int page);

  Future<List<Article>> searchNews(String query, int page);
}
