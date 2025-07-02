import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../utils/constants.dart';
import 'api_service.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final ApiService _apiService = ApiService();

  Future<AuthResult> login(String email, String password) async {
    try {
      print('AuthService: Attempting login for $email');
      print('AuthService: Making POST request to ${ApiConstants.login}');
      
      final response = await _apiService.post(
        ApiConstants.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      print('AuthService: Login response received: ${response.statusCode}');
      print('AuthService: Response data: ${response.data}');

      final data = response.data as Map<String, dynamic>;
      final user = User.fromJson(data['user']);
      final token = data['access_token'] as String;

      // Guardar datos de sesión
      await _saveSession(user, token);

      print('AuthService: Login successful for user: ${user.email}');
      return AuthResult.success(user, token);
    } on ApiException catch (e) {
      print('AuthService: API Exception during login: ${e.message}');
      return AuthResult.error(e.message);
    } catch (e) {
      print('AuthService: Unexpected error during login: $e');
      return AuthResult.error('Error inesperado durante el login');
    }
  }

  Future<AuthResult> register({
    required String email,
    required String password,
    required String name,
    String? phone,
    String? address,
  }) async {
    try {
      final response = await _apiService.post(
        ApiConstants.register,
        data: {
          'email': email,
          'password': password,
          'name': name,
          if (phone != null) 'phone': phone,
          if (address != null) 'address': address,
        },
      );

      final data = response.data as Map<String, dynamic>;
      final user = User.fromJson(data['user']);
      final token = data['access_token'] as String;

      // Guardar datos de sesión
      await _saveSession(user, token);

      return AuthResult.success(user, token);
    } on ApiException catch (e) {
      return AuthResult.error(e.message);
    } catch (e) {
      return AuthResult.error('Error inesperado durante el registro');
    }
  }

  Future<void> logout() async {
    await _clearSession();
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(StorageKeys.accessToken);
    return token != null && token.isNotEmpty;
  }

  Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString(StorageKeys.userId);
    final email = prefs.getString(StorageKeys.userEmail);
    final name = prefs.getString(StorageKeys.userName);
    final role = prefs.getString(StorageKeys.userRole);

    if (userId != null && email != null && name != null && role != null) {
      return User(
        id: userId,
        email: email,
        name: name,
        role: role,
        isActive: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }

    return null;
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(StorageKeys.accessToken);
  }

  Future<User> updateProfile({
    required String name,
    String? phone,
    String? address,
  }) async {
    try {
      final response = await _apiService.put(
        ApiConstants.updateProfile,
        data: {
          'name': name,
          if (phone != null) 'phone': phone,
          if (address != null) 'address': address,
        },
      );

      final userData = response.data as Map<String, dynamic>;
      final user = User.fromJson(userData);

      // Actualizar datos guardados en SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(StorageKeys.userName, user.name);

      return user;
    } on ApiException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Error inesperado al actualizar perfil');
    }
  }

  Future<void> _saveSession(User user, String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(StorageKeys.accessToken, token);
    await prefs.setString(StorageKeys.userId, user.id);
    await prefs.setString(StorageKeys.userEmail, user.email);
    await prefs.setString(StorageKeys.userName, user.name);
    await prefs.setString(StorageKeys.userRole, user.role);
  }

  Future<void> _clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(StorageKeys.accessToken);
    await prefs.remove(StorageKeys.userId);
    await prefs.remove(StorageKeys.userEmail);
    await prefs.remove(StorageKeys.userName);
    await prefs.remove(StorageKeys.userRole);
  }
}

class AuthResult {
  final bool success;
  final User? user;
  final String? token;
  final String? error;

  AuthResult._(this.success, this.user, this.token, this.error);

  factory AuthResult.success(User user, String token) {
    return AuthResult._(true, user, token, null);
  }

  factory AuthResult.error(String error) {
    return AuthResult._(false, null, null, error);
  }
}
