import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/api_service.dart';

class ShipmentProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<Shipment> _shipments = [];
  List<Shipment> _allShipments = []; // For statistics
  bool _isLoading = false;
  String? _error;

  List<Shipment> get shipments => _shipments;
  List<Shipment> get allShipments => _allShipments;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Get statistics
  int get totalPosted => _allShipments.length;
  int get totalQuoted => _allShipments.where((s) => s.status.toLowerCase() == 'quoted' || s.status.toLowerCase() == 'pending_quote').length;

  Future<void> fetchShipments({String? status}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Default to 'draft' status if not provided
      final shipments = await _apiService.getShipments(status: status ?? 'draft');
      _shipments = shipments;
      _error = null;
    } catch (e) {
      _error = e.toString();
      _shipments = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchAllShipments() async {
    try {
      final shipments = await _apiService.getShipments(status: null);
      _allShipments = shipments;
      notifyListeners();
    } catch (e) {
      _allShipments = [];
    }
  }

  Future<Shipment> createShipment(Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();

    try {
      final newShipment = await _apiService.createShipment(data);
      _shipments.insert(0, newShipment);
      return newShipment;
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> acceptQuote(String quoteId, String shipmentId) async {
    try {
      await _apiService.acceptQuote(quoteId);
      // Refresh shipments to update status
      await fetchShipments(status: 'draft');
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}


