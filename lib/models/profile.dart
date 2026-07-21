class Profile {
  final String id;
  final String fullName;
  final String? avatarUrl;
  final String? city;
  final int trustScore;
  final String idVerifyState;

  Profile({
    required this.id,
    required this.fullName,
    this.avatarUrl,
    this.city,
    this.trustScore = 0,
    this.idVerifyState = 'unverified',
  });

  bool get isVerified => idVerifyState == 'verified';

  factory Profile.fromRow(Map<String, dynamic> row) => Profile(
    id: row['id'] as String,
    fullName: row['full_name'] as String,
    avatarUrl: row['avatar_url'] as String?,
    city: row['city'] as String?,
    trustScore: row['trust_score'] as int? ?? 0,
    idVerifyState: row['id_verify_state'] as String? ?? 'unverified',
  );
}
