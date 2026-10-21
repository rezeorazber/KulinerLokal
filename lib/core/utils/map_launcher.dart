import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class MapLauncher {
  /// Membuka rute Google Maps dengan format query terenkripsi dan dual-fallback:
  /// 1. Coba skema native geo: (aplikasi Google Maps di device)
  /// 2. Fallback ke URL web Google Maps via browser eksternal
  static Future<void> openMap(
    String placeName,
    String address,
    double latitude,
    double longitude,
  ) async {
    final String query = Uri.encodeComponent('$placeName, $address');
    final Uri geoUri = Uri.parse('geo:$latitude,$longitude?q=$query');
    final Uri webUri =
        Uri.parse('https://www.google.com/maps/search/?api=1&query=$query');

    try {
      if (await canLaunchUrl(geoUri)) {
        await launchUrl(geoUri, mode: LaunchMode.externalApplication);
      } else if (await canLaunchUrl(webUri)) {
        await launchUrl(webUri, mode: LaunchMode.externalApplication);
      } else {
        await launchUrl(webUri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {
      try {
        await launchUrl(webUri, mode: LaunchMode.externalApplication);
      } catch (e) {
        debugPrint('Gagal membuka peta: $e');
      }
    }
  }

  /// Backward-compatible alias
  static Future<void> openGoogleMaps({
    required BuildContext context,
    required double latitude,
    required double longitude,
    required String placeName,
    String address = '',
  }) async {
    await openMap(placeName, address, latitude, longitude);
  }

  /// Menyalin teks alamat ke clipboard
  static void copyAddress(BuildContext context, String address) {
    Clipboard.setData(ClipboardData(text: address));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Alamat berhasil disalin ke clipboard!'),
        backgroundColor: Color(0xFFDE5D26),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
