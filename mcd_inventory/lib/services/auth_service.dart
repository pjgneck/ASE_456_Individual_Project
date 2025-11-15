// services/auth_service.dart
import '../core/pocketbase.dart';
import '../core/models/user.dart';
import '../core/app_state.dart';

class AuthService {
  final pb = PBClient.client;

  Future<User?> login(String email, String password) async {
    try {
      final result = await pb.collection('users').authWithPassword(
        email,
        password,
      );
      final user = User.fromRecord(result.record);
      return user;
    } catch (e) {
      print("Login error: $e");
      return null;
    }
  }

  Future<User?> signup(String email, String password, {String? role}) async {
    try {
      final result = await pb.collection('users').create(body: {
        "email": email,
        "password": password,
        "passwordConfirm": password,
        "role": role ?? 'Manager',
      });

      return User.fromRecord(result);
    } catch (e) {
      print("Signup error: $e");
      return null;
    }
  }

  void logout(AppState state) {
    pb.authStore.clear();
    state.clear();
  }

  bool get isLoggedIn => pb.authStore.isValid;
}
