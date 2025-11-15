// services/user_service.dart
import '../core/pocketbase.dart';
import '../core/models/user.dart';

class UserService {
  final pb = PBClient.client;

  // Get user by ID
  Future<User?> getUser(String userId) async {
    try {
      final record = await pb.collection('users').getOne(userId);
      return User.fromRecord(record);
    } catch (e) {
      print("Get user error: $e");
      return null;
    }
  }

  // Assign a store to a user
  Future<bool> assignStore(String userId, String storeId) async {
    try {
      await pb.collection('users').update(userId, body: {
        'store': storeId,
      });
      return true;
    } catch (e) {
      print("Assign store error: $e");
      return false;
    }
  }

  // Fetch all users
  Future<List<User>> getAllUsers() async {
    try {
      final records = await pb.collection('users').getFullList();
      return records.map((r) => User.fromRecord(r)).toList();
    } catch (e) {
      print("Get all users error: $e");
      return [];
    }
  }
}
