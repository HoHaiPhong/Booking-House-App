import 'package:dio/dio.dart';
import '../models/property_model.dart';
import 'api_service.dart';

class PropertyService extends ApiService {
  Future<List<Property>> getAllProperties() async {
    try {
      final data = await get('/properties');
      List<dynamic> list = data;
      return list.map((json) => Property.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load properties: $e');
    }
  }

  Future<List<Property>> getMyProperties() async {
    try {
      final data = await get('/properties/me'); // Call the new API
      List<dynamic> list = data;
      return list.map((json) => Property.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load my properties: $e');
    }
  }

  Future<List<Property>> searchProperties(double lat, double lng, double radius) async {
    try {
      final data = await get('/properties/search', params: {
        'userLat': lat,
        'userLng': lng,
        'radius': radius,
      });
      List<dynamic> list = data;
      return list.map((json) => Property.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to search properties: $e');
    }
  }
}
