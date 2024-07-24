import 'package:dio/dio.dart';

import '../models/asset.dart';
import '../models/company.dart';
import '../models/location.dart';

class ApiService {
  Dio dio;

  ApiService({required this.dio});

  Future<List<Company>> getCompanies() async {
    const path = '/companies';
    final response = await dio.get(path);
    if (response.statusCode == 200) {
      final data = response.data as List;
      return data.map((json) => Company.fromJson(json)).toList();
    }
    throw Exception({'statusCode': '${response.statusCode}', 'message': 'Failed to load companies'});
  }

  Future<List<Location>> getLocations(String companyId) async {
    final path = '/companies/$companyId/locations';
    final response = await dio.get(path);
    if (response.statusCode == 200) {
      final data = response.data as List;
      return data.map((json) => Location.fromJson(json)).toList();
    }
    throw Exception({'statusCode': '${response.statusCode}', 'message': 'Failed to load locations'});
  }

  Future<List<Asset>> getAssets(String companyId) async {
    final path = '/companies/$companyId/assets';
    final response = await dio.get(path);
    if (response.statusCode == 200) {
      final data = response.data as List;
      return data.map((json) => Asset.fromJson(json)).toList();
    }
    throw Exception({'statusCode': '${response.statusCode}', 'message': 'Failed to load assets'});
  }
}
