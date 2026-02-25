import 'package:dio/dio.dart';
import '../models/user_model.dart';
import 'api_service.dart';

class AuthService extends ApiService {
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await post('/auth/login', {
        'email': email,
        'mat_khau': password,
      });

      return response; // Should return { token, user }
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<void> register(String fullName, String email, String password, String phone) async {
    try {
      await post('/auth/register', {
        'ho_ten': fullName,
        'email': email,
        'mat_khau': password,
        'so_dien_thoai': phone,
      });
    } catch (e) {
        throw Exception('Register failed: $e');
    }
  }
}
