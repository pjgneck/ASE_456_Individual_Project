import '../core/pocketbase.dart';
import '../core/models/store.dart';
import '../core/models/user.dart';


class StoreService {
  final pb = PBClient.client;

  // Get a single store by ID (existing)
  Future<Store?> getStore(String id) async {
    try {
      final record = await pb.collection('stores').getOne(id);
      return Store.fromRecord(record);
    } catch (e) {
      print("Store fetch error: $e");
      return null;
    }
  }

  // NEW: Get stores for a user based on role
  Future<List<Store>> getStoresForUser(User user) async {
    try {
      List<dynamic> records = [];

      if (user.role == 'franchise') {
        // Franchise sees all stores
        records = await pb.collection('stores').getFullList();
      } else if (user.role == 'general_manager' || user.role == 'manager') {
        // GM / Manager sees only their assigned store
        if (user.storeId != null) {
          final record = await pb.collection('stores').getOne(user.storeId!);
          if (record != null) records = [record];
        }
      }

      return records.map((r) => Store.fromRecord(r)).toList();
    } catch (e) {
      print("Error fetching stores for user: $e");
      return [];
    }
  }
}
