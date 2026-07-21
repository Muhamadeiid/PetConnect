import '../models/pet.dart';

class DemoPetRepository {
  const DemoPetRepository();

  Future<List<Pet>> discover() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return _demoPets;
  }

  Future<void> swipe({required String petId, required String action}) async {
    await Future.delayed(const Duration(milliseconds: 200));
  }
}

final _demoPets = [
  Pet(
    id: '1', ownerId: 'demo', name: 'Luna',
    species: 'Cat', breed: 'Persian', ageMonths: 8,
    gender: 'Female', bio: 'Calm and cuddly, loves naps by the window.',
    isVerified: true, isPublished: true, media: [],
  ),
  Pet(
    id: '2', ownerId: 'demo', name: 'Rex',
    species: 'Dog', breed: 'German Shepherd', ageMonths: 36,
    gender: 'Male', bio: 'Trained and loyal. Purebred with health certificate.',
    isVerified: true, isPublished: true, media: [],
  ),
  Pet(
    id: '3', ownerId: 'demo', name: 'Milo',
    species: 'Cat', breed: 'British Shorthair', ageMonths: 12,
    gender: 'Male', bio: 'Social cat who loves children. Looking for a playmate.',
    isVerified: false, isPublished: true, media: [],
  ),
  Pet(
    id: '4', ownerId: 'demo', name: 'Bella',
    species: 'Dog', breed: 'Golden Retriever', ageMonths: 24,
    gender: 'Female', bio: 'Sweet girl, great with families. House-trained.',
    isVerified: true, isPublished: true, media: [],
  ),
  Pet(
    id: '5', ownerId: 'demo', name: 'Snow',
    species: 'Cat', breed: 'Siamese', ageMonths: 6,
    gender: 'Female', bio: 'Tiny kitten needing a warm home. Playful and energetic.',
    isVerified: false, isPublished: true, media: [],
  ),
  Pet(
    id: '6', ownerId: 'demo', name: 'Max',
    species: 'Dog', breed: 'Siberian Husky', ageMonths: 48,
    gender: 'Male', bio: 'Active dog that needs space to run. Friendly with other pets.',
    isVerified: true, isPublished: true, media: [],
  ),
  Pet(
    id: '7', ownerId: 'demo', name: 'Coco',
    species: 'Bird', breed: 'African Grey Parrot', ageMonths: 36,
    gender: 'Male', bio: 'Talking parrot that knows many words. Fun and cheerful.',
    isVerified: false, isPublished: true, media: [],
  ),
  Pet(
    id: '8', ownerId: 'demo', name: 'Zizi',
    species: 'Cat', breed: 'Bengal', ageMonths: 12,
    gender: 'Female', bio: 'Rare Bengal cat. Needs special care and love.',
    isVerified: true, isPublished: true, media: [],
  ),
];
