import 'package:flutter/material.dart';
import '../core/models/store.dart';
import '../core/models/truck.dart';
import '../core/models/truckItem.dart';
import '../services/truck_item_service.dart';
import '../services/truck_service.dart';

class TruckOrderScreen extends StatefulWidget {
  final String truckID;
  final Store store;

  const TruckOrderScreen({
    super.key,
    required this.truckID,
    required this.store,
  });

  @override
  State<TruckOrderScreen> createState() => _TruckOrderScreenState();
}

class _TruckOrderScreenState extends State<TruckOrderScreen> {
  final TruckService _truckService = TruckService();
  final TruckOrderItemService _orderItemService = TruckOrderItemService();

  Truck? truck;
  List<TruckOrderItem> items = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadTruckAndItems();
  }

  Future<void> loadTruckAndItems() async {
    setState(() => loading = true);

    // Fetch the specific truck by ID
    truck = await _truckService.getTruckById(widget.truckID);

    if (truck == null) {
      setState(() => loading = false);
      return;
    }

    // Fetch items for this truck
    items = await _orderItemService.getOrderItems(truck!.id);

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2575FC),
        title: Text(
          truck != null
              ? "Truck Delivery – ${truck!.deliveryDate.toString().split(' ')[0]}"
              : "No Truck Found",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : truck == null
              ? const Center(child: Text("No truck found"))
              : Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        for (int i = 0; i < items.length; i += 2)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(child: buildItemCard(items[i])),
                              const SizedBox(width: 12),
                              if (i + 1 < items.length)
                                Expanded(child: buildItemCard(items[i + 1]))
                              else
                                const Expanded(child: SizedBox()),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget buildItemCard(TruckOrderItem item) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.item.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              "SKU: ${item.item.unit}   Qty: ${item.quantity}",
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Delivered",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Switch(
                  value: item.delivered,
                  activeColor: const Color(0xFF2575FC),
                  onChanged: (val) async {
                    await _orderItemService.updateDelivered(item.id, val);
                    await loadTruckAndItems(); // refresh UI
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
