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
    // If status is null, fetch all shipments; otherwise filter by status
    final uri = status != null
        ? Uri.parse('$baseUrl/shipments/list?status=$status')
        : Uri.parse('$baseUrl/shipments/list');
    final response = await http.get(uri, headers: headers);
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

  Future<void> submitForwarderQuote(String shipmentId, Map<String, dynamic> quoteData) async {
    final requestBody = json.encode(quoteData);
    final headers = await _getHeaders();
    
    final uri = Uri.parse('$baseUrl/forwarder/request-accept/$shipmentId');
    final httpRequest = http.Request('PUT', uri);
    httpRequest.headers.addAll(headers);
    httpRequest.headers['Accept'] = 'application/json';
    httpRequest.body = requestBody;
    
    final streamedResponse = await httpRequest.send();
    final response = await http.Response.fromStream(streamedResponse);
    
    if (response.statusCode != 200 && response.statusCode != 201) {
      final errorBody = response.body.isNotEmpty 
          ? json.decode(response.body) 
          : <String, dynamic>{};
      final errorMessage = errorBody['detail'] ?? 
                          errorBody['message'] ?? 
                          'Failed to submit quote';
      throw Exception(errorMessage);
    }
  }

  Future<List<Shipment>> getBookings() async {
    final headers = await _getHeaders();
    
    final uri = Uri.parse('$baseUrl/carriers/AllQuotes');
    final httpRequest = http.Request('POST', uri);
    httpRequest.headers.addAll(headers);
    httpRequest.headers['Accept'] = 'application/json';
    httpRequest.body = json.encode({}); // Empty JSON body
    
    final streamedResponse = await httpRequest.send();
    final response = await http.Response.fromStream(streamedResponse);
    
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

  Future<void> acceptQuote(String quoteId) async {
    final headers = await _getHeaders();
    
    final uri = Uri.parse('$baseUrl/carriers/acceptQuote');
    final httpRequest = http.Request('POST', uri);
    httpRequest.headers.addAll(headers);
    httpRequest.headers['Accept'] = 'application/json';
    httpRequest.body = json.encode({'quote_id': quoteId});
    
    final streamedResponse = await httpRequest.send();
    final response = await http.Response.fromStream(streamedResponse);
    
    if (response.statusCode != 200 && response.statusCode != 201) {
      final errorBody = response.body.isNotEmpty 
          ? json.decode(response.body) 
          : <String, dynamic>{};
      final errorMessage = errorBody['detail'] ?? 
                          errorBody['message'] ?? 
                          'Failed to accept quote';
      throw Exception(errorMessage);
    }
  }

  Future<List<Shipment>> getAcceptedQuotes() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/forwarder/accepted-quotes'),
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
      final errorBody = response.body.isNotEmpty 
          ? json.decode(response.body) 
          : <String, dynamic>{};
      final errorMessage = errorBody['reason'] ?? 
                          errorBody['detail'] ?? 
                          errorBody['message'] ?? 
                          'Failed to load accepted quotes';
      throw Exception(errorMessage);
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
