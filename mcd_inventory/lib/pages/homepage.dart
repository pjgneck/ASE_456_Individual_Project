import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_state.dart';
import '../../core/models/store.dart';
import '../../services/store_service.dart';
import 'inventory.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final storeService = StoreService();
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadStores();
  }

  Future<void> loadStores() async {
    final state = context.read<AppState>();
    final user = state.user;

    if (user == null) {
      setState(() {
        loading = false;
      });
      return;
    }

    // Fetch stores based on role
    final stores = await storeService.getStoresForUser(user);
    state.setStores(stores);

    // Auto-select a store if none is selected
    if (state.store == null && stores.isNotEmpty) {
      state.setSelectedStore(stores.first); // <-- default to first store
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final username = state.user?.username ?? "User";
    final displayInitial =
        username.isNotEmpty ? username[0].toUpperCase() : "U";

    final selectedStore = state.store;
    final storeName = selectedStore?.name ?? "No store assigned";
    final storeLocation = selectedStore?.location ?? "-";

    return Scaffold(
      backgroundColor: const Color(0xFFEDECF2),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2575FC),
        title: const Text(
          "Dashboard",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        elevation: 0,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome Card
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    elevation: 10,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 35,
                            backgroundColor: Colors.white,
                            child: Text(
                              displayInitial,
                              style: const TextStyle(
                                  fontSize: 28, color: Color(0xFF2575FC)),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Welcome, $username!",
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                const SizedBox(height: 6),
                                const Text(
                                  "Check your store details below",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white70),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),

                  // Dropdown for multiple stores (Franchise)
                  if (state.stores.length > 1) ...[
                    const Text(
                      "Select a Store",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    DropdownButton<Store>(
                      value: selectedStore,
                      isExpanded: true,
                      items: state.stores
                          .map((store) => DropdownMenuItem<Store>(
                                value: store,
                                child: Text(store.name),
                              ))
                          .toList(),
                      onChanged: (store) {
                        if (store != null) {
                          state.setSelectedStore(store);
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Store Card with Open Inventory button
                  Stack(
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        elevation: 6,
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 70),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Store Information",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 14),
                              Row(
                                children: [
                                  const Icon(Icons.store,
                                      color: Color(0xFF6A11CB)),
                                  const SizedBox(width: 10),
                                  Text(storeName,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF2575FC))),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(Icons.location_on,
                                      color: Color(0xFF6A11CB)),
                                  const SizedBox(width: 10),
                                  Text(storeLocation,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF2575FC))),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Left accent strip
                      Positioned(
                        left: 0,
                        top: 0,
                        bottom: 0,
                        child: Container(
                          width: 6,
                          decoration: BoxDecoration(
                            color: const Color(0xFF6A11CB),
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                bottomLeft: Radius.circular(20)),
                          ),
                        ),
                      ),
                      // Open Inventory Button
                      Positioned(
                        bottom: 15,
                        left: 20,
                        right: 20,
                        child: SizedBox(
                          height: 50,
                          child: ElevatedButton.icon(
                            onPressed: selectedStore != null
                                ? () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              const InventoryScreen()),
                                    );
                                  }
                                : null,
                            icon: const Icon(Icons.inventory, size: 24),
                            label: const Text(
                              "Open Inventory",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6A11CB),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 6,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
