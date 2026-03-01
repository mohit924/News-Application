import 'package:hive/hive.dart';
import 'package:news_app/features/model/article_model.dart';

class FavoritesStorage {
  final _box = Hive.box('favBox');
  final String userId;

  FavoritesStorage({required this.userId});

  String _key(Article a) => '${userId}__${a.url}';

  Future<void> toggle(Article article) async {
    final key = _key(article);
    if (_box.containsKey(key)) {
      await _box.delete(key);
    } else {
      await _box.put(key, article.toJson());
    }
  }

  bool isFav(Article article) => _box.containsKey(_key(article));

  List<Article> getAll() {
    final prefix = '${userId}__';
    return _box.keys
        .where((k) => k.toString().startsWith(prefix))
        .map((k) => Article.fromJson(Map<String, dynamic>.from(_box.get(k))))
        .toList();
  }
}
