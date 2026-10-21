import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/mock_culinary_data.dart';
import '../models/culinary_place.dart';
import '../models/review_model.dart';

class CulinaryProvider with ChangeNotifier {
  static const String _prefFavoritesKey = 'culinary_favorite_ids';

  List<CulinaryPlace> _places = [];
  String _activeLocation = 'Malioboro, Yogyakarta';
  String _searchQuery = '';
  String _selectedCategory = 'Semua';
  String _selectedFilterChip = ''; // '', 'Terdekat', 'Rating Tinggi', 'Terjangkau'
  String _selectedDistrict = 'Semua Wilayah';

  CulinaryProvider() {
    _loadInitialData();
  }

  void _loadInitialData() async {
    _places = List<CulinaryPlace>.from(MockCulinaryData.places);
    await _loadFavoritesFromPrefs();
    notifyListeners();
  }

  Future<void> _loadFavoritesFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favIds = prefs.getStringList(_prefFavoritesKey);
      if (favIds != null) {
        final favSet = favIds.toSet();
        _places = _places.map((p) => p.copyWith(isFavorite: favSet.contains(p.id))).toList();
      }
    } catch (e) {
      debugPrint('Error loading favorites: $e');
    }
  }

  Future<void> _saveFavoritesToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favIds = _places.where((p) => p.isFavorite).map((p) => p.id).toList();
      await prefs.setStringList(_prefFavoritesKey, favIds);
    } catch (e) {
      debugPrint('Error saving favorites: $e');
    }
  }

  // Getters
  List<CulinaryPlace> get allPlaces => _places;
  String get activeLocation => _activeLocation;
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;
  String get selectedFilterChip => _selectedFilterChip;
  String get selectedDistrict => _selectedDistrict;

  // Banner places for Home Carousel (top rated places)
  List<CulinaryPlace> get bannerPlaces {
    final list = _places.where((p) => p.rating >= 4.7).take(5).toList();
    return list.isNotEmpty ? list : _places.take(4).toList();
  }

  // Nearby places for Home Screen
  List<CulinaryPlace> get nearbyPlaces {
    final list = List<CulinaryPlace>.from(_places);
    list.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
    return list;
  }

  // Filtered places for Explore / Search Screen
  List<CulinaryPlace> get filteredPlaces {
    return _places.where((place) {
      // 1. Search Query Filter (name, category, address, menu)
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase().trim();
        final matchName = place.name.toLowerCase().contains(query);
        final matchCategory = place.category.toLowerCase().contains(query);
        final matchAddress = place.address.toLowerCase().contains(query);
        final matchMenu = place.featuredMenus.any(
          (m) => m.name.toLowerCase().contains(query),
        );
        if (!matchName && !matchCategory && !matchAddress && !matchMenu) {
          return false;
        }
      }

      // 2. Category Filter
      if (_selectedCategory != 'Semua' && place.category != _selectedCategory) {
        return false;
      }

      // 3. Quick Filter Chip
      if (_selectedFilterChip == 'Rating Tinggi' && place.rating < 4.7) {
        return false;
      }
      if (_selectedFilterChip == 'Buka Sekarang' && !place.isOperational) {
        return false;
      }
      if (_selectedFilterChip == 'Terjangkau' &&
          (place.priceRange.contains('180') || place.priceRange.contains('60.000'))) {
        return false;
      }

      return true;
    }).toList()
      ..sort((a, b) {
        if (_selectedFilterChip == 'Terdekat') {
          return a.distanceKm.compareTo(b.distanceKm);
        }
        if (_selectedFilterChip == 'Rating Tinggi') {
          return b.rating.compareTo(a.rating);
        }
        return 0;
      });
  }

  // Favorite places
  List<CulinaryPlace> get favoritePlaces {
    return _places.where((place) => place.isFavorite).toList();
  }

  // Toggle Favorite
  void toggleFavorite(String placeId) {
    final index = _places.indexWhere((p) => p.id == placeId);
    if (index != -1) {
      final currentPlace = _places[index];
      _places[index] = currentPlace.copyWith(
        isFavorite: !currentPlace.isFavorite,
      );
      _saveFavoritesToPrefs();
      notifyListeners();
    }
  }

  // Remove Favorite directly
  void removeFavorite(String placeId) {
    final index = _places.indexWhere((p) => p.id == placeId);
    if (index != -1 && _places[index].isFavorite) {
      _places[index] = _places[index].copyWith(isFavorite: false);
      _saveFavoritesToPrefs();
      notifyListeners();
    }
  }

  // Set Search Query
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // Clear Search Query
  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }

  // Set Category
  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  // Toggle or Set Filter Chip
  void setFilterChip(String chip) {
    if (_selectedFilterChip == chip) {
      _selectedFilterChip = ''; // unselect if tapped again
    } else {
      _selectedFilterChip = chip;
    }
    notifyListeners();
  }

  // Set District filter for Favorites screen
  void setDistrict(String district) {
    _selectedDistrict = district;
    notifyListeners();
  }

  // Add a user review
  void addReview(String placeId, ReviewModel review) {
    final index = _places.indexWhere((p) => p.id == placeId);
    if (index != -1) {
      final currentPlace = _places[index];
      final updatedReviews = [review, ...currentPlace.reviews];
      final newTotalRating = updatedReviews.fold<double>(0.0, (sum, r) => sum + r.rating);
      final newAvgRating = updatedReviews.isNotEmpty
          ? double.parse((newTotalRating / updatedReviews.length).toStringAsFixed(1))
          : 0.0;

      _places[index] = currentPlace.copyWith(
        reviews: updatedReviews,
        reviewCount: currentPlace.reviewCount + 1,
        rating: newAvgRating,
      );
      notifyListeners();
    }
  }

  // Edit a user review
  void editReview(String placeId, String reviewId, String newComment, double newRating) {
    final placeIndex = _places.indexWhere((p) => p.id == placeId);
    if (placeIndex != -1) {
      final currentPlace = _places[placeIndex];
      final reviewIndex = currentPlace.reviews.indexWhere((r) => r.id == reviewId);
      if (reviewIndex != -1) {
        final existingReview = currentPlace.reviews[reviewIndex];
        final updatedReview = existingReview.copyWith(
          comment: newComment,
          rating: newRating,
        );
        final updatedReviews = List<ReviewModel>.from(currentPlace.reviews);
        updatedReviews[reviewIndex] = updatedReview;

        final newTotalRating = updatedReviews.fold<double>(0.0, (sum, r) => sum + r.rating);
        final newAvgRating = updatedReviews.isNotEmpty
            ? double.parse((newTotalRating / updatedReviews.length).toStringAsFixed(1))
            : 0.0;

        _places[placeIndex] = currentPlace.copyWith(
          reviews: updatedReviews,
          rating: newAvgRating,
        );
        notifyListeners();
      }
    }
  }

  // Delete a user review
  void deleteReview(String placeId, String reviewId) {
    final placeIndex = _places.indexWhere((p) => p.id == placeId);
    if (placeIndex != -1) {
      final currentPlace = _places[placeIndex];
      final updatedReviews = currentPlace.reviews.where((r) => r.id != reviewId).toList();
      final newCount = currentPlace.reviewCount > 0 ? currentPlace.reviewCount - 1 : 0;
      final newAvgRating = updatedReviews.isNotEmpty
          ? double.parse(
              (updatedReviews.fold<double>(0.0, (sum, r) => sum + r.rating) / updatedReviews.length)
                  .toStringAsFixed(1),
            )
          : 0.0;

      _places[placeIndex] = currentPlace.copyWith(
        reviews: updatedReviews,
        reviewCount: newCount,
        rating: newAvgRating,
      );
      notifyListeners();
    }
  }

  // Update active location
  void updateLocation(String newLocation) {
    _activeLocation = newLocation;
    notifyListeners();
  }

  // Alias for backward compatibility
  void setActiveLocation(String location) => updateLocation(location);
}
