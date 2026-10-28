import 'culinary_place.dart';
import 'menu_item.dart';
import 'review_model.dart';

/// Model Restaurant/Resto dengan dukungan Multi-Foto Carousel (`images`)
/// serta fallback backward-compatible dari field lama (`image`).
class RestaurantModel {
  final String id;
  final String name;
  final String category;
  final String district;
  final double rating;
  final int reviewCount;
  final String priceRange;
  final String address;
  final double latitude;
  final double longitude;
  final List<String> images;
  final bool isOperational;
  final String openHours;
  final List<MenuItem> featuredMenus;
  final List<ReviewModel> reviews;
  final double distanceKm;
  final bool isFavorite;
  final String? highlightBadge;
  final String description;

  const RestaurantModel({
    required this.id,
    required this.name,
    this.category = 'Makanan',
    this.district = 'Kota Yogyakarta',
    this.rating = 0.0,
    this.reviewCount = 0,
    this.priceRange = '',
    this.address = '',
    this.latitude = 0.0,
    this.longitude = 0.0,
    required this.images,
    this.isOperational = true,
    this.openHours = '',
    this.featuredMenus = const [],
    this.reviews = const [],
    this.distanceKm = 0.0,
    this.isFavorite = false,
    this.highlightBadge,
    this.description = '',
  });

  /// Getter `image` untuk backward-compatibility dengan kode lama
  String get image => images.isNotEmpty ? images.first : '';
  String get imageUrl => image;
  List<String> get imageUrls => images;

  /// Metode factory `fromFirestore` dengan logika fallback backward-compatible:
  /// - jika field `images` ada (List), gunakan itu
  /// - jika masih menggunakan field lama `image` (String), bungkus menjadi List<String>
  factory RestaurantModel.fromFirestore(Map<String, dynamic> data, [String? docId]) {
    return RestaurantModel.fromJson(data, docId);
  }

  /// Metode factory `fromJson` dengan logika fallback backward-compatible:
  /// - jika field `images` ada (List), gunakan itu
  /// - jika masih menggunakan field lama `image` (String), bungkus menjadi List<String>
  factory RestaurantModel.fromJson(Map<String, dynamic> json, [String? id]) {
    List<String> parsedImages = [];
    if (json['images'] is List && (json['images'] as List).isNotEmpty) {
      parsedImages = (json['images'] as List).map((e) => e.toString()).toList();
    } else if (json['imageUrls'] is List && (json['imageUrls'] as List).isNotEmpty) {
      parsedImages = (json['imageUrls'] as List).map((e) => e.toString()).toList();
    } else if (json['image'] != null && json['image'].toString().isNotEmpty) {
      parsedImages = [json['image'].toString()];
    } else if (json['imageUrl'] != null && json['imageUrl'].toString().isNotEmpty) {
      parsedImages = [json['imageUrl'].toString()];
    }

    return RestaurantModel(
      id: id ?? json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      category: json['category']?.toString() ?? 'Makanan',
      district: json['district']?.toString() ?? 'Kota Yogyakarta',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
      priceRange: json['priceRange']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      images: parsedImages,
      isOperational: json['isOperational'] ?? true,
      openHours: json['openHours']?.toString() ?? '',
      featuredMenus: (json['featuredMenus'] as List<dynamic>?)
              ?.map((item) => MenuItem.fromMap(item))
              .toList() ??
          [],
      reviews: (json['reviews'] as List<dynamic>?)
              ?.map((item) => ReviewModel.fromMap(item))
              .toList() ??
          [],
      distanceKm: (json['distanceKm'] as num?)?.toDouble() ?? 0.0,
      isFavorite: json['isFavorite'] ?? false,
      highlightBadge: json['highlightBadge']?.toString(),
      description: json['description']?.toString() ?? '',
    );
  }

  factory RestaurantModel.fromMap(Map<String, dynamic> map) =>
      RestaurantModel.fromJson(map);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'district': district,
      'rating': rating,
      'reviewCount': reviewCount,
      'priceRange': priceRange,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'images': images,
      'image': image,
      'imageUrl': image,
      'imageUrls': images,
      'isOperational': isOperational,
      'openHours': openHours,
      'featuredMenus': featuredMenus.map((m) => m.toMap()).toList(),
      'reviews': reviews.map((r) => r.toMap()).toList(),
      'distanceKm': distanceKm,
      'isFavorite': isFavorite,
      'highlightBadge': highlightBadge,
      'description': description,
    };
  }

  Map<String, dynamic> toMap() => toJson();

  /// Konversi ke CulinaryPlace untuk integrasi mulus dengan seluruh sistem aplikasi
  CulinaryPlace toCulinaryPlace() {
    return CulinaryPlace(
      id: id,
      name: name,
      category: category,
      district: district,
      rating: rating,
      reviewCount: reviewCount,
      priceRange: priceRange,
      address: address,
      latitude: latitude,
      longitude: longitude,
      imageUrl: image,
      imageUrls: images,
      images: images,
      isOperational: isOperational,
      openHours: openHours,
      featuredMenus: featuredMenus,
      reviews: reviews,
      distanceKm: distanceKm,
      isFavorite: isFavorite,
      highlightBadge: highlightBadge,
      description: description,
    );
  }

  factory RestaurantModel.fromCulinaryPlace(CulinaryPlace place) {
    return RestaurantModel(
      id: place.id,
      name: place.name,
      category: place.category,
      district: place.district,
      rating: place.rating,
      reviewCount: place.reviewCount,
      priceRange: place.priceRange,
      address: place.address,
      latitude: place.latitude,
      longitude: place.longitude,
      images: place.galleryImages,
      isOperational: place.isOperational,
      openHours: place.openHours,
      featuredMenus: place.featuredMenus,
      reviews: place.reviews,
      distanceKm: place.distanceKm,
      isFavorite: place.isFavorite,
      highlightBadge: place.highlightBadge,
      description: place.description,
    );
  }
}
