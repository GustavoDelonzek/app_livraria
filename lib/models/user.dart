class UserLocal {
  final String id;
  final String name;
  final String bio;
  final List<String> favoriteGenres;
  final List<String> followers;
  final List<String> following;
  final int followersCount;
  final int followingCount;

  UserLocal({
    required this.id,
    required this.name,
    required this.bio,
    required this.favoriteGenres,
    required this.followers,
    required this.following,
    required this.followersCount,
    required this.followingCount,
  });

  factory UserLocal.fromMap(Map<String, dynamic> map, String uid) {
    return UserLocal(
      id: uid,
      name: map['name'] ?? '',
      bio: map['bio'] ?? '',
      favoriteGenres: List<String>.from(map['favoriteGenres'] ?? []),
      followers: List<String>.from(map['followers'] ?? []),
      following: List<String>.from(map['following'] ?? []),
      followersCount: map['followersCount'] ?? 0,
      followingCount: map['followingCount'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'bio': bio,
      'favoriteGenres': favoriteGenres,
      'followers': followers,
      'following': following,
      'followersCount': followersCount,
      'followingCount': followingCount,
    };
  }
}
