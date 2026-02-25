import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  String? _token;
  bool _isLoading = false;
  final AuthService _authService = AuthService();
  final _storage = const FlutterSecureStorage();

  User? get user => _user;
  String? get token => _token;
  bool get isLoading => _isLoading;

  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final data = await _authService.login(email, password);
      _token = data['token'];
      _user = User.fromJson(data['user']);
      
      await _storage.write(key: 'token', value: _token);
      // In real app, save user data too or fetch profile
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> register(String fullName, String email, String password, String phone) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _authService.register(fullName, email, password, phone);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void logout() async {
    _user = null;
    _token = null;
    await _storage.delete(key: 'token');
    notifyListeners();
  }
}
