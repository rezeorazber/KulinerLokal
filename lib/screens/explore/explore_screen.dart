import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../providers/culinary_provider.dart';
import '../../widgets/category_chip_bar.dart';
import '../../widgets/culinary_card.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/filter_chip_bar.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<CulinaryProvider>(context, listen: false);
    _searchController.text = provider.searchQuery;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CulinaryProvider>(context);
    final places = provider.filteredPlaces;

    return Column(
      children: [
        // Bilah Pencarian Interaktif
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (val) => provider.setSearchQuery(val),
              decoration: InputDecoration(
                hintText: 'Cari gudeg, sate, bakpia, atau area...',
                hintStyle: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textLight,
                ),
                prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          _searchController.clear();
                          provider.clearSearch();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
        ),

        // Filter Chips (Terdekat, Rating 4.5+, Terjangkau, Buka Sekarang)
        FilterChipBar(
          activeFilter: provider.selectedFilterChip,
          onFilterChanged: (filter) => provider.setFilterChip(filter),
        ),

        const SizedBox(height: 8),

        // Category Filter Chips
        CategoryChipBar(
          selectedCategory: provider.selectedCategory,
          onSelected: (cat) => provider.setCategory(cat),
        ),

        const SizedBox(height: 8),

        // Hasil Pencarian Info Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Ditemukan ${places.length} tempat kuliner',
                style: AppTextStyles.caption.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              if (provider.selectedCategory != 'Semua' ||
                  provider.selectedFilterChip.isNotEmpty ||
                  provider.searchQuery.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    _searchController.clear();
                    provider.clearSearch();
                    provider.setCategory('Semua');
                    provider.setFilterChip('');
                  },
                  child: const Text(
                    'Reset Filter',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
            ],
          ),
        ),

        // List Hasil Pencarian
        Expanded(
          child: places.isEmpty
              ? EmptyStateWidget(
                  icon: Icons.search_off,
                  title: 'Kuliner Tidak Ditemukan',
                  message:
                      'Coba gunakan kata kunci lain atau nonaktifkan filter yang aktif.',
                  buttonText: 'Tampilkan Semua Kuliner',
                  onButtonPressed: () {
                    _searchController.clear();
                    provider.clearSearch();
                    provider.setCategory('Semua');
                    provider.setFilterChip('');
                  },
                )
              : ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 20),
                  itemCount: places.length,
                  itemBuilder: (context, index) {
                    final place = places[index];
                    return CulinaryCard(place: place);
                  },
                ),
        ),
      ],
    );
  }
}
