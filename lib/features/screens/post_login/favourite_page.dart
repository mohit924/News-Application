import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:news_app/constants/app_colors.dart';
import 'package:news_app/constants/app_strings.dart';
import 'package:news_app/features/providers/fav_provider.dart';
import 'package:news_app/features/screens/post_login/news_card.dart';

class FavouritePage extends ConsumerWidget {
  const FavouritePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(favProvider);
    final favArticles = ref.read(favProvider.notifier).getAllFavArticles();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [

          SliverAppBar(
            expandedHeight: 110,
            floating: true,
            snap: true,
            pinned: false,
            backgroundColor: AppColors.primary,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.gradientStart, AppColors.gradientEnd],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.18),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.favorite_rounded,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              AppStrings.favouritesTitle,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              '${favArticles.length} article${favArticles.length == 1 ? '' : 's'}',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              collapseMode: CollapseMode.pin,
            ),
          ),

if (favArticles.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.08),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite_border_rounded,
                        color: AppColors.primary,
                        size: 38,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      AppStrings.favouritesEmptyTitle,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      AppStrings.favouritesEmptySubtitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textMedium,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            )

          else
            SliverList(
              delegate: SliverChildBuilderDelegate((_, i) {
                final article = favArticles[i];
                return NewsCard(
                  article: article,
                  isFav: true,
                  onFav: () => ref.read(favProvider.notifier).toggle(article),
                  onTap: () => context.push('/app/details', extra: article),
                );
              }, childCount: favArticles.length),
            ),

          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }
}
