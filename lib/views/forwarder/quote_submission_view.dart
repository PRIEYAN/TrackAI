import 'package:flutter/material.dart';
import 'dart:convert';
import '../../core/constants.dart';
import '../../models/models.dart';
import '../../services/api_service.dart';

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
  final _apiService = ApiService();
  bool _isSubmitting = false;

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
      backgroundColor: Colors.grey[100],
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
                decoration: InputDecoration(
                  labelText: 'Freight Amount (USD) *',
                  prefixIcon: const Icon(Icons.attach_money, color: AppConstants.forwarderOrange),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppConstants.forwarderOrange, width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter freight amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _transitDaysController,
                decoration: InputDecoration(
                  labelText: 'Transit Time (Days) *',
                  prefixIcon: const Icon(Icons.schedule, color: AppConstants.forwarderOrange),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppConstants.forwarderOrange, width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter transit time';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _remarksController,
                decoration: InputDecoration(
                  labelText: 'Remarks',
                  prefixIcon: const Icon(Icons.description, color: AppConstants.forwarderOrange),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppConstants.forwarderOrange, width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitQuote,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.forwarderOrange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'Submit Quote',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
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
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppConstants.forwarderBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppConstants.forwarderOrange.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Shipment: ${widget.shipment.shipmentNumber}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '${widget.shipment.originPort} — ${widget.shipment.destinationPort}',
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 14,
            ),
          ),
          if (widget.shipment.grossWeightKg != null || widget.shipment.volumeCbm != null) ...[
            const SizedBox(height: 8),
            Text(
              'Weight: ${widget.shipment.grossWeightKg?.toStringAsFixed(1) ?? 'N/A'} kg • Volume: ${widget.shipment.volumeCbm?.toStringAsFixed(1) ?? 'N/A'} CBM',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 13,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _submitQuote() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final freightAmount = double.parse(_freightController.text);
      final transitDays = int.parse(_transitDaysController.text);
      
      // Calculate quote_time: current date + transit days
      final quoteTime = DateTime.now().add(Duration(days: transitDays)).toUtc();
      
      final quoteData = {
        'quote_amount': freightAmount,
        'quote_time': quoteTime.toIso8601String(),
        'quote_extra': _remarksController.text.isEmpty ? null : _remarksController.text,
      };

      await _apiService.submitForwarderQuote(widget.shipment.id, quoteData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('Quote submitted successfully!'),
              ],
            ),
            backgroundColor: AppConstants.successColor,
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.pop(context, true); // Return true to indicate success
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(
                  child: Text('Failed to submit quote: $e'),
                ),
              ],
            ),
            backgroundColor: AppConstants.errorColor,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }
}

