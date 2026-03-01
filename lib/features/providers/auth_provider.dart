import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:news_app/features/core/local/auth_local_storage.dart';

final authStorageProvider = Provider((ref) => AuthLocalStorage());

class AuthState {
  final bool loading;
  final String? error;

  const AuthState({this.loading = false, this.error});

  AuthState copyWith({bool? loading, String? error}) =>
      AuthState(loading: loading ?? this.loading, error: error);
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthLocalStorage storage;

  AuthNotifier(this.storage) : super(const AuthState());

void clearError() {
    state = const AuthState();
  }

Future<bool> register(String email, String pass) async {
    state = state.copyWith(loading: true);

    final success = await storage.register(email, pass);

    if (!success) {
      state = const AuthState(error: 'This email is already registered');
      return false;
    }

    state = const AuthState();
    return true;
  }

Future<bool> login(String email, String pass) async {
    state = state.copyWith(loading: true);

    final success = storage.login(email, pass);

    if (success) {
      await storage.saveSession(email);
      state = const AuthState();
      return true;
    } else {
      state = const AuthState(error: 'Invalid email or password');
      return false;
    }
  }

Future<void> resetPassword(String email, String newPass) async {
    state = state.copyWith(loading: true);

    final success = await storage.updatePassword(email, newPass);

    if (!success) {
      state = const AuthState(error: 'No account found with this email');
      return;
    }

    state = const AuthState();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.read(authStorageProvider));
});
