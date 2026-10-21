import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../providers/auth_provider.dart';
import '../../providers/culinary_provider.dart';
import '../../widgets/banner_carousel.dart';
import '../../widgets/category_chip_bar.dart';
import '../../widgets/culinary_card.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onExploreMore;

  const HomeScreen({
    super.key,
    required this.onExploreMore,
  });

  // Fungsi simulasi pengambilan lokasi
  static Future<void> simulasiAmbilLokasi(BuildContext context) async {
    final provider = Provider.of<CulinaryProvider>(context, listen: false);

    // Tampilkan dialog loading singkat
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: const Row(
          children: [
            CircularProgressIndicator(color: AppColors.primary),
            SizedBox(width: 20),
            Text('Mendeteksi lokasi...'),
          ],
        ),
      ),
    );

    await Future.delayed(const Duration(milliseconds: 700));

    if (!context.mounted) return;
    Navigator.pop(context); // Tutup dialog loading

    // Update state lokasi secara reaktif
    provider.updateLocation('Sleman, DI Yogyakarta');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Lokasi berhasil diperbarui: Sleman, DI Yogyakarta'),
        backgroundColor: AppColors.statusOpen,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final firstName = auth.user.name.trim().split(' ').first;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),

          // Greeting Section (Tag lokasi ganda sudah dihapus, hanya tersisa 1 di header atas)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sugeng Rawuh, $firstName!',
                  style: AppTextStyles.headingMedium.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Mau kulineran apa hari ini?',
                  style: AppTextStyles.bodyMedium,
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Banner Carousel Highlight
          Consumer<CulinaryProvider>(
            builder: (context, culinary, _) {
              return BannerCarousel(places: culinary.bannerPlaces);
            },
          ),

          const SizedBox(height: 24),

          // Kategori Kuliner Cepat (Makanan / Minuman)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Kategori Pilihan',
                  style: AppTextStyles.headingSmall,
                ),
                TextButton(
                  onPressed: onExploreMore,
                  child: const Text(
                    'Lihat Semua',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Consumer<CulinaryProvider>(
            builder: (context, culinary, _) {
              return CategoryChipBar(
                selectedCategory: culinary.selectedCategory,
                onSelected: (cat) {
                  culinary.setCategory(cat);
                  onExploreMore(); // Pindah ke tab eksplorasi
                },
              );
            },
          ),

          const SizedBox(height: 24),

          // Section "Terdekat dari [Lokasi]" (Reaktif dengan Consumer)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Consumer<CulinaryProvider>(
              builder: (context, culinary, _) {
                final lokasiSingkat = culinary.activeLocation.split(',').first.trim();
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.near_me,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Terdekat dari $lokasiSingkat',
                          style: AppTextStyles.headingSmall,
                        ),
                      ],
                    ),
                    Text(
                      '${culinary.nearbyPlaces.length} Tempat',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          const SizedBox(height: 8),

          // Daftar Tempat Terdekat (Reaktif dengan Consumer)
          Consumer<CulinaryProvider>(
            builder: (context, culinary, _) {
              final nearbyPlaces = culinary.nearbyPlaces;
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: nearbyPlaces.length,
                itemBuilder: (context, index) {
                  final place = nearbyPlaces[index];
                  return CulinaryCard(place: place);
                },
              );
            },
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
