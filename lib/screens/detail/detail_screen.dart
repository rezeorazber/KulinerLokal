import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/utils/map_launcher.dart';
import '../../models/review_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/culinary_provider.dart';

class DetailScreen extends StatefulWidget {
  final String placeId;

  const DetailScreen({
    super.key,
    required this.placeId,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  int _currentImageIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Bottom Sheet for Adding a New Review
  void _showAddReviewBottomSheet(BuildContext context, String placeId) {
    double selectedRating = 5.0;
    final commentController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final auth = Provider.of<AuthProvider>(context, listen: false);
            final userName = auth.user.name;

            return SingleChildScrollView(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Tulis Ulasan',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2C221E),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.grey),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Berbagi pengalaman makanmu sebagai $userName',
                    style: const TextStyle(fontSize: 13, color: Color(0xFF756760)),
                  ),
                  const SizedBox(height: 16),
                  const Text('Rating:', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      final starValue = index + 1.0;
                      return IconButton(
                        icon: Icon(
                          starValue <= selectedRating ? Icons.star_rounded : Icons.star_border_rounded,
                          color: const Color(0xFFFFB300),
                          size: 34,
                        ),
                        onPressed: () => setModalState(() => selectedRating = starValue),
                      );
                    }),
                  ),
                  Center(
                    child: Text(
                      '${selectedRating.toInt()} / 5 Bintang',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFDE5D26)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('Komentar:', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFFAF7F2),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE5DDD5)),
                    ),
                    child: TextField(
                      controller: commentController,
                      maxLines: 3,
                      maxLength: 200,
                      decoration: const InputDecoration(
                        hintText: 'Ceritakan pengalaman makanmu (min. 5 karakter)...',
                        hintStyle: TextStyle(fontSize: 13, color: Color(0xFFAAA09A)),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(14),
                        counterText: '',
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        final comment = commentController.text.trim();
                        if (comment.length < 5) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Ulasan minimal 5 karakter'),
                              backgroundColor: Color(0xFFE74C3C),
                            ),
                          );
                          return;
                        }
                        final newReview = ReviewModel(
                          id: 'rev_${DateTime.now().millisecondsSinceEpoch}',
                          author: userName,
                          rating: selectedRating,
                          comment: comment,
                          date: 'Baru saja',
                        );
                        Provider.of<CulinaryProvider>(context, listen: false)
                            .addReview(placeId, newReview);
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Ulasan berhasil dipublikasikan!'),
                            backgroundColor: Color(0xFF27AE60),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFDE5D26),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Kirim Ulasan',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Bottom Sheet for Editing an Existing Review
  void _showEditReviewBottomSheet(
    BuildContext context,
    String placeId,
    ReviewModel review,
  ) {
    double selectedRating = review.rating;
    final commentController = TextEditingController(text: review.comment);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SingleChildScrollView(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Edit Ulasan',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2C221E),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.grey),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Perbarui ulasan untuk ${review.author}',
                    style: const TextStyle(fontSize: 13, color: Color(0xFF756760)),
                  ),
                  const SizedBox(height: 16),
                  const Text('Rating:', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      final starValue = index + 1.0;
                      return IconButton(
                        icon: Icon(
                          starValue <= selectedRating ? Icons.star_rounded : Icons.star_border_rounded,
                          color: const Color(0xFFFFB300),
                          size: 34,
                        ),
                        onPressed: () => setModalState(() => selectedRating = starValue),
                      );
                    }),
                  ),
                  Center(
                    child: Text(
                      '${selectedRating.toInt()} / 5 Bintang',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFDE5D26)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('Komentar:', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFFAF7F2),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE5DDD5)),
                    ),
                    child: TextField(
                      controller: commentController,
                      maxLines: 3,
                      maxLength: 200,
                      decoration: const InputDecoration(
                        hintText: 'Perbarui pengalaman makanmu (min. 5 karakter)...',
                        hintStyle: TextStyle(fontSize: 13, color: Color(0xFFAAA09A)),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(14),
                        counterText: '',
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        final comment = commentController.text.trim();
                        if (comment.length < 5) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Ulasan minimal 5 karakter'),
                              backgroundColor: Color(0xFFE74C3C),
                            ),
                          );
                          return;
                        }
                        Provider.of<CulinaryProvider>(context, listen: false)
                            .editReview(placeId, review.id, comment, selectedRating);
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Ulasan berhasil diperbarui!'),
                            backgroundColor: Color(0xFF27AE60),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFDE5D26),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Simpan Perubahan',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Confirmation Dialog for Deleting a Review
  void _confirmDeleteReview(
    BuildContext context,
    String placeId,
    String reviewId,
  ) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('Hapus Ulasan'),
        content: const Text('Hapus ulasan ini? Tindakan ini tidak dapat dibatalkan.'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogCtx);
              Provider.of<CulinaryProvider>(context, listen: false)
                  .deleteReview(placeId, reviewId);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Ulasan berhasil dihapus'),
                  backgroundColor: AppColors.statusClosed,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.statusClosed,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Hapus', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CulinaryProvider>(
      builder: (context, provider, _) {
        final place = provider.allPlaces.firstWhere(
          (p) => p.id == widget.placeId,
          orElse: () => provider.allPlaces.first,
        );
        final gallery = place.galleryImages;

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              // Hero Image Carousel
              SliverAppBar(
                expandedHeight: 280,
                pinned: true,
                elevation: 0,
                backgroundColor: AppColors.primary,
                leading: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.4),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                actions: [
                  Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.4),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(
                        place.isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: place.isFavorite ? AppColors.statusClosed : Colors.white,
                        size: 20,
                      ),
                      onPressed: () {
                        provider.toggleFavorite(place.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              place.isFavorite
                                  ? 'Dihapus dari favorit'
                                  : 'Ditambahkan ke favorit',
                            ),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Image Carousel
                      PageView.builder(
                        controller: _pageController,
                        itemCount: gallery.length,
                        onPageChanged: (index) {
                          setState(() => _currentImageIndex = index);
                        },
                        itemBuilder: (context, index) {
                          return Image.network(
                            gallery[index],
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
                            errorBuilder: (_, __, ___) => Container(
                              color: AppColors.chipBackground,
                              child: const Icon(Icons.restaurant, size: 64, color: AppColors.primary),
                            ),
                          );
                        },
                      ),
                      // Gradient overlay
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.4),
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.7),
                            ],
                          ),
                        ),
                      ),
                      // Name only
                      Positioned(
                        bottom: 16,
                        left: 16,
                        right: 16,
                        child: Text(
                          place.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      // Dot Indicators
                      if (gallery.length > 1)
                        Positioned(
                          bottom: 60,
                          left: 0,
                          right: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(gallery.length, (i) {
                              return Container(
                                width: i == _currentImageIndex ? 20 : 8,
                                height: 8,
                                margin: const EdgeInsets.symmetric(horizontal: 3),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: i == _currentImageIndex
                                      ? Colors.white
                                      : Colors.white.withValues(alpha: 0.45),
                                ),
                              );
                            }),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // Detail Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category & Price Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: AppColors.chipBackground,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              place.category,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryDark,
                              ),
                            ),
                          ),
                          Text(
                            place.priceRange,
                            style: AppTextStyles.caption.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Rating & Reviews Summary
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(children: [
                              const Icon(Icons.star, color: AppColors.starRating, size: 20),
                              const SizedBox(width: 6),
                              Text('${place.rating} / 5.0', style: const TextStyle(fontWeight: FontWeight.bold)),
                            ]),
                            Container(width: 1, height: 24, color: AppColors.border),
                            Row(children: [
                              const Icon(Icons.rate_review_outlined, color: AppColors.textSecondary, size: 18),
                              const SizedBox(width: 6),
                              Text('${place.reviewCount} Ulasan', style: AppTextStyles.bodyMedium),
                            ]),
                            Container(width: 1, height: 24, color: AppColors.border),
                            Row(children: [
                              const Icon(Icons.navigation_outlined, color: AppColors.primary, size: 18),
                              const SizedBox(width: 6),
                              Text('${place.distanceKm} km', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                            ]),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Deskripsi
                      if (place.description.isNotEmpty) ...[
                        const Text('Tentang', style: AppTextStyles.headingSmall),
                        const SizedBox(height: 6),
                        Text(
                          place.description,
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],

                      // Petunjuk Arah
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            MapLauncher.openMap(
                              place.name,
                              place.address,
                              place.latitude,
                              place.longitude,
                            );
                          },
                          icon: const Icon(Icons.directions, color: Colors.white, size: 22),
                          label: const Text(
                            'Petunjuk Arah',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.3),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            elevation: 4,
                            shadowColor: AppColors.primary.withValues(alpha: 0.4),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Alamat Lengkap
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(children: [
                                  const Icon(Icons.location_on, color: AppColors.primary, size: 20),
                                  const SizedBox(width: 6),
                                  Text('Alamat Lengkap', style: AppTextStyles.headingSmall.copyWith(fontSize: 15)),
                                ]),
                                TextButton.icon(
                                  onPressed: () => MapLauncher.copyAddress(context, place.address),
                                  icon: const Icon(Icons.copy, size: 14, color: AppColors.primary),
                                  label: const Text('Salin', style: TextStyle(fontSize: 12, color: AppColors.primary)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(place.address, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary)),
                            const SizedBox(height: 10),
                            Row(children: [
                              const Icon(Icons.access_time_filled, color: AppColors.accent, size: 16),
                              const SizedBox(width: 6),
                              Text(
                                'Jam Operasional: ${place.openHours}',
                                style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.w600),
                              ),
                            ]),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Menu Andalan
                      const Text('Menu Andalan', style: AppTextStyles.headingSmall),
                      const SizedBox(height: 10),
                      ...place.featuredMenus.map((menu) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Row(children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                menu.imageUrl,
                                width: 65,
                                height: 65,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  width: 65,
                                  height: 65,
                                  color: AppColors.chipBackground,
                                  child: const Icon(Icons.fastfood, color: AppColors.primary),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    menu.name,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textPrimary),
                                  ),
                                  if (menu.description.isNotEmpty) ...[
                                    const SizedBox(height: 2),
                                    Text(menu.description, maxLines: 2, overflow: TextOverflow.ellipsis, style: AppTextStyles.bodySmall),
                                  ],
                                  const SizedBox(height: 4),
                                  Text(menu.formattedPrice, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primary)),
                                ],
                              ),
                            ),
                          ]),
                        );
                      }),

                      const SizedBox(height: 20),

                      // Ulasan Pengunjung
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Ulasan Pengunjung', style: AppTextStyles.headingSmall),
                          TextButton.icon(
                            onPressed: () => _showAddReviewBottomSheet(context, place.id),
                            icon: const Icon(Icons.add_comment_outlined, size: 16, color: Color(0xFFDE5D26)),
                            label: const Text(
                              'Tulis Ulasan',
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFFDE5D26)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      if (place.reviews.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: Text('Belum ada ulasan untuk tempat ini.', style: AppTextStyles.bodyMedium),
                        )
                      else
                        ...place.reviews.map((rev) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            rev.author,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                              color: AppColors.textPrimary,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Row(
                                            children: [
                                              const Icon(Icons.star, color: AppColors.starRating, size: 14),
                                              const SizedBox(width: 3),
                                              Text('${rev.rating}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                              const SizedBox(width: 8),
                                              Text('• ${rev.date}', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textLight)),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit_outlined, size: 18, color: AppColors.textSecondary),
                                          tooltip: 'Edit Ulasan',
                                          visualDensity: VisualDensity.compact,
                                          onPressed: () => _showEditReviewBottomSheet(context, place.id, rev),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.statusClosed),
                                          tooltip: 'Hapus Ulasan',
                                          visualDensity: VisualDensity.compact,
                                          onPressed: () => _confirmDeleteReview(context, place.id, rev.id),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(rev.comment, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
                              ],
                            ),
                          );
                        }),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
