import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_text_styles.dart';
import '../providers/auth_provider.dart';
import '../providers/culinary_provider.dart';

class TopAppHeader extends StatefulWidget implements PreferredSizeWidget {
  final VoidCallback? onProfileTap;

  const TopAppHeader({
    super.key,
    this.onProfileTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(65);

  @override
  State<TopAppHeader> createState() => _TopAppHeaderState();
}

class _TopAppHeaderState extends State<TopAppHeader> {
  bool _locationPermissionGranted = false;

  void _handleLocationTap(BuildContext context) {
    if (_locationPermissionGranted) {
      // Sudah diizinkan → langsung tampilkan picker lokasi
      _showLocationPicker(context);
    } else {
      // Belum diizinkan → tampilkan dialog izin dulu
      _showLocationPermissionDialog(context);
    }
  }

  void _showLocationPermissionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        icon: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.location_on, color: AppColors.primary, size: 28),
        ),
        title: const Text(
          'Izinkan Akses Lokasi',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        content: const Text(
          'KulinerLokal membutuhkan akses lokasi perangkat kamu untuk menampilkan kuliner terdekat.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 13, color: Color(0xFF665851), height: 1.5),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Lokasi tidak diizinkan. Menggunakan lokasi default.'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text(
              'Tolak',
              style: TextStyle(color: Color(0xFF756760), fontWeight: FontWeight.w600),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);

              // Simulasi deteksi lokasi
              final provider = Provider.of<CulinaryProvider>(context, listen: false);

              // Tampilkan loading singkat
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Row(
                    children: [
                      SizedBox(
                        width: 18, height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation(Colors.white)),
                      ),
                      SizedBox(width: 12),
                      Text('Mendeteksi lokasi perangkat...'),
                    ],
                  ),
                  duration: Duration(milliseconds: 800),
                ),
              );

              await Future.delayed(const Duration(milliseconds: 900));

              if (!context.mounted) return;
              provider.updateLocation('Sleman, DI Yogyakarta');
              setState(() {
                _locationPermissionGranted = true;
              });

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Lokasi terdeteksi: Sleman, DI Yogyakarta'),
                  backgroundColor: Color(0xFF27AE60),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text(
              'Izinkan',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _showLocationPicker(BuildContext context) {
    final provider = Provider.of<CulinaryProvider>(context, listen: false);
    final locations = [
      'Sleman, DI Yogyakarta',
      'Malioboro, Yogyakarta',
      'Kraton, Yogyakarta',
      'Sewon, Bantul',
      'Kaliurang, Sleman',
    ];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.location_on, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text(
                    'Lokasi Terkini',
                    style: AppTextStyles.headingSmall.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ...locations.map((loc) {
                final isSelected = loc == provider.activeLocation;
                return ListTile(
                  leading: Icon(
                    isSelected ? Icons.check_circle : Icons.circle_outlined,
                    color: isSelected ? AppColors.primary : Colors.grey,
                  ),
                  title: Text(
                    loc,
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? AppColors.primary : AppColors.textPrimary,
                    ),
                  ),
                  onTap: () {
                    provider.updateLocation(loc);
                    Navigator.pop(ctx);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.user;

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: AppColors.surface,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left: Profile Avatar
            GestureDetector(
              onTap: widget.onProfileTap,
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, AppColors.accent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.25),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: user.avatarUrl.isNotEmpty
                          ? Image.network(
                              user.avatarUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Center(
                                child: Text(
                                  auth.initials,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            )
                          : Center(
                              child: Text(
                                auth.initials,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        user.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        auth.isGuest ? 'Mode Tamu' : 'Pecinta Kuliner',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Right: Interactive Location Selector
            InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => _handleLocationTap(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.chipBackground,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.place,
                      color: AppColors.primary,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Consumer<CulinaryProvider>(
                      builder: (context, culinary, _) {
                        return ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 130),
                          child: Text(
                            culinary.activeLocation,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryDark,
                            ),
                          ),
                        );
                      },
                    ),
                    const Icon(
                      Icons.keyboard_arrow_down,
                      color: AppColors.primary,
                      size: 16,
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
