import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:news_app/constants/app_colors.dart';
import 'package:news_app/constants/app_strings.dart';
import 'package:news_app/features/providers/news_provider.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final controller = TextEditingController();
  final scrollController = ScrollController();
  final focusNode = FocusNode();
  Timer? _debounce;

  final suggestions = const [
    'flutter',
    'ai',
    'startup',
    'bitcoin',
    'tesla',
    'india',
    'technology',
    'business',
  ];

  final suggestionIcons = const [
    Icons.code_rounded,
    Icons.smart_toy_outlined,
    Icons.rocket_launch_outlined,
    Icons.currency_bitcoin_outlined,
    Icons.electric_car_outlined,
    Icons.flag_outlined,
    Icons.computer_outlined,
    Icons.business_center_outlined,
  ];

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        ref.read(newsProvider.notifier).loadMoreSearch();
      }
    });

    controller.addListener(_onTyping);
  }

  void _onTyping() {
    final text = controller.text.trim();
    setState(() {});
    _debounce?.cancel();

    if (text.length < 2) return;

    _debounce = Timer(const Duration(milliseconds: 500), () {
      ref.read(newsProvider.notifier).search(text);
    });
  }

  @override
  void dispose() {
    controller.dispose();
    scrollController.dispose();
    focusNode.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(newsProvider);
    final isEmptySearch = controller.text.trim().isEmpty;

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
                            Icons.search_rounded,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              AppStrings.searchTitle,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              AppStrings.searchSubtitle,
                              style: TextStyle(
                                color: Colors.white70,
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

SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.07),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: controller,
                  focusNode: focusNode,
                  style: const TextStyle(
                    color: AppColors.textDark,
                    fontSize: 15,
                  ),
                  decoration: InputDecoration(
                    hintText: AppStrings.searchHint,
                    hintStyle: const TextStyle(
                      color: AppColors.textLight,
                      fontSize: 14,
                    ),
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: AppColors.primary,
                      size: 22,
                    ),
                    suffixIcon: controller.text.isNotEmpty
                        ? GestureDetector(
                            onTap: () {
                              controller.clear();
                              setState(() {});
                            },
                            child: const Icon(
                              Icons.close_rounded,
                              color: AppColors.grey,
                              size: 20,
                            ),
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                ),
              ),
            ),
          ),

if (isEmptySearch) ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Text(
                  AppStrings.trendingTopics,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textMedium,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate((_, i) {
                final text = suggestions[i];
                return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    leading: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        suggestionIcons[i],
                        color: AppColors.primary,
                        size: 18,
                      ),
                    ),
                    title: Text(
                      text[0].toUpperCase() + text.substring(1),
                      style: const TextStyle(
                        color: AppColors.textDark,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.north_west_rounded,
                      color: AppColors.grey,
                      size: 16,
                    ),
                    onTap: () {
                      controller.text = text;
                      ref.read(newsProvider.notifier).search(text);
                      setState(() {});
                    },
                  ),
                );
              }, childCount: suggestions.length),
            ),
          ] else ...[

            if (state.loading && state.articles.isEmpty)
              const SliverFillRemaining(
                child: Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              )
            else if (state.articles.isEmpty)
              SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.08),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.search_off_rounded,
                          color: AppColors.primary,
                          size: 34,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        AppStrings.searchNoResults,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        AppStrings.searchTryDifferent,
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

                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        leading: Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                AppColors.gradientStart,
                                AppColors.gradientEnd,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.article_outlined,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        title: Text(
                          article.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: AppColors.textDark,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.chevron_right_rounded,
                          color: AppColors.grey,
                        ),
                        onTap: () {
                          context.push('/app/details', extra: article);
                        },
                      ),
                    );
                  },
                  childCount:
                      state.articles.length + (state.loadingMore ? 1 : 0),
                ),
              ),
          ],

          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }
}
