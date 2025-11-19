import 'package:flutter/material.dart';
import '../../core/models/store.dart';
import '../../core/models/truck.dart';
import '../../services/truck_service.dart';
import './TruckOrder.dart'; // TruckOrderScreen
import './newTruckOrder.dart'; // <- Import your create page

class TruckListScreen extends StatefulWidget {
  final Store store;

  const TruckListScreen({super.key, required this.store});

  @override
  State<TruckListScreen> createState() => _TruckListScreenState();
}

class _TruckListScreenState extends State<TruckListScreen> {
  final TruckService _truckService = TruckService();
  List<Truck> trucks = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadTrucks();
  }

  Future<void> loadTrucks() async {
    setState(() => loading = true);
    trucks = await _truckService.getTrucksForStore(widget.store.id);
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2575FC),
        title: Text(
          "Trucks – ${widget.store.name}",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : trucks.isEmpty
              ? const Center(child: Text("No trucks for this store"))
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: trucks.length,
                  itemBuilder: (context, index) {
                    final truck = trucks[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                        title: Text(
                          "Truck Delivery: ${truck.deliveryDate.toLocal().toString().split(' ')[0]}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        subtitle: Text(
                          "Truck ID: ${truck.id}",
                          style: const TextStyle(color: Colors.grey),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios,
                            size: 20, color: Color(0xFF2575FC)),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => TruckOrderScreen(
                                  store: widget.store, truckID: truck.id),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          // Navigate to CreateTruckOrderPage and refresh list on return
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CreateTruckOrderPage(),
            ),
          );
          loadTrucks(); // Refresh list after creating a truck
        },
        label: const Text("Add Truck Order"),
        icon: const Icon(Icons.add),
        backgroundColor: const Color(0xFF2575FC),
      ),
    );
  }
}
