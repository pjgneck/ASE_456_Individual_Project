# MC Inventory - Testing Documentation

This document explains how to run and maintain **unit and widget tests** for the MC Inventory Flutter project.

---

## ⚡ Overview

The testing setup focuses on:

- **Main Application (`main.dart`)**: Ensures the app launches correctly and the initial app state is set.  
- **HomeScreen (`home_screen.dart`)**: Tests UI components, loading states, and navigation functionality.  

> Note: The `InventoryScreen` tests have been removed to prevent PocketBase network errors during automated testing.

---

## 🛠 Test Structure

All tests are located in the `test/` directory:

---

### Test Types

1. **Widget Tests**:  
   - Verify UI components render correctly.
   - Ensure navigation between screens works as expected.
   - Check conditional widgets (e.g., loading indicators).

2. **State Tests**:  
   - Validate `AppState` behavior when setting the current user and store.
   - Confirm proper updates when selecting stores.

---

## 🚀 Running Tests

To run all tests:

```bash
flutter test
```