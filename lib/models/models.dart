class Shipment {
  final String id;
  final String shipmentNumber;
  final String status;
  final String originPort;
  final String destinationPort;
  final DateTime? preferredEtd;
  final DateTime? preferredEta;
  final DateTime? actualEtd;
  final DateTime? actualEta;
  final String? cargoType;
  final String? containerType;
  final int? containerQty;
  final double? grossWeightKg;
  final double? netWeightKg;
  final double? volumeCbm;
  final int? totalPackages;
  final String? packageType;
  final DateTime createdAt;
  final DateTime updatedAt;
  // Quote fields
  final double? quoteAmount;
  final String? quoteExtra;
  final List<String>? quoteForwarderId;
  final String? quoteStatus;
  final DateTime? quoteTime;
  // Supplier details (for forwarder accepted requests)
  final Map<String, dynamic>? supplierDetails;

  Shipment({
    required this.id,
    required this.shipmentNumber,
    required this.status,
    required this.originPort,
    required this.destinationPort,
    this.preferredEtd,
    this.preferredEta,
    this.actualEtd,
    this.actualEta,
    this.cargoType,
    this.containerType,
    this.containerQty,
    this.grossWeightKg,
    this.netWeightKg,
    this.volumeCbm,
    this.totalPackages,
    this.packageType,
    required this.createdAt,
    required this.updatedAt,
    this.quoteAmount,
    this.quoteExtra,
    this.quoteForwarderId,
    this.quoteStatus,
    this.quoteTime,
    this.supplierDetails,
  });

  factory Shipment.fromJson(Map<String, dynamic> json) {
    return Shipment(
      id: json['id']?.toString() ?? '',
      shipmentNumber: json['shipment_number'] ?? '',
      status: json['status'] ?? 'draft',
      originPort: json['origin_port'] ?? '',
      destinationPort: json['destination_port'] ?? '',
      preferredEtd: json['preferred_etd'] != null 
          ? DateTime.parse(json['preferred_etd']) 
          : null,
      preferredEta: json['preferred_eta'] != null 
          ? DateTime.parse(json['preferred_eta']) 
          : null,
      actualEtd: json['actual_etd'] != null 
          ? DateTime.parse(json['actual_etd']) 
          : null,
      actualEta: json['actual_eta'] != null 
          ? DateTime.parse(json['actual_eta']) 
          : null,
      cargoType: json['cargo_type'],
      containerType: json['container_type'],
      containerQty: json['container_qty'],
      grossWeightKg: json['gross_weight_kg']?.toDouble(),
      netWeightKg: json['net_weight_kg']?.toDouble(),
      volumeCbm: json['volume_cbm']?.toDouble(),
      totalPackages: json['total_packages'],
      packageType: json['package_type'],
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : DateTime.now(),
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : DateTime.now(),
      quoteAmount: json['quote_amount']?.toDouble(),
      quoteExtra: json['quote_extra'],
      quoteForwarderId: json['quote_forwarder_id'] != null
          ? (json['quote_forwarder_id'] is List
              ? List<String>.from(json['quote_forwarder_id'].map((x) => x.toString()))
              : [json['quote_forwarder_id'].toString()])
          : null,
      quoteStatus: json['quote_status'],
      quoteTime: json['quote_time'] != null 
          ? DateTime.parse(json['quote_time']) 
          : null,
      supplierDetails: json['supplier_details'] != null
          ? Map<String, dynamic>.from(json['supplier_details'])
          : null,
    );
  }

  // Getters for backward compatibility
  DateTime get etd => preferredEtd ?? actualEtd ?? createdAt;
  DateTime get eta => preferredEta ?? actualEta ?? createdAt.add(const Duration(days: 30));
  double get weight => grossWeightKg ?? 0.0;
  double get volume => volumeCbm ?? 0.0;
}

class Quote {
  final String id;
  final String forwarderName;
  final double totalAmount;
  final String currency;
  final int transitTimeDays;
  final String status;
  final Map<String, double> priceBreakdown;

  Quote({
    required this.id,
    required this.forwarderName,
    required this.totalAmount,
    required this.currency,
    required this.transitTimeDays,
    required this.status,
    required this.priceBreakdown,
  });

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      id: json['id'],
      forwarderName: json['forwarder_name'],
      totalAmount: (json['total_amount'] as num).toDouble(),
      currency: json['currency'] ?? 'USD',
      transitTimeDays: json['transit_time_days'],
      status: json['status'],
      priceBreakdown: Map<String, double>.from(
        (json['price_breakdown'] as Map).map((k, v) => MapEntry(k, (v as num).toDouble())),
      ),
    );
  }
}

class TrackingEvent {
  final String id;
  final String status;
  final String location;
  final String description;
  final DateTime timestamp;

  TrackingEvent({
    required this.id,
    required this.status,
    required this.location,
    required this.description,
    required this.timestamp,
  });

  factory TrackingEvent.fromJson(Map<String, dynamic> json) {
    return TrackingEvent(
      id: json['id'],
      status: json['status'],
      location: json['location'],
      description: json['description'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}


