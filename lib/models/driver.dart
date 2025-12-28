class Driver {
  final String id;
  final String username;
  final String email;
  final String? phone;
  final bool isActive;

  Driver({
    required this.id,
    required this.username,
    required this.email,
    this.phone,
    required this.isActive,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json['id']?.toString() ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      isActive: json['is_active'] ?? true,
    );
  }
}

