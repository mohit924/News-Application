import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:news_app/features/core/local/auth_local_storage.dart';
import 'package:news_app/constants/app_colors.dart';
import 'package:news_app/constants/app_strings.dart';
import 'package:news_app/features/providers/fav_provider.dart';
import 'package:news_app/features/providers/news_provider.dart';
import 'package:news_app/features/screens/post_login/news_card.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final categories = const [
    'business',
    'technology',
    'sports',
    'health',
    'science',
  ];

  final categoryIcons = const [
    Icons.business_center_outlined,
    Icons.computer_outlined,
    Icons.sports_soccer_outlined,
    Icons.favorite_border_rounded,
    Icons.science_outlined,
  ];

  int selected = 0;
  final controller = ScrollController();

  @override
  void initState() {
    super.initState();

    Future.microtask(
      () => ref.read(newsProvider.notifier).fetch(categories[0]),
    );

    controller.addListener(() {
      if (controller.position.pixels >=
          controller.position.maxScrollExtent - 200) {
        ref.read(newsProvider.notifier).loadMore();
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.logout_rounded,
                  color: AppColors.error,
                  size: 26,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                AppStrings.logoutTitle,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                AppStrings.logoutMessage,
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textMedium, fontSize: 14),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.divider),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text(
                        AppStrings.logoutCancel,
                        style: TextStyle(
                          color: AppColors.textMedium,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.of(dialogContext).pop();
                        await AuthLocalStorage().logout();
                        ref.invalidate(favProvider);
                        if (context.mounted) {
                          context.go('/login');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text(
                        AppStrings.logoutConfirm,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(newsProvider);
    final favs = ref.watch(favProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        color: AppColors.primary,
        backgroundColor: AppColors.surface,
        onRefresh: () => ref.read(newsProvider.notifier).refresh(),
        child: CustomScrollView(
          controller: controller,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverAppBar(
              expandedHeight: 130,
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.newspaper_rounded,
                                color: Colors.white,
                                size: 22,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                AppStrings.appName,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: _confirmLogout,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.18),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(
                                    Icons.logout_rounded,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            AppStrings.homeTitle,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                collapseMode: CollapseMode.pin,
              ),
            ),

            SliverToBoxAdapter(
              child: SizedBox(
                height: 56,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  itemCount: categories.length,
                  itemBuilder: (_, i) {
                    final isSelected = selected == i;
                    return GestureDetector(
                      onTap: () {
                        setState(() => selected = i);
                        ref.read(newsProvider.notifier).fetch(categories[i]);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(right: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          gradient: isSelected
                              ? const LinearGradient(
                                  colors: [
                                    AppColors.gradientStart,
                                    AppColors.gradientEnd,
                                  ],
                                )
                              : null,
                          color: isSelected ? null : AppColors.surface,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: isSelected
                                  ? AppColors.primary.withOpacity(0.3)
                                  : Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                          border: isSelected
                              ? null
                              : Border.all(color: AppColors.divider),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              categoryIcons[i],
                              size: 15,
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.textMedium,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              categories[i][0].toUpperCase() +
                                  categories[i].substring(1),
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.textMedium,
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            if (state.loading && state.articles.isEmpty)
              const SliverFillRemaining(
                child: Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              )
            else
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, i) {
                    if (i >= state.articles.length) {
                      return const Padding(
                        padding: EdgeInsets.all(20),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        ),
                      );
                    }

                    final article = state.articles[i];
                    final isFav = favs.contains(article.url);

                    return NewsCard(
                      article: article,
                      isFav: isFav,
                      onFav: () =>
                          ref.read(favProvider.notifier).toggle(article),
                      onTap: () => context.push('/app/details', extra: article),
                    );
                  },
                  childCount:
                      state.articles.length + (state.loadingMore ? 1 : 0),
                ),
              ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),
          ],
        ),
      ),
    );
  }
}
