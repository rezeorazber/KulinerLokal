import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

/// Exception khusus saat layanan GPS perangkat tidak aktif
class GpsDisabledException implements Exception {
  final String message;
  const GpsDisabledException([this.message = 'Layanan lokasi (GPS) tidak aktif pada perangkat.']);
  @override
  String toString() => message;
}

/// Exception khusus saat izin akses lokasi ditolak oleh pengguna
class LocationPermissionDeniedException implements Exception {
  final String message;
  const LocationPermissionDeniedException([this.message = 'Izin akses lokasi ditolak oleh pengguna.']);
  @override
  String toString() => message;
}

class LocationService {
  /// Mengambil posisi GPS perangkat secara real.
  ///
  /// Alur pemeriksaan:
  /// 1. Cek `Geolocator.isLocationServiceEnabled()`. Jika false, kembalikan null atau lempar exception agar UI bisa menampilkan dialog "GPS Mati".
  /// 2. Cek `Geolocator.checkPermission()`.
  /// 3. Jika `LocationPermission.denied`, panggil `Geolocator.requestPermission()`.
  /// 4. Handle kondisi `deniedForever` dan `denied`.
  /// 5. Jika izin diberikan, panggil `Geolocator.getCurrentPosition(locationSettings: LocationSettings(accuracy: LocationAccuracy.high))`.
  Future<Position?> getCurrentPosition({
    LocationAccuracy desiredAccuracy = LocationAccuracy.high,
    bool throwOnDisabled = false,
  }) async {
    // 1. Cek apakah layanan GPS aktif
    final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (throwOnDisabled) {
        throw const GpsDisabledException();
      }
      debugPrint('[LocationService] GPS tidak aktif pada perangkat.');
      return null;
    }

    // 2. Cek izin akses lokasi
    LocationPermission permission = await Geolocator.checkPermission();

    // 3. Jika izin ditolak, minta izin ke pengguna
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (throwOnDisabled) {
          throw const LocationPermissionDeniedException();
        }
        debugPrint('[LocationService] Izin lokasi ditolak oleh pengguna.');
        return null;
      }
    }

    // 4. Handle kondisi ditolak secara permanen
    if (permission == LocationPermission.deniedForever) {
      if (throwOnDisabled) {
        throw const LocationPermissionDeniedException(
          'Izin lokasi ditolak secara permanen. Silakan aktifkan via Pengaturan perangkat.',
        );
      }
      debugPrint('[LocationService] Izin lokasi ditolak permanen.');
      return null;
    }

    // 5. Izin diberikan: ambil posisi real GPS dengan akurasi tinggi
    try {
      return await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: desiredAccuracy,
          timeLimit: const Duration(seconds: 15),
        ),
      );
    } catch (e) {
      debugPrint('[LocationService] Gagal mengambil posisi GPS: $e');
      return null;
    }
  }

  /// Helper static untuk pemanggilan instan `LocationService.getPosition()`
  static Future<Position?> getPosition({LocationAccuracy desiredAccuracy = LocationAccuracy.high}) =>
      LocationService().getCurrentPosition(desiredAccuracy: desiredAccuracy);

  /// Backward-compatibility alias untuk `getCurrentUserLocation()`
  static Future<Position> getCurrentUserLocation() async {
    final pos = await LocationService().getCurrentPosition(throwOnDisabled: true);
    if (pos == null) {
      throw const GpsDisabledException();
    }
    return pos;
  }
}

/// Fungsi asynchronous top-level `getCurrentUserLocation()` untuk kemudahan akses
Future<Position> getCurrentUserLocation() => LocationService.getCurrentUserLocation();
