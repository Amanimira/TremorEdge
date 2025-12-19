import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tremor_ring_app/utils/colors.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _timeRange = 'Today';
  String _selectedReportType = 'weekly';
  bool _isGenerating = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Tab Bar
        Container(
          color: AppColors.surface,
          child: TabBar(
            controller: _tabController,
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            tabs: const [
              Tab(text: 'Statistics', icon: Icon(Icons.bar_chart)),
              Tab(text: 'Reports', icon: Icon(Icons.description)),
            ],
          ),
        ),
        
        // Tab Views
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildStatisticsTab(),
              _buildReportsTab(),
            ],
          ),
        ),
      ],
    );
  }

  // ==================== Statistics Tab ====================
  Widget _buildStatisticsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Time Range Selector
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Time Period',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              DropdownButton<String>(
                value: _timeRange,
                items: ['Today', 'This Week', 'This Month']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _timeRange = value);
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Statistics Cards
          Text(
            '📈 Tremor Statistics',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          _buildStatCard(
            context,
            'Average Frequency',
            '5.2 Hz',
            'Past 24 hours',
            Icons.show_chart,
            AppColors.primary,
          ),
          _buildStatCard(
            context,
            'Peak Level',
            '7.1 Hz',
            'at 2:30 PM',
            Icons.trending_up,
            AppColors.error,
          ),
          _buildStatCard(
            context,
            'Stable Hours',
            '18 hours',
            '75% of the day',
            Icons.access_time,
            AppColors.success,
          ),
          _buildStatCard(
            context,
            'High Risk Events',
            '3',
            'Tremor > 7 Hz',
            Icons.warning,
            AppColors.warning,
          ),
          
          const SizedBox(height: 24),
          
          // Additional Stats
          Text(
            '📊 Detailed Breakdown',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          _buildDetailedStats(),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withValues(alpha: 0.1),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            
            // Value
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailedStats() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildStatRow('Resting Tremor (PD)', '12 events', '15%'),
            const Divider(),
            _buildStatRow('Postural Tremor (ET)', '28 events', '35%'),
            const Divider(),
            _buildStatRow('Kinetic Tremor', '8 events', '10%'),
            const Divider(),
            _buildStatRow('Normal State', '32 hours', '40%'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value, String percentage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(label)),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              percentage,
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== Reports Tab ====================
  Widget _buildReportsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Report Type Selection
          Text(
            'Report Type',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'daily', label: Text('Daily')),
              ButtonSegment(value: 'weekly', label: Text('Weekly')),
              ButtonSegment(value: 'monthly', label: Text('Monthly')),
            ],
            selected: {_selectedReportType},
            onSelectionChanged: (Set<String> newSelection) {
              setState(() => _selectedReportType = newSelection.first);
            },
          ),
          const SizedBox(height: 24),

          // Report Information
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.info_outline, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Text(
                        'Report Details',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildReportInfo('Period', _getReportPeriod()),
                  _buildReportInfo('Format', 'PDF & CSV'),
                  _buildReportInfo(
                    'Generated',
                    DateFormat('MMM dd, yyyy').format(DateTime.now()),
                  ),
                  _buildReportInfo('Include', 'All tremor readings & stats'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Export Buttons
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _isGenerating ? null : _generateReport,
              icon: _isGenerating
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.picture_as_pdf),
              label: Text(_isGenerating ? 'Generating...' : 'Generate PDF Report'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _isGenerating ? null : _exportCSV,
              icon: const Icon(Icons.table_chart),
              label: const Text('Export as CSV'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Recent Reports
          Text(
            'Recent Reports',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          _buildRecentReportsList(),
        ],
      ),
    );
  }

  Widget _buildReportInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: AppColors.textSecondary),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentReportsList() {
    // Placeholder for recent reports
    final reports = [
      {'date': 'Dec 15, 2025', 'type': 'Weekly', 'size': '2.3 MB'},
      {'date': 'Dec 08, 2025', 'type': 'Weekly', 'size': '2.1 MB'},
      {'date': 'Dec 01, 2025', 'type': 'Monthly', 'size': '8.7 MB'},
    ];

    return Column(
      children: reports.map((report) {
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.1),
              ),
              child: const Icon(Icons.description, color: AppColors.primary),
            ),
            title: Text('${report['type']} Report'),
            subtitle: Text(report['date']!),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  report['size']!,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const Icon(Icons.download, size: 20, color: AppColors.primary),
              ],
            ),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Opening report...')),
              );
            },
          ),
        );
      }).toList(),
    );
  }

  String _getReportPeriod() {
    final now = DateTime.now();
    switch (_selectedReportType) {
      case 'daily':
        return DateFormat('MMM dd, yyyy').format(now);
      case 'weekly':
        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        return '${DateFormat('MMM dd').format(startOfWeek)} - ${DateFormat('MMM dd, yyyy').format(now)}';
      case 'monthly':
        return DateFormat('MMMM yyyy').format(now);
      default:
        return 'Unknown';
    }
  }

  Future<void> _generateReport() async {
    setState(() => _isGenerating = true);
    
    // Simulate report generation
    await Future.delayed(const Duration(seconds: 2));
    
    setState(() => _isGenerating = false);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('✅ PDF report generated successfully'),
          backgroundColor: AppColors.success,
          action: SnackBarAction(
            label: 'Open',
            textColor: Colors.white,
            onPressed: () {},
          ),
        ),
      );
    }
  }

  Future<void> _exportCSV() async {
    setState(() => _isGenerating = true);
    
    // Simulate CSV export
    await Future.delayed(const Duration(seconds: 1));
    
    setState(() => _isGenerating = false);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ CSV file exported successfully'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }
}
