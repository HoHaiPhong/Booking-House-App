import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:flutter/foundation.dart';

class ApiService {
  final Dio _dio = Dio();
  final _storage = const FlutterSecureStorage();
  
  // Dynamic Base URL
  static String get baseUrl {
    if (kIsWeb) return 'http://localhost:5000/api';
    
    // 10.0.2.2 is the special localhost alias for Android Emulator
    // 'http://10.20.7.196:5000/api' is your local machine IP for physical devices.
    // Change if needed, but 10.0.2.2 covers 99% of Android Emulator cases.
    return 'http://10.0.2.2:5000/api';
  }

  ApiService() {
    _dio.options.baseUrl = baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);
    _dio.options.sendTimeout = const Duration(seconds: 10);
    _dio.options.headers['Content-Type'] = 'application/json';
    
    // Add interceptor to attach Token
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storage.read(key: 'token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token'; // Important for Admin/Host
        }
        return handler.next(options);
      },
    ));
  }

  Future<dynamic> post(String path, dynamic data) async {
    try {
      final response = await _dio.post(path, data: data);
      return response.data;
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? e.message;
    }
  }

  Future<dynamic> get(String path, {Map<String, dynamic>? params}) async {
    try {
      final response = await _dio.get(path, queryParameters: params);
      return response.data;
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? e.message;
    }
  }

  // Check if delete exists, if not add it.
  Future<dynamic> delete(String path) async {
    try {
        final response = await _dio.delete(path);
        return response.data;
    } on DioException catch (e) {
        throw e.response?.data['message'] ?? e.message;
    }
  }

  Future<dynamic> put(String path, dynamic data) async {
    try {
      final response = await _dio.put(path, data: data);
      return response.data;
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? e.message;
    }
  }
}
