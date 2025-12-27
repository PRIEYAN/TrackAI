import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants.dart';
import '../core/auth_storage.dart';
import '../models/models.dart';

class ApiService {
  final String baseUrl = AppConstants.baseUrl;

  Future<Map<String, String>> _getHeaders() async {
    final token = await AuthStorage.getToken();
    final headers = {'Content-Type': 'application/json'};
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  Future<List<Shipment>> getShipments({String? status}) async {
    final headers = await _getHeaders();
    // Always use status parameter, default to 'draft' if not provided
    final statusParam = status ?? 'draft';
    final response = await http.get(
      Uri.parse('$baseUrl/shipments/list?status=$statusParam'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      // Handle both wrapped {"data": [...]} and direct array responses
      List data = responseData is Map && responseData.containsKey('data') 
          ? responseData['data'] 
          : responseData is List 
              ? responseData 
              : [];
      return data.map((item) => Shipment.fromJson(item)).toList();
    } else {
      return [];
    }
  }

  Future<Shipment> createShipment(Map<String, dynamic> data) async {
    final requestBody = json.encode(data);
    final headers = await _getHeaders();
    
    final uri = Uri.parse('$baseUrl/shipments/create');
    final httpRequest = http.Request('POST', uri);
    httpRequest.headers.addAll(headers);
    httpRequest.headers['Accept'] = 'application/json';
    httpRequest.body = requestBody;
    
    final streamedResponse = await httpRequest.send();
    final response = await http.Response.fromStream(streamedResponse);
    
    if (response.statusCode == 201 || response.statusCode == 200) {
      return Shipment.fromJson(json.decode(response.body));
    } else {
      final errorBody = response.body.isNotEmpty 
          ? json.decode(response.body) 
          : <String, dynamic>{};
      final errorMessage = errorBody['detail'] ?? 
                          errorBody['message'] ?? 
                          'Failed to create shipment';
      throw Exception(errorMessage);
    }
  }

  Future<List<Quote>> getQuotes(String shipmentId) async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/shipments/$shipmentId/quotes'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((item) => Quote.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load quotes');
    }
  }

  Future<void> acceptQuote(String quoteId) async {
    final headers = await _getHeaders();
    
    final uri = Uri.parse('$baseUrl/quotes/$quoteId/accept');
    final httpRequest = http.Request('POST', uri);
    httpRequest.headers.addAll(headers);
    httpRequest.headers['Accept'] = 'application/json';
    
    final streamedResponse = await httpRequest.send();
    final response = await http.Response.fromStream(streamedResponse);
    
    if (response.statusCode != 200) {
      final errorBody = response.body.isNotEmpty 
          ? json.decode(response.body) 
          : <String, dynamic>{};
      final errorMessage = errorBody['detail'] ?? 
                          errorBody['message'] ?? 
                          'Failed to accept quote';
      throw Exception(errorMessage);
    }
  }

  Future<List<Shipment>> getForwarderShipments() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/forwarder/show-shipments'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      // Handle wrapped {"data": [...]} response
      List data = responseData is Map && responseData.containsKey('data') 
          ? responseData['data'] 
          : responseData is List 
              ? responseData 
              : [];
      return data.map((item) => Shipment.fromJson(item)).toList();
    } else {
      return [];
    }
  }

  Future<Map<String, dynamic>> uploadDocument(String filePath) async {
    final token = await AuthStorage.getToken();
    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/documents/upload'));
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }
    request.files.add(await http.MultipartFile.fromPath('file', filePath));
    
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Document upload failed');
    }
  }
}
