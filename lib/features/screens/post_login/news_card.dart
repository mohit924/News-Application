import 'package:flutter/material.dart';
import 'package:news_app/constants/app_colors.dart';
import 'package:news_app/features/model/article_model.dart';

class NewsCard extends StatelessWidget {
  final Article article;
  final VoidCallback onFav;
  final VoidCallback? onTap;
  final bool isFav;

  const NewsCard({
    super.key,
    required this.article,
    required this.onFav,
    this.onTap,
    this.isFav = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.gradientStart, AppColors.gradientEnd],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.article_outlined,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              const SizedBox(width: 12),

Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14.5,
                        color: AppColors.textDark,
                        height: 1.35,
                      ),
                    ),
                    if (article.description != null &&
                        article.description!.isNotEmpty) ...[
                      const SizedBox(height: 5),
                      Text(
                        article.description!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12.5,
                          color: AppColors.textMedium,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

GestureDetector(
                onTap: onFav,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: isFav
                        ? AppColors.error.withOpacity(0.1)
                        : AppColors.background,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isFav
                        ? Icons.favorite_rounded
                        : Icons.favorite_outline_rounded,
                    color: isFav ? AppColors.error : AppColors.grey,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
