
class UserModel {
  final String id;
  final String email;
  final String first_name;
  final String last_name;
  final String avatar;

  UserModel({
    required this.id,
    required this.email,
    required this.first_name,
    required this.last_name,
    this.avatar = '',
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Data kontak berada di dalam properti "data"
    final Map<String, dynamic> contact =
        json['data'] is Map<String, dynamic>
            ? json['data']
            : json;

    return UserModel(
      id: json['id']?.toString() ?? '',
      email: contact['email']?.toString() ?? '',
      first_name: contact['first_name']?.toString() ?? '',
      last_name: contact['last_name']?.toString() ?? '',
      avatar: contact['avatar']?.toString() ?? '',
    );
  }
}
