import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class FilterChipBar extends StatelessWidget {
  final String activeFilter;
  final ValueChanged<String> onFilterChanged;

  const FilterChipBar({
    super.key,
    required this.activeFilter,
    required this.onFilterChanged,
  });

  static const List<Map<String, dynamic>> filters = [
    {'name': 'Terdekat', 'icon': Icons.near_me_outlined},
    {'name': 'Rating Tinggi', 'icon': Icons.star_border},
    {'name': 'Terjangkau', 'icon': Icons.savings_outlined},
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final String name = filter['name'] as String;
          final IconData icon = filter['icon'] as IconData;
          final isSelected = activeFilter == name;

          return FilterChip(
            showCheckmark: false,
            avatar: Icon(
              icon,
              size: 15,
              color: isSelected ? Colors.white : AppColors.textSecondary,
            ),
            label: Text(name),
            selected: isSelected,
            selectedColor: AppColors.primary,
            backgroundColor: AppColors.surface,
            labelStyle: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              color: isSelected ? Colors.white : AppColors.textPrimary,
            ),
            side: BorderSide(
              color: isSelected ? AppColors.primary : AppColors.border,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            onSelected: (_) => onFilterChanged(name),
          );
        },
      ),
    );
  }
}
