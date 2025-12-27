import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/models.dart';
import '../../services/api_service.dart';
import '../../core/constants.dart';
import '../../providers/shipment_provider.dart';
import 'payment_gateway_popup.dart';

class QuoteComparisonView extends StatefulWidget {
  final String shipmentId;

  const QuoteComparisonView({super.key, required this.shipmentId});

  @override
  State<QuoteComparisonView> createState() => _QuoteComparisonViewState();
}

class _QuoteComparisonViewState extends State<QuoteComparisonView> {
  final _apiService = ApiService();
  List<Quote>? _quotes;
  Shipment? _shipment;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final quotes = await _apiService.getQuotes(widget.shipmentId);
      // Fetch shipment details for payment popup
      final shipments = await _apiService.getShipments();
      final shipment = shipments.firstWhere(
        (s) => s.id == widget.shipmentId,
        orElse: () => shipments.isNotEmpty ? shipments.first : throw Exception('Shipment not found'),
      );
      setState(() {
        _quotes = quotes;
        _shipment = shipment;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error loading quotes: $e')));
    }
  }

  Future<void> _handleAccept(String quoteId) async {
    try {
      await context.read<ShipmentProvider>().acceptQuote(quoteId, widget.shipmentId);
      if (mounted) {
        Navigator.pop(context); // Close comparison view after successful payment
      }
    } catch (e) {
      rethrow; // Re-throw to handle in payment popup
    }
  }

  void _showPaymentGateway(Quote quote) {
    if (_shipment == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Shipment details not available')),
      );
      return;
    }

    // Update shipment with quote amount for display
    final shipmentForPayment = Shipment(
      id: _shipment!.id,
      shipmentNumber: _shipment!.shipmentNumber,
      status: _shipment!.status,
      originPort: _shipment!.originPort,
      destinationPort: _shipment!.destinationPort,
      preferredEtd: _shipment!.preferredEtd,
      preferredEta: _shipment!.preferredEta,
      actualEtd: _shipment!.actualEtd,
      actualEta: _shipment!.actualEta,
      cargoType: _shipment!.cargoType,
      containerType: _shipment!.containerType,
      containerQty: _shipment!.containerQty,
      grossWeightKg: _shipment!.grossWeightKg,
      netWeightKg: _shipment!.netWeightKg,
      volumeCbm: _shipment!.volumeCbm,
      totalPackages: _shipment!.totalPackages,
      packageType: _shipment!.packageType,
      createdAt: _shipment!.createdAt,
      updatedAt: _shipment!.updatedAt,
      quoteAmount: quote.totalAmount,
      quoteExtra: _shipment!.quoteExtra,
      quoteForwarderId: _shipment!.quoteForwarderId,
      quoteStatus: _shipment!.quoteStatus,
      quoteTime: _shipment!.quoteTime,
      supplierDetails: _shipment!.supplierDetails,
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PaymentGatewayPopup(
        shipment: shipmentForPayment,
        onPay: () => _handleAccept(quote.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Compare Quotes'),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : _quotes == null || _quotes!.isEmpty
          ? const Center(child: Text('No quotes available for this shipment yet.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _quotes!.length,
              itemBuilder: (context, index) {
                final quote = _quotes![index];
                return QuoteCard(
                  quote: quote,
                  onAccept: () => _showPaymentGateway(quote),
                );
              },
            ),
    );
  }
}

class QuoteCard extends StatelessWidget {
  final Quote quote;
  final VoidCallback onAccept;

  const QuoteCard({super.key, required this.quote, required this.onAccept});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey.withOpacity(0.2))),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppConstants.primaryColor.withOpacity(0.05),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(quote.forwarderName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                Text('${quote.currency} ${quote.totalAmount.toStringAsFixed(2)}', 
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppConstants.successColor)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildDetailRow(Icons.timer_outlined, 'Transit Time', '${quote.transitTimeDays} days'),
                const Divider(height: 24),
                ...quote.priceBreakdown.entries.map((e) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(e.key, style: const TextStyle(color: Colors.grey)),
                      Text('${quote.currency} ${e.value.toStringAsFixed(2)}'),
                    ],
                  ),
                )),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: onAccept,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstants.successColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Accept Quote', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(color: Colors.grey)),
        const Spacer(),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}


