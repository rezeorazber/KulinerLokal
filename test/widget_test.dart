import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuliner_lokal/main.dart';
import 'package:kuliner_lokal/models/culinary_place.dart';
import 'package:kuliner_lokal/models/restaurant_model.dart';
import 'package:kuliner_lokal/models/review_model.dart';
import 'package:kuliner_lokal/providers/culinary_provider.dart';
import 'package:kuliner_lokal/screens/detail_restaurant_screen.dart';

void main() {
  testWidgets('App loads smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const KulinerLokalApp());
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Verify that the app title or main header is rendered.
    expect(find.byType(KulinerLokalApp), findsOneWidget);
  });

  group('CulinaryProvider Review CRUD Tests', () {
    test('addReview, editReview, and deleteReview update state and ratings correctly', () {
      final provider = CulinaryProvider();
      final place = provider.allPlaces.first;
      final initialCount = place.reviewCount;
      final initialReviewsCount = place.reviews.length;

      // 1. Add review
      const newReview = ReviewModel(
        id: 'test_rev_1',
        author: 'Tester',
        rating: 5.0,
        comment: 'Enak sekali rasanya!',
        date: 'Baru saja',
      );
      provider.addReview(place.id, newReview);

      final placeAfterAdd = provider.allPlaces.firstWhere((p) => p.id == place.id);
      expect(placeAfterAdd.reviewCount, initialCount + 1);
      expect(placeAfterAdd.reviews.length, initialReviewsCount + 1);
      expect(placeAfterAdd.reviews.first.id, 'test_rev_1');
      expect(placeAfterAdd.reviews.first.comment, 'Enak sekali rasanya!');

      // 2. Edit review
      provider.editReview(place.id, 'test_rev_1', 'Porsi banyak dan lezat!', 4.0);

      final placeAfterEdit = provider.allPlaces.firstWhere((p) => p.id == place.id);
      final editedReview = placeAfterEdit.reviews.firstWhere((r) => r.id == 'test_rev_1');
      expect(editedReview.comment, 'Porsi banyak dan lezat!');
      expect(editedReview.rating, 4.0);

      // 3. Delete review
      provider.deleteReview(place.id, 'test_rev_1');

      final placeAfterDelete = provider.allPlaces.firstWhere((p) => p.id == place.id);
      expect(placeAfterDelete.reviewCount, initialCount);
      expect(placeAfterDelete.reviews.length, initialReviewsCount);
      expect(placeAfterDelete.reviews.any((r) => r.id == 'test_rev_1'), isFalse);
    });
  });

  group('RestaurantModel & Multi-Foto Fallback Tests', () {
    test('RestaurantModel.fromJson uses List images if provided', () {
      final map = {
        'id': 'r1',
        'name': 'Gudeg Wijilan',
        'images': ['https://img.com/1.jpg', 'https://img.com/2.jpg'],
      };

      final model = RestaurantModel.fromJson(map);
      expect(model.images.length, 2);
      expect(model.images.first, 'https://img.com/1.jpg');
      expect(model.image, 'https://img.com/1.jpg');
    });

    test('RestaurantModel.fromFirestore wraps single image String into List<String>', () {
      final map = {
        'id': 'r2',
        'name': 'Bakmi Kadin',
        'image': 'https://img.com/single.jpg',
      };

      final model = RestaurantModel.fromFirestore(map);
      expect(model.images.length, 1);
      expect(model.images.first, 'https://img.com/single.jpg');
      expect(model.image, 'https://img.com/single.jpg');
    });

    test('CulinaryPlace.fromMap backward compatibility with image / images', () {
      final map = {
        'id': 'cp1',
        'name': 'Sate Klathak',
        'image': 'https://img.com/sate.jpg',
      };

      final place = CulinaryPlace.fromMap(map);
      expect(place.images.length, 1);
      expect(place.images.first, 'https://img.com/sate.jpg');
      expect(place.imageUrl, 'https://img.com/sate.jpg');
      expect(place.galleryImages.first, 'https://img.com/sate.jpg');
    });

    testWidgets('DetailRestaurantScreen renders CarouselSlider', (WidgetTester tester) async {
      const restaurant = RestaurantModel(
        id: '',
        name: 'Resto Demo',
        images: ['https://example.com/1.jpg', 'https://example.com/2.jpg'],
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: DetailRestaurantScreen(restaurant: restaurant),
        ),
      );

      expect(find.byType(CarouselSlider), findsOneWidget);
    });
  });

  group('LocationService & GPS Fallback Tests', () {
    test('CulinaryProvider provides default Yogyakarta Pusat fallback', () {
      final provider = CulinaryProvider();
      expect(provider.userLatitude, CulinaryProvider.defaultLatitude);
      expect(provider.userLongitude, CulinaryProvider.defaultLongitude);
      expect(provider.activeLocation, CulinaryProvider.defaultLocationName);
    });

    test('Updating location recalculates real distances across all places', () {
      final provider = CulinaryProvider();
      final initialDistances = provider.allPlaces.map((p) => p.distanceKm).toList();

      // Change location to Sleman
      provider.updateLocation('Sleman, DI Yogyakarta');
      final updatedDistances = provider.allPlaces.map((p) => p.distanceKm).toList();

      // Distances must be updated and recalculated
      expect(provider.userLatitude, -7.7121);
      expect(provider.userLongitude, 110.3589);
      expect(updatedDistances, isNot(equals(initialDistances)));
    });
  });
}
