import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants.dart';
import '../../services/api_service.dart';
import 'dart:io' show Platform;

class InvoiceViewerDialog extends StatefulWidget {
  final String shipmentId;

  const InvoiceViewerDialog({
    super.key,
    required this.shipmentId,
  });

  @override
  State<InvoiceViewerDialog> createState() => _InvoiceViewerDialogState();
}

class _InvoiceViewerDialogState extends State<InvoiceViewerDialog> {
  final ApiService _apiService = ApiService();
  bool _isLoading = true;
  Map<String, dynamic>? _invoiceData;
  Uint8List? _invoiceImageBytes;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadInvoice();
  }

  Future<void> _loadInvoice() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final invoiceResponse = await _apiService.getShipmentInvoice(widget.shipmentId);
      
      final base64Image = invoiceResponse['invoice_image_base64'] as String?;
      
      if (base64Image != null && base64Image.isNotEmpty) {
        try {
          _invoiceImageBytes = base64Decode(base64Image);
        } catch (e) {
          print('Error decoding base64 image: $e');
        }
      }

      final extractedData = invoiceResponse['extracted_data'] as Map<String, dynamic>?;
      final invoiceDetails = invoiceResponse['invoice_details'] as Map<String, dynamic>?;
      final document = invoiceResponse['document'] as Map<String, dynamic>?;
      
      setState(() {
        _invoiceData = {
          'document': document,
          'extracted_data': extractedData,
          'invoice_details': invoiceDetails ?? extractedData,
          'file_url': invoiceResponse['file_url'],
          'confidence_score': invoiceResponse['confidence_score'],
        };
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load invoice: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.95,
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _errorMessage != null
                      ? _buildErrorView()
                      : _buildInvoiceContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppConstants.forwarderOrange,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.receipt_long, color: Colors.white, size: 28),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Invoice Details',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              _errorMessage ?? 'Unknown error',
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInvoiceContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_invoiceImageBytes != null) ...[
            _buildInvoiceImage(),
            const SizedBox(height: 24),
          ],
          if (_invoiceData != null) ...[
            _buildExtractedData(),
          ],
        ],
      ),
    );
  }

  Widget _buildInvoiceImage() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.memory(
          _invoiceImageBytes!,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildExtractedData() {
    final extracted = _invoiceData!['extracted_data'] as Map<String, dynamic>?;
    final invoiceDetails = _invoiceData!['invoice_details'] as Map<String, dynamic>?;

    if (extracted == null && invoiceDetails == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Extracted Information',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppConstants.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                if (invoiceDetails?['unique_invoice_number'] != null)
                  _buildDetailRow('Invoice Number', invoiceDetails!['unique_invoice_number']),
                if (invoiceDetails?['date_of_invoice'] != null)
                  _buildDetailRow('Invoice Date', invoiceDetails!['date_of_invoice']),
                if (invoiceDetails?['seller_company_name'] != null)
                  _buildDetailRow('Seller', invoiceDetails!['seller_company_name']),
                if (invoiceDetails?['buyer_company_name'] != null)
                  _buildDetailRow('Buyer', invoiceDetails!['buyer_company_name']),
                if (invoiceDetails?['po_number'] != null)
                  _buildDetailRow('PO Number', invoiceDetails!['po_number']),
                if (invoiceDetails?['total_amount'] != null)
                  _buildDetailRow('Total Amount', '${invoiceDetails!['currency'] ?? ''} ${invoiceDetails['total_amount']}'),
                if (invoiceDetails?['tax_amount'] != null)
                  _buildDetailRow('Tax Amount', '${invoiceDetails!['currency'] ?? ''} ${invoiceDetails['tax_amount']}'),
                if (invoiceDetails?['payment_terms'] != null)
                  _buildDetailRow('Payment Terms', invoiceDetails!['payment_terms']),
                if (invoiceDetails?['due_date'] != null)
                  _buildDetailRow('Due Date', invoiceDetails!['due_date']),
              ],
            ),
          ),
        ),
        if (invoiceDetails?['items'] != null && (invoiceDetails!['items'] as List).isNotEmpty) ...[
          const SizedBox(height: 16),
          const Text(
            'Items',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppConstants.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          ...(invoiceDetails['items'] as List).map((item) => Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              title: Text(item['description'] ?? 'N/A'),
              subtitle: Text('Qty: ${item['quantity'] ?? 'N/A'} × ${item['unit_price'] ?? 'N/A'}'),
              trailing: Text('${item['total'] ?? 'N/A'}'),
            ),
          )),
        ],
      ],
    );
  }

  Widget _buildDetailRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value?.toString() ?? 'N/A',
              style: const TextStyle(
                fontSize: 14,
                color: AppConstants.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

