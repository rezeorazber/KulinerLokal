import 'menu_item.dart';
import 'review_model.dart';

class CulinaryPlace {
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
  final String imageUrl;
  final List<String> imageUrls; // Galeri foto (min 3)
  final List<String> images;    // Multi-foto list (Fitur Multi-Foto Carousel)
  final bool isOperational;
  final String openHours;
  final List<MenuItem> featuredMenus;
  final List<ReviewModel> reviews;
  final double distanceKm;
  final bool isFavorite;
  final String? highlightBadge;
  final String description;

  const CulinaryPlace({
    required this.id,
    required this.name,
    required this.category,
    required this.district,
    required this.rating,
    required this.reviewCount,
    required this.priceRange,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.imageUrl,
    this.imageUrls = const [],
    this.images = const [],
    required this.isOperational,
    required this.openHours,
    required this.featuredMenus,
    required this.reviews,
    required this.distanceKm,
    this.isFavorite = false,
    this.highlightBadge,
    this.description = '',
  });

  /// Mengembalikan list foto galeri secara komprehensif dari `images`, `imageUrls`, atau `imageUrl`
  List<String> get galleryImages {
    if (images.isNotEmpty) return images;
    if (imageUrls.isNotEmpty) return imageUrls;
    if (imageUrl.isNotEmpty) return [imageUrl];
    return const [];
  }

  /// Getter `image` untuk backward-compatibility dengan skema tunggal
  String get image => imageUrl.isNotEmpty ? imageUrl : (images.isNotEmpty ? images.first : '');

  CulinaryPlace copyWith({
    String? id,
    String? name,
    String? category,
    String? district,
    double? rating,
    int? reviewCount,
    String? priceRange,
    String? address,
    double? latitude,
    double? longitude,
    String? imageUrl,
    List<String>? imageUrls,
    List<String>? images,
    bool? isOperational,
    String? openHours,
    List<MenuItem>? featuredMenus,
    List<ReviewModel>? reviews,
    double? distanceKm,
    bool? isFavorite,
    String? highlightBadge,
    String? description,
  }) {
    return CulinaryPlace(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      district: district ?? this.district,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      priceRange: priceRange ?? this.priceRange,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      imageUrl: imageUrl ?? this.imageUrl,
      imageUrls: imageUrls ?? this.imageUrls,
      images: images ?? (imageUrls ?? this.images),
      isOperational: isOperational ?? this.isOperational,
      openHours: openHours ?? this.openHours,
      featuredMenus: featuredMenus ?? this.featuredMenus,
      reviews: reviews ?? this.reviews,
      distanceKm: distanceKm ?? this.distanceKm,
      isFavorite: isFavorite ?? this.isFavorite,
      highlightBadge: highlightBadge ?? this.highlightBadge,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
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
      'imageUrl': imageUrl,
      'image': imageUrl,
      'imageUrls': imageUrls.isNotEmpty ? imageUrls : images,
      'images': images.isNotEmpty ? images : imageUrls,
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

  Map<String, dynamic> toJson() => toMap();

  /// Factory fromFirestore / fromJson / fromMap dengan logika fallback backward-compatible:
  /// Jika field `images` ada (List), gunakan itu.
  /// Jika masih menggunakan field lama `image` (String), bungkus menjadi List<String>.
  factory CulinaryPlace.fromMap(Map<String, dynamic> map) {
    List<String> parsedImages = [];
    if (map['images'] is List && (map['images'] as List).isNotEmpty) {
      parsedImages = (map['images'] as List).map((e) => e.toString()).toList();
    } else if (map['imageUrls'] is List && (map['imageUrls'] as List).isNotEmpty) {
      parsedImages = (map['imageUrls'] as List).map((e) => e.toString()).toList();
    } else if (map['image'] != null && map['image'].toString().isNotEmpty) {
      parsedImages = [map['image'].toString()];
    } else if (map['imageUrl'] != null && map['imageUrl'].toString().isNotEmpty) {
      parsedImages = [map['imageUrl'].toString()];
    }

    final primaryImageUrl = map['imageUrl']?.toString() ??
        map['image']?.toString() ??
        (parsedImages.isNotEmpty ? parsedImages.first : '');

    return CulinaryPlace(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      category: map['category'] ?? '',
      district: map['district'] ?? 'Kota Yogyakarta',
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: (map['reviewCount'] as num?)?.toInt() ?? 0,
      priceRange: map['priceRange'] ?? '',
      address: map['address'] ?? '',
      latitude: (map['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (map['longitude'] as num?)?.toDouble() ?? 0.0,
      imageUrl: primaryImageUrl,
      imageUrls: parsedImages,
      images: parsedImages,
      isOperational: map['isOperational'] ?? true,
      openHours: map['openHours'] ?? '',
      featuredMenus: (map['featuredMenus'] as List<dynamic>?)
              ?.map((item) => MenuItem.fromMap(item))
              .toList() ??
          [],
      reviews: (map['reviews'] as List<dynamic>?)
              ?.map((item) => ReviewModel.fromMap(item))
              .toList() ??
          [],
      distanceKm: (map['distanceKm'] as num?)?.toDouble() ?? 0.0,
      isFavorite: map['isFavorite'] ?? false,
      highlightBadge: map['highlightBadge'],
      description: map['description'] ?? '',
    );
  }

  factory CulinaryPlace.fromJson(Map<String, dynamic> json) =>
      CulinaryPlace.fromMap(json);

  factory CulinaryPlace.fromFirestore(Map<String, dynamic> data, [String? id]) {
    final map = Map<String, dynamic>.from(data);
    if (id != null && !map.containsKey('id')) {
      map['id'] = id;
    }
    return CulinaryPlace.fromMap(map);
  }
}
