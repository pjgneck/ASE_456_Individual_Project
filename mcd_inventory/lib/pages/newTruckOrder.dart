import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/app_state.dart';
import '../../core/models/item.dart';
import '../../services/item_service.dart';
import '../../services/truck_service.dart';
import '../../services/truck_item_service.dart';

class CreateTruckOrderPage extends StatefulWidget {
  const CreateTruckOrderPage({super.key});

  @override
  State<CreateTruckOrderPage> createState() => _CreateTruckOrderPageState();
}

class _CreateTruckOrderPageState extends State<CreateTruckOrderPage> {
  final itemService = ItemService();
  final truckService = TruckService();
  final orderItemService = TruckOrderItemService();

  List<Item> items = [];
  Map<String, int> quantities = {};
  bool loading = true;

  DateTime? deliveryDate;

  @override
  void initState() {
    super.initState();
    loadItems();
  }

  Future<void> loadItems() async {
    final result = await itemService.getItems();
    setState(() {
      items = result;
      loading = false;
    });
  }

  void setQty(String itemId, String text) {
    final value = int.tryParse(text) ?? 0;
    setState(() => quantities[itemId] = value);
  }

  Future<void> submitOrder() async {
    final store = context.read<AppState>().store;
    if (store == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No store selected.")),
      );
      return;
    }

    if (deliveryDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Select a delivery date.")),
      );
      return;
    }

    final truck = await truckService.createTruck(store.id, deliveryDate!);
    if (truck == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to create truck order.")),
      );
      return;
    }

    for (var item in items) {
      final qty = quantities[item.id] ?? 0;
      if (qty > 0) {
        await orderItemService.createOrderItem(truck.id, item.id, qty);
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Truck Order Created!")),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final storeName = context.watch<AppState>().store?.name ?? "Store";

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: Text("New Truck Order – $storeName"),
        backgroundColor: const Color(0xFF2575FC),
        elevation: 0,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Delivery Date Picker
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 3,
                    child: ListTile(
                      title: Text(
                        deliveryDate == null
                            ? "Select Delivery Date"
                            : "Delivery: ${deliveryDate!.toLocal().toString().split(' ')[0]}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now().add(const Duration(days: 1)),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );
                        if (picked != null) {
                          setState(() => deliveryDate = picked);
                        }
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Items",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2575FC)),
                  ),
                  const Divider(thickness: 2),

                  Expanded(
                    child: ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          elevation: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 25,
                                  backgroundColor: const Color(0xFF2575FC),
                                  child: Text(
                                    item.name[0].toUpperCase(),
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.name,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "Unit: ${item.unit}",
                                        style: const TextStyle(
                                            fontSize: 14, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 70,
                                  child: TextField(
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      hintText: "Qty",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      filled: true,
                                      fillColor: Colors.grey[100],
                                    ),
                                    onChanged: (text) => setQty(item.id, text),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  ElevatedButton.icon(
                    onPressed: submitOrder,
                    icon: const Icon(Icons.send),
                    label: const Text(
                      "Submit Truck Order",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2575FC),
                      minimumSize: const Size.fromHeight(50),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
