import 'package:flutter_test/flutter_test.dart';
import 'package:petconnect/models/match_summary.dart';
import 'package:petconnect/models/pet.dart';

void main() {
  group('Pet model', () {
    test('parses API rows and prefers the primary photo', () {
      final pet = Pet.fromRow({
        'id': 'pet-1',
        'owner_id': 'owner-1',
        'name': 'Luna',
        'species': 'cat',
        'breed': 'Mau',
        'age_months': 18,
        'gender': 'female',
        'is_verified': true,
        'is_published': true,
        'pet_media': [
          {'id': 'm1', 'url': 'secondary.jpg', 'kind': 'image'},
          {
            'id': 'm2',
            'url': 'primary.jpg',
            'kind': 'image',
            'is_primary': true,
          },
        ],
      });

      expect(pet.primaryPhoto, 'primary.jpg');
      expect(pet.ageLabel, '1 yr');
      expect(pet.isVerified, isTrue);
    });

    test('handles missing optional data safely', () {
      final pet = Pet.fromRow({
        'id': 'pet-2',
        'owner_id': 'owner-2',
        'name': 'Max',
        'species': 'dog',
        'gender': 'male',
      });

      expect(pet.primaryPhoto, isEmpty);
      expect(pet.ageLabel, isEmpty);
      expect(pet.media, isEmpty);
    });
  });

  test('ChatMessage supplies an empty body for a nullable API value', () {
    final message = ChatMessage.fromRow({
      'id': 'message-1',
      'sender_id': 'user-1',
      'body': null,
      'created_at': '2026-07-19T12:00:00Z',
    });

    expect(message.body, isEmpty);
    expect(message.createdAt.isUtc, isTrue);
  });
}
