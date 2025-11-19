import '../core/pocketbase.dart';
import '../core/models/truck.dart';

class TruckService {
  final pb = PBClient.client;

  // Create a truck for a store
  Future<Truck?> createTruck(String storeId, DateTime deliveryDate) async {
    try {
      final record = await pb.collection('truck').create(body: {
        "store": storeId,
        "delivery_date": deliveryDate.toIso8601String(),
      });

      return Truck.fromRecord(record);
    } catch (e) {
      print("Truck create error: $e");
      return null;
    }
  }

  // Fetch all trucks for a store
  Future<List<Truck>> getTrucksForStore(String storeId) async {
    try {
      final records = await pb.collection('truck').getFullList(
        filter: 'store = "$storeId"',
      );
      return records.map((r) => Truck.fromRecord(r)).toList();
    } catch (e) {
      print("Truck fetch error: $e");
      return [];
    }
  }

  // Fetch a single truck by its ID
  Future<Truck?> getTruckById(String truckId) async {
    try {
      final record = await pb.collection('truck').getOne(truckId);
      return Truck.fromRecord(record);
    } catch (e) {
      print("Truck fetch by ID error: $e");
      return null;
    }
  }
}
