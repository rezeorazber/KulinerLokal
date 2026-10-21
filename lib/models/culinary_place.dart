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
    required this.isOperational,
    required this.openHours,
    required this.featuredMenus,
    required this.reviews,
    required this.distanceKm,
    this.isFavorite = false,
    this.highlightBadge,
    this.description = '',
  });

  /// Returns imageUrls if available, otherwise wraps imageUrl in a list
  List<String> get galleryImages =>
      imageUrls.isNotEmpty ? imageUrls : [imageUrl];

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
      'imageUrls': imageUrls,
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

  factory CulinaryPlace.fromMap(Map<String, dynamic> map) {
    return CulinaryPlace(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      category: map['category'] ?? '',
      district: map['district'] ?? 'Kota Yogyakarta',
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: map['reviewCount'] ?? 0,
      priceRange: map['priceRange'] ?? '',
      address: map['address'] ?? '',
      latitude: (map['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (map['longitude'] as num?)?.toDouble() ?? 0.0,
      imageUrl: map['imageUrl'] ?? '',
      imageUrls: (map['imageUrls'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
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
}
