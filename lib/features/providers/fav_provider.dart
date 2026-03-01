import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:news_app/features/core/local/auth_local_storage.dart';
import 'package:news_app/features/core/local/favorites_storage.dart';
import '../model/article_model.dart';

final favProvider = StateNotifierProvider.autoDispose<FavNotifier, Set<String>>(
  (ref) {
    final authStorage = AuthLocalStorage();
    final userId = authStorage.getCurrentUser() ?? 'guest';
    return FavNotifier(userId: userId);
  },
);

class FavNotifier extends StateNotifier<Set<String>> {
  late final FavoritesStorage storage;

  FavNotifier({required String userId}) : super({}) {
    storage = FavoritesStorage(userId: userId);
    load();
  }

  void load() {
    final favs = storage.getAll();
    state = favs.map((e) => e.url).toSet();
  }

  Future<void> toggle(Article article) async {
    await storage.toggle(article);
    if (state.contains(article.url)) {
      state = {...state}..remove(article.url);
    } else {
      state = {...state, article.url};
    }
  }

  bool isFav(Article article) => state.contains(article.url);

  List<Article> getAllFavArticles() {
    return storage.getAll();
  }
}
