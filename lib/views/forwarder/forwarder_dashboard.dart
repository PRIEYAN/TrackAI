import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../providers/auth_provider.dart';
import '../../providers/shipment_provider.dart';
import '../../models/models.dart';
import '../../services/api_service.dart';
import '../../views/auth/login_screen.dart';
import 'quote_submission_view.dart';

class ForwarderDashboard extends StatefulWidget {
  const ForwarderDashboard({super.key});

  @override
  State<ForwarderDashboard> createState() => _ForwarderDashboardState();
}

class _ForwarderDashboardState extends State<ForwarderDashboard> {
  final ApiService _apiService = ApiService();
  int _assignedJobs = 0;
  int _pendingLEO = 0;
  double _revenue = 0.0;
  List<Shipment> _pendingShipments = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() => _isLoading = true);
    try {
      // Fetch shipments for forwarder from dedicated endpoint
      final shipments = await _apiService.getForwarderShipments();
      setState(() {
        _pendingShipments = shipments;
        _assignedJobs = shipments.length;
        _pendingLEO = shipments.where((s) => s.status == 'draft' || s.status == 'pending_quote').length;
        // Calculate revenue (mock data - replace with actual API call)
        _revenue = shipments.length * 85000.0; // Example calculation
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text('Shipments refreshed successfully'),
              ],
            ),
            backgroundColor: AppConstants.successColor,
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading shipments: $e'),
            backgroundColor: AppConstants.errorColor,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    final userName = user?.name ?? 'Team';

    return Scaffold(
      backgroundColor: Colors.white,
      drawer: _buildDrawer(),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadDashboardData,
          color: AppConstants.forwarderOrange,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTopBar(context),
                _buildUserSection(userName),
                _buildSummaryCards(),
                _buildRecentRequestsSection(),
                _buildShipmentCards(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: AppConstants.forwarderOrange,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.local_shipping, size: 48, color: Colors.white),
                const SizedBox(height: 16),
                const Text(
                  'LogiTrack India',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard, color: AppConstants.forwarderOrange),
            title: const Text('Dashboard'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.assignment, color: AppConstants.forwarderOrange),
            title: const Text('Accepted Requets'),
            onTap: () {
              Navigator.pop(context);
              // Navigate to quotes page
            },
          ),
          ListTile(
            leading: const Icon(Icons.history, color: AppConstants.forwarderOrange),
            title: const Text('History'),
            onTap: () {
              Navigator.pop(context);
              // Navigate to history page
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: AppConstants.errorColor),
            title: const Text('Logout'),
            onTap: () async {
              Navigator.pop(context);
              final authProvider = context.read<AuthProvider>();
              await authProvider.logout();
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: Colors.black87),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          const SizedBox(width: 8),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppConstants.forwarderOrange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.local_shipping,
                  color: AppConstants.forwarderOrange,
                  size: 24,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'LogiTrack - Forwarder',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            icon: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(AppConstants.forwarderOrange),
                    ),
                  )
                : const Icon(Icons.refresh, color: Colors.black87),
            onPressed: _isLoading ? null : _loadDashboardData,
            tooltip: 'Refresh',
          ),
          Container(
            width: 36,
            height: 36,
            margin: const EdgeInsets.only(left: 4),
            decoration: BoxDecoration(
              color: AppConstants.forwarderOrange.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                'हि',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.forwarderOrange,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserSection(String userName) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final user = authProvider.user;
        final companyName = user?.companyName ?? '';
        
        return Container(
          padding: const EdgeInsets.all(20),
          color: AppConstants.forwarderBackground,
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppConstants.forwarderOrange,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hi, $userName!',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    if (companyName.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        companyName,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSummaryCards() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: TweenAnimationBuilder<int>(
              tween: IntTween(begin: 0, end: _assignedJobs),
              duration: const Duration(milliseconds: 1000),
              builder: (context, value, child) {
                return _buildSummaryCard('Assigned Jobs', '$value', Icons.assignment);
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TweenAnimationBuilder<int>(
              tween: IntTween(begin: 0, end: _pendingLEO),
              duration: const Duration(milliseconds: 1200),
              builder: (context, value, child) {
                return _buildSummaryCard('Pending LEO', '$value', Icons.pending_actions);
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: _revenue),
              duration: const Duration(milliseconds: 1500),
              builder: (context, value, child) {
                return _buildSummaryCard('Revenue (Nov)', '₹${(value / 1000).toStringAsFixed(1)}L', Icons.currency_rupee);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(icon, color: AppConstants.forwarderOrange, size: 20),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.forwarderOrange,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentRequestsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Recent Requests',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          TextButton(
            onPressed: () {
              // Show all requests
            },
            child: const Text(
              'View All',
              style: TextStyle(color: AppConstants.forwarderOrange),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShipmentCards() {
    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.all(40.0),
        child: Center(child: CircularProgressIndicator(color: AppConstants.forwarderOrange)),
      );
    }

    if (_pendingShipments.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(40.0),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.inbox_outlined, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                'No pending requests',
                style: TextStyle(color: Colors.grey[600], fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: _pendingShipments.map((shipment) => _buildShipmentCard(shipment)).toList(),
      ),
    );
  }

  Widget _buildShipmentCard(Shipment shipment) {
    final statusText = _getStatusText(shipment);
    final bidsCount = _getBidsCount(shipment);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppConstants.forwarderOrange.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppConstants.forwarderOrange.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => QuoteSubmissionView(shipment: shipment),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Shipment ID',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            shipment.shipmentNumber,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppConstants.forwarderOrange,
                            AppConstants.forwarderOrangeDark,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppConstants.forwarderOrange.withOpacity(0.3),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        statusText,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                
                // Route Information
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppConstants.forwarderBackground,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppConstants.forwarderOrange.withOpacity(0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppConstants.forwarderOrange,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.alt_route,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              shipment.originPort.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 2,
                                  color: AppConstants.forwarderOrange,
                                ),
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.arrow_forward,
                                  size: 16,
                                  color: AppConstants.forwarderOrange,
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  width: 40,
                                  height: 2,
                                  color: AppConstants.forwarderOrange,
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              shipment.destinationPort.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                
                // Cargo Details Grid
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      if (shipment.cargoType != null)
                        Expanded(
                          child: _buildDetailItem(
                            Icons.inventory_2,
                            'Type',
                            shipment.cargoType!,
                          ),
                        ),
                      if (shipment.cargoType != null && shipment.grossWeightKg != null)
                        Container(
                          width: 1,
                          height: 40,
                          color: Colors.grey[300],
                          margin: const EdgeInsets.symmetric(horizontal: 12),
                        ),
                      if (shipment.grossWeightKg != null)
                        Expanded(
                          child: _buildDetailItem(
                            Icons.scale,
                            'Weight',
                            '${shipment.grossWeightKg!.toStringAsFixed(1)} kg',
                          ),
                        ),
                      if (shipment.grossWeightKg != null && shipment.volumeCbm != null)
                        Container(
                          width: 1,
                          height: 40,
                          color: Colors.grey[300],
                          margin: const EdgeInsets.symmetric(horizontal: 12),
                        ),
                      if (shipment.volumeCbm != null)
                        Expanded(
                          child: _buildDetailItem(
                            Icons.inventory_2,
                            'Volume',
                            '${shipment.volumeCbm!.toStringAsFixed(1)} CBM',
                          ),
                        ),
                    ],
                  ),
                ),
                
                // Additional Info
                if (shipment.containerType != null || shipment.containerQty != null) ...[
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      if (shipment.containerType != null)
                        _buildInfoChip(
                          Icons.square_foot,
                          'Container: ${shipment.containerType}',
                        ),
                      if (shipment.containerQty != null)
                        _buildInfoChip(
                          Icons.numbers,
                          'Qty: ${shipment.containerQty}',
                        ),
                      if (shipment.createdAt != null)
                        _buildInfoChip(
                          Icons.calendar_today,
                          'Created: ${_formatDate(shipment.createdAt)}',
                        ),
                    ],
                  ),
                ],
                
                const SizedBox(height: 16),
                
                // Action Button
                Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppConstants.forwarderOrange,
                        AppConstants.forwarderOrangeDark,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppConstants.forwarderOrange.withOpacity(0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuoteSubmissionView(shipment: shipment),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.edit_note, color: Colors.white, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Tap to Quote',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, size: 20, color: AppConstants.forwarderOrange),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppConstants.forwarderOrange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppConstants.forwarderOrange.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppConstants.forwarderOrange),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _getStatusText(Shipment shipment) {
    if (shipment.status == 'pending_quote') {
      return 'Awaiting Quote';
    } else if (shipment.status == 'quoted') {
      return 'Quoted';
    }
    return 'New Request';
  }

  int _getBidsCount(Shipment shipment) {
    // This would come from API - for now return mock data
    return shipment.status == 'quoted' ? 3 : 0;
  }
}
