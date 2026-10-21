class UserModel {
  final String id;
  final String name;
  final String email;
  final String bio;
  final String avatarUrl;
  final String joinDate;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.bio,
    required this.avatarUrl,
    required this.joinDate,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? bio,
    String? avatarUrl,
    String? joinDate,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      bio: bio ?? this.bio,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      joinDate: joinDate ?? this.joinDate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'bio': bio,
      'avatarUrl': avatarUrl,
      'joinDate': joinDate,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String? ?? 'user_alya',
      name: json['name'] as String? ?? 'Alya Putri',
      email: json['email'] as String? ?? 'alya.putri@gmail.com',
      bio: json['bio'] as String? ??
          'Mencari rasa rumahan dan cerita di balik setiap hidangan lokal.',
      avatarUrl: json['avatarUrl'] as String? ?? '',
      joinDate: json['joinDate'] as String? ?? 'Bergabung sejak Mei 2026',
    );
  }

  static UserModel defaultUser() {
    return const UserModel(
      id: 'user_alya',
      name: 'Alya Putri',
      email: 'alya.putri@gmail.com',
      bio: 'Mencari rasa rumahan dan cerita di balik setiap hidangan lokal.',
      avatarUrl:
          'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?q=80&w=400&auto=format&fit=crop',
      joinDate: 'Bergabung sejak Mei 2026',
    );
  }

  static UserModel guestUser() {
    return const UserModel(
      id: 'guest',
      name: 'Tamu Kuliner',
      email: 'tamu@kulinerlokal.id',
      bio: 'Sedang menjelajahi aneka kuliner lezat khas Yogyakarta.',
      avatarUrl: '',
      joinDate: 'Tamu',
    );
  }
}
