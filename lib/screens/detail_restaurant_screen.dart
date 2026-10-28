import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../models/restaurant_model.dart';
import 'detail/detail_screen.dart';

export 'detail/detail_screen.dart';

/// Screen UI Detail Resto yang mengimplementasikan Multi-Foto Carousel (`CarouselSlider`)
/// sesuai konfigurasi: height 230.0, autoPlay true, enlargeCenterPage true, viewportFraction 0.9,
/// ClipRRect borderRadius: 12, dan errorBuilder penanganan gambar gagal muat.
class DetailRestaurantScreen extends StatefulWidget {
  final RestaurantModel? restaurant;
  final String? restaurantId;
  final List<String>? images;

  const DetailRestaurantScreen({
    super.key,
    this.restaurant,
    this.restaurantId,
    this.images,
  });

  @override
  State<DetailRestaurantScreen> createState() => _DetailRestaurantScreenState();
}

class _DetailRestaurantScreenState extends State<DetailRestaurantScreen> {
  int _currentImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Jika memiliki ID resto untuk database terintegrasi, delegasikan ke DetailScreen
    if (widget.restaurantId != null || (widget.restaurant != null && widget.restaurant!.id.isNotEmpty)) {
      final id = widget.restaurantId ?? widget.restaurant!.id;
      return DetailScreen(placeId: id);
    }

    final photoList = widget.images ??
        widget.restaurant?.images ??
        const [
          'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=800',
          'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=800',
          'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=800',
        ];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.restaurant?.name ?? 'Detail Restoran'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            // Header Utama: Multi-Foto CarouselSlider
            CarouselSlider(
              options: CarouselOptions(
                height: 230.0,
                autoPlay: true,
                enlargeCenterPage: true,
                viewportFraction: 0.9,
                onPageChanged: (index, reason) {
                  setState(() => _currentImageIndex = index);
                },
              ),
              items: photoList.map((imgUrl) {
                return Builder(
                  builder: (BuildContext context) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        imgUrl,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return Container(
                            color: AppColors.chipBackground,
                            child: const Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation(AppColors.primary),
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: AppColors.chipBackground,
                          child: const Icon(
                            Icons.restaurant,
                            size: 64,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
            // Dot Indicators
            if (photoList.length > 1)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(photoList.length, (i) {
                  return Container(
                    width: i == _currentImageIndex ? 20 : 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: i == _currentImageIndex
                          ? AppColors.primary
                          : Colors.grey.withValues(alpha: 0.4),
                    ),
                  );
                }),
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.restaurant?.name ?? 'Restoran Kuliner',
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.restaurant?.address ?? 'Yogyakarta, Indonesia',
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
