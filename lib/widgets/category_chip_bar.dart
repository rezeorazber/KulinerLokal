import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../data/mock_culinary_data.dart';

class CategoryChipBar extends StatelessWidget {
  final String selectedCategory;
  final ValueChanged<String> onSelected;

  const CategoryChipBar({
    super.key,
    required this.selectedCategory,
    required this.onSelected,
  });

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Makanan':
        return Icons.restaurant;
      case 'Minuman':
        return Icons.local_cafe;
      default:
        return Icons.fastfood;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: MockCulinaryData.categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = MockCulinaryData.categories[index];
          final isSelected = category == selectedCategory;

          return ChoiceChip(
            showCheckmark: false,
            avatar: Icon(
              _getCategoryIcon(category),
              size: 16,
              color: isSelected ? Colors.white : AppColors.primary,
            ),
            label: Text(category),
            selected: isSelected,
            selectedColor: AppColors.primary,
            backgroundColor: AppColors.surface,
            labelStyle: TextStyle(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? Colors.white : AppColors.textPrimary,
            ),
            side: BorderSide(
              color: isSelected ? AppColors.primary : AppColors.border,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            onSelected: (selected) {
              if (selected) {
                onSelected(category);
              }
            },
          );
        },
      ),
    );
  }
}
