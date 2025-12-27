import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../models/models.dart';

class QuoteSubmissionView extends StatefulWidget {
  final Shipment shipment;

  const QuoteSubmissionView({super.key, required this.shipment});

  @override
  State<QuoteSubmissionView> createState() => _QuoteSubmissionViewState();
}

class _QuoteSubmissionViewState extends State<QuoteSubmissionView> {
  final _formKey = GlobalKey<FormState>();
  final _freightController = TextEditingController();
  final _transitDaysController = TextEditingController();
  final _remarksController = TextEditingController();

  @override
  void dispose() {
    _freightController.dispose();
    _transitDaysController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Submit Quote'),
        backgroundColor: AppConstants.forwarderOrange,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildShipmentInfo(),
              const SizedBox(height: 24),
              const Text(
                'Quote Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _freightController,
                decoration: const InputDecoration(
                  labelText: 'Freight Amount (USD) *',
                  prefixIcon: Icon(Icons.attach_money),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter freight amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _transitDaysController,
                decoration: const InputDecoration(
                  labelText: 'Transit Time (Days) *',
                  prefixIcon: Icon(Icons.schedule),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter transit time';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _remarksController,
                decoration: const InputDecoration(
                  labelText: 'Remarks',
                  prefixIcon: Icon(Icons.note),
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _submitQuote,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.forwarderOrange,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text(
                    'Submit Quote',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShipmentInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppConstants.forwarderBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppConstants.forwarderOrange.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Shipment: ${widget.shipment.shipmentNumber}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${widget.shipment.originPort} → ${widget.shipment.destinationPort}',
            style: TextStyle(color: Colors.grey[700]),
          ),
          if (widget.shipment.grossWeightKg != null || widget.shipment.volumeCbm != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                if (widget.shipment.grossWeightKg != null)
                  Text(
                    'Weight: ${widget.shipment.grossWeightKg!.toStringAsFixed(1)} kg',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                if (widget.shipment.grossWeightKg != null && widget.shipment.volumeCbm != null)
                  const Text(' • ', style: TextStyle(color: Colors.grey)),
                if (widget.shipment.volumeCbm != null)
                  Text(
                    'Volume: ${widget.shipment.volumeCbm!.toStringAsFixed(1)} CBM',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  void _submitQuote() {
    if (_formKey.currentState!.validate()) {
      // TODO: Submit quote to API
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Quote submitted successfully!'),
          backgroundColor: AppConstants.successColor,
        ),
      );
      Navigator.pop(context);
    }
  }
}

