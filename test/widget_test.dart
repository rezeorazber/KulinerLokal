import 'package:flutter_test/flutter_test.dart';
import 'package:kuliner_lokal/main.dart';
import 'package:kuliner_lokal/models/review_model.dart';
import 'package:kuliner_lokal/providers/culinary_provider.dart';

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
}
