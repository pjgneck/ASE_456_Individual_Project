import 'package:flutter/material.dart';
import 'models/user.dart';
import 'models/store.dart';

class AppState extends ChangeNotifier {
  User? _user;

  // Selected store (used when GM/Manager log in OR Franchise user selects one)
  Store? _selectedStore;

  // For Franchise users → store list
  List<Store> _stores = [];

  // -----------------------
  // Getters
  // -----------------------
  User? get user => _user;
  Store? get store => _selectedStore;
  List<Store> get stores => _stores;

  bool get isLoggedIn => _user != null;

  bool get isFranchise => _user?.role == "franchise";
  bool get isGeneralManager => _user?.role == "general_manager";
  bool get isManager => _user?.role == "manager";

  // -----------------------
  // Setters
  // -----------------------

  /// Saves logged-in user to app state
  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  /// Sets selected store (works for all roles)
  void setSelectedStore(Store store) {
    _selectedStore = store;
    notifyListeners();
  }

  /// Sets the store list for franchise role
  void setStores(List<Store> storeList) {
    _stores = storeList;
    notifyListeners();
  }

  /// Clears user + stores (logout)
  void clear() {
    _user = null;
    _selectedStore = null;
    _stores = [];
    notifyListeners();
  }

  // -----------------------
  // Logic helpers
  // -----------------------

  /// Determines if the user should select a store manually
  /// Franchise: Yes → unless 1 store only
  /// GM/Manager: No → they already have a single assigned store
  bool get requiresStoreSelection {
    if (isFranchise) {
      return _stores.length > 1;
    }
    // GM or Manager → always 1 store assigned
    return false;
  }

  /// Automatically set store for non-franchise users
  void autoAssignSingleStore(Store? store) {
    if (!isFranchise && store != null) {
      _selectedStore = store;
      notifyListeners();
    }
  }

  /// Franchise helper: If there is exactly one store, auto-select it
  void autoSelectIfSingleFranchiseStore() {
    if (isFranchise && _stores.length == 1) {
      _selectedStore = _stores.first;
      notifyListeners();
    }
  }
}
