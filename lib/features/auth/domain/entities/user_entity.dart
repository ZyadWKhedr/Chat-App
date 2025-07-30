class UserEntity {
  final String id;
  final String name;
  final String? email;
  final String? imageUrl;

  UserEntity({
    required this.id,
    required this.name,
    this.email,
    this.imageUrl,
  });
}
