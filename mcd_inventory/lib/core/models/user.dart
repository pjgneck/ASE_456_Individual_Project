// core/models/user.dart
class User {
  final String id;
  final String email;
  final String username;
  final String? storeId; // Assigned store
  final String role; // Role of the user (Franchise, General Manager, Manager)
  final Map<String, dynamic> raw;

  User({
    required this.id,
    required this.email,
    required this.username,
    this.storeId,
    required this.role,
    required this.raw,
  });

  factory User.fromRecord(dynamic record) {
    return User(
      id: record.id,
      email: record.data['email'] ?? '',
      username: record.data['email'] ?? '',
      storeId: record.data['store'],
      role: record.data['role'] ?? 'Manager', // default to Manager if not set
      raw: record.data,
    );
  }

  bool get isFranchise => role.toLowerCase() == 'franchise';
  bool get isGeneralManager => role.toLowerCase() == 'general manager';
  bool get isManager => role.toLowerCase() == 'manager';
}
