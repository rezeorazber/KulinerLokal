import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../providers/culinary_provider.dart';
import '../../widgets/culinary_card.dart';
import '../../widgets/empty_state.dart';

class FavoritesScreen extends StatelessWidget {
  final VoidCallback onExploreMore;

  const FavoritesScreen({
    super.key,
    required this.onExploreMore,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CulinaryProvider>(context);
    final favoritePlaces = provider.favoritePlaces;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title & Stats
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Kuliner Favorit Saya',
                    style: AppTextStyles.headingMedium.copyWith(fontSize: 18),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${favoritePlaces.length} tempat tersimpan',
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${favoritePlaces.length} Item',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // Favorites List or Empty State
        Expanded(
          child: favoritePlaces.isEmpty
              ? EmptyStateWidget(
                  icon: Icons.bookmark_border_rounded,
                  title: 'Belum Ada Kuliner Favorit',
                  message:
                      'Simpan tempat makan favorit Anda dengan menekan ikon hati agar mudah ditemukan sewaktu-waktu.',
                  buttonText: 'Jelajahi Kuliner',
                  onButtonPressed: onExploreMore,
                )
              : ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 20),
                  itemCount: favoritePlaces.length,
                  itemBuilder: (context, index) {
                    final place = favoritePlaces[index];
                    return CulinaryCard(
                      place: place,
                      showDeleteAction: true,
                      onDelete: () {
                        provider.removeFavorite(place.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${place.name} dihapus dari favorit'),
                            action: SnackBarAction(
                              label: 'Urungkan',
                              textColor: AppColors.accent,
                              onPressed: () {
                                provider.toggleFavorite(place.id);
                              },
                            ),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }
}
