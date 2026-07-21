import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/theme.dart';
import '../../data/pet_creation_repository.dart';

class AddPetScreen extends StatefulWidget {
  const AddPetScreen({super.key});
  @override
  State<AddPetScreen> createState() => _AddPetScreenState();
}

class _AddPetScreenState extends State<AddPetScreen> {
  final _name = TextEditingController();
  final _breed = TextEditingController();
  final _bio = TextEditingController();
  String _species = 'dog';
  String _gender = 'male';
  double _ageMonths = 12;
  final _photos = <XFile>[];
  final _picker = ImagePicker();
  final _repository = const PetCreationRepository();
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Add a pet', style: tt.headlineLarge),
            Text(
              'Minimum 3 photos required. Our AI checks each upload.',
              style: tt.bodyMedium?.copyWith(color: AppColors.onSurfaceVariant),
            ),
            const SizedBox(height: 20),
            _photoGrid(),
            const SizedBox(height: 20),
            _label('Name'),
            TextField(
              controller: _name,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(hintText: 'e.g. Rio'),
            ),
            const SizedBox(height: 12),
            _label('Species'),
            Wrap(
              spacing: 8,
              children:
                  ['dog', 'cat', 'bird', 'rabbit', 'reptile', 'fish', 'other']
                      .map(
                        (s) => ChoiceChip(
                          label: Text(s),
                          selected: _species == s,
                          onSelected: (_) => setState(() => _species = s),
                          selectedColor: AppColors.primaryContainer,
                          labelStyle: TextStyle(
                            color: _species == s
                                ? Colors.white
                                : AppColors.onSurface,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                      )
                      .toList(),
            ),
            const SizedBox(height: 12),
            _label('Breed'),
            TextField(
              controller: _breed,
              decoration: const InputDecoration(
                hintText: 'e.g. Golden Retriever',
              ),
            ),
            const SizedBox(height: 12),
            _label('Gender'),
            Row(
              children: [
                Expanded(child: _genderTile('male', Icons.male)),
                const SizedBox(width: 8),
                Expanded(child: _genderTile('female', Icons.female)),
              ],
            ),
            const SizedBox(height: 12),
            _label('Age: ${_ageLabel(_ageMonths.toInt())}'),
            Slider(
              value: _ageMonths,
              min: 0,
              max: 240,
              divisions: 240,
              activeColor: AppColors.primaryContainer,
              onChanged: (v) => setState(() => _ageMonths = v),
            ),
            const SizedBox(height: 12),
            _label('Bio (optional)'),
            TextField(
              controller: _bio,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Tell us about your pet…',
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _canPublish() && !_saving ? _publish : null,
                child: Text(
                  _saving
                      ? 'Publishing…'
                      : 'Publish (${_photos.length}/3 photos)',
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                'Publishing runs AI moderation (NSFW + pet detection)',
                style: tt.labelSmall?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String t) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(
      t,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 13,
        color: AppColors.onSurfaceVariant,
      ),
    ),
  );

  Widget _genderTile(String value, IconData icon) {
    final selected = _gender == value;
    return GestureDetector(
      onTap: () => setState(() => _gender = value),
      child: Container(
        height: 56,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primaryContainer.withValues(alpha: 0.15)
              : Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: selected
                ? AppColors.primaryContainer
                : AppColors.outlineVariant,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: selected ? AppColors.primaryContainer : AppColors.outline,
            ),
            const SizedBox(width: 8),
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: selected
                    ? AppColors.primaryContainer
                    : AppColors.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _photoGrid() {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      children: [
        for (int i = 0; i < 6; i++)
          i < _photos.length
              ? Container(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainer,
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.check_circle,
                    color: AppColors.secondary,
                    size: 36,
                  ),
                )
              : GestureDetector(
                  onTap: _pickPhoto,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      border: Border.all(
                        color: AppColors.outlineVariant,
                        style: BorderStyle.solid,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          i < 3
                              ? Icons.add_a_photo_outlined
                              : Icons.add_photo_alternate_outlined,
                          color: i < 3
                              ? AppColors.primaryContainer
                              : AppColors.outline,
                        ),
                        if (i < 3)
                          const Padding(
                            padding: EdgeInsets.only(top: 4),
                            child: Text(
                              'Required',
                              style: TextStyle(
                                fontSize: 10,
                                color: AppColors.primaryContainer,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
      ],
    );
  }

  String _ageLabel(int m) => m < 12
      ? '$m months'
      : m == 12
      ? '1 year'
      : '${m ~/ 12} yr ${m % 12} mo';

  bool _canPublish() => _name.text.trim().isNotEmpty && _photos.length >= 3;

  @override
  void dispose() {
    _name.dispose();
    _breed.dispose();
    _bio.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    if (_photos.length >= 6) return;
    final photo = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 88,
      maxWidth: 1920,
    );
    if (photo != null && mounted) setState(() => _photos.add(photo));
  }

  Future<void> _publish() async {
    setState(() => _saving = true);
    try {
      await _repository.create(
        name: _name.text,
        species: _species,
        gender: _gender,
        ageMonths: _ageMonths.toInt(),
        breed: _breed.text,
        bio: _bio.text,
        photos: _photos,
      );
      if (!mounted) return;
      _name.clear();
      _breed.clear();
      _bio.clear();
      setState(() => _photos.clear());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pet submitted for review.')),
      );
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not publish pet: $error')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}
