import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_text_styles.dart';
import '../models/culinary_place.dart';
import '../providers/culinary_provider.dart';
import '../screens/detail/detail_screen.dart';

class CulinaryCard extends StatelessWidget {
  final CulinaryPlace place;
  final bool showDeleteAction;
  final VoidCallback? onDelete;

  const CulinaryCard({
    super.key,
    required this.place,
    this.showDeleteAction = false,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetailScreen(placeId: place.id),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Thumbnail
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(16),
              ),
              child: Stack(
                children: [
                  Image.network(
                    place.imageUrl,
                    width: 110,
                    height: 125,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 110,
                      height: 125,
                      color: AppColors.chipBackground,
                      child: const Icon(
                        Icons.restaurant,
                        color: AppColors.primary,
                        size: 32,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category & Favorite button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          place.category,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (showDeleteAction)
                          IconButton(
                            icon: const Icon(
                              Icons.delete_outline,
                              color: AppColors.statusClosed,
                              size: 20,
                            ),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: onDelete,
                          )
                        else
                          Consumer<CulinaryProvider>(
                            builder: (ctx, provider, _) {
                              return IconButton(
                                icon: Icon(
                                  place.isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: place.isFavorite
                                      ? AppColors.statusClosed
                                      : AppColors.textLight,
                                  size: 20,
                                ),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                onPressed: () {
                                  provider.toggleFavorite(place.id);
                                },
                              );
                            },
                          ),
                      ],
                    ),

                    const SizedBox(height: 2),

                    // Place Name
                    Text(
                      place.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.headingSmall.copyWith(
                        fontSize: 15,
                        color: AppColors.textPrimary,
                      ),
                    ),

                    const SizedBox(height: 4),

                    // Rating & Distance
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          size: 15,
                          color: AppColors.starRating,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          '${place.rating}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          ' (${place.reviewCount})',
                          style: AppTextStyles.bodySmall,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          '•',
                          style: TextStyle(color: AppColors.textLight),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.directions_walk,
                          size: 14,
                          color: AppColors.textSecondary,
                        ),
                        Text(
                          '${place.distanceKm} km',
                          style: AppTextStyles.bodySmall.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    // Price Range
                    Row(
                      children: [
                        const Icon(
                          Icons.payments_outlined,
                          size: 14,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            place.priceRange,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
