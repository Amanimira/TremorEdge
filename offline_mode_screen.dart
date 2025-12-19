import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tremor_ring_app/services/ble_service.dart';
import 'package:tremor_ring_app/utils/colors.dart';
import 'package:tremor_ring_app/services/accessibility_service.dart';

/// Offline Mode Screen
/// Displays when the app is working without internet connection
/// Shows cached data and allows limited functionality
class OfflineModeScreen extends StatefulWidget {
  const OfflineModeScreen({super.key});

  @override
  State<OfflineModeScreen> createState() => _OfflineModeScreenState();
}

class _OfflineModeScreenState extends State<OfflineModeScreen> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Consumer<BLEService>(
        builder: (context, bleService, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Offline warning banner
                _buildOfflineWarning(),
                const SizedBox(height: 24),

                // Cached data info
                _buildCachedDataInfo(),
                const SizedBox(height: 24),

                // Last synced info
                _buildLastSyncedInfo(),
                const SizedBox(height: 24),

                // Available features in offline mode
                _buildAvailableFeatures(),
                const SizedBox(height: 24),

                // Unavailable features
                _buildUnavailableFeatures(),
                const SizedBox(height: 24),

                // Action buttons
                _buildActionButtons(context, bleService),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  /// ==================== AppBar ====================
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('Offline Mode'),
      elevation: 0,
      backgroundColor: AppColors.surface,
    );
  }

  /// ==================== Offline Warning ====================
  Widget _buildOfflineWarning() {
    return Semantics(
      label: 'Offline mode warning',
      child: Card(
        color: AppColors.warning.withValues(alpha: 0.15),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.warning,
                ),
                child: const Icon(
                  Icons.cloud_off,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'You are in Offline Mode',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppColors.warning,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Some features are limited. '
                      'Data will sync when connection is restored.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ==================== Cached Data Info ====================
  Widget _buildCachedDataInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cached Data',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        Semantics(
          label: 'Cached data summary',
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildCacheItem(
                    icon: Icons.trending_up,
                    label: 'Tremor Readings',
                    value: '234 readings',
                    color: AppColors.accent,
                  ),
                  const Divider(height: 16),
                  _buildCacheItem(
                    icon: Icons.favorite,
                    label: 'Heart Rate Data',
                    value: '1,024 samples',
                    color: AppColors.error,
                  ),
                  const Divider(height: 16),
                  _buildCacheItem(
                    icon: Icons.history,
                    label: 'Incident History',
                    value: '12 incidents',
                    color: AppColors.warning,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// ==================== Cache Item ====================
  Widget _buildCacheItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// ==================== Last Synced Info ====================
  Widget _buildLastSyncedInfo() {
    final lastSync = DateTime.now().subtract(const Duration(hours: 2));
    final formattedTime =
        '${lastSync.hour}:${lastSync.minute.toString().padLeft(2, '0')}';

    return Semantics(
      label: 'Last synchronization time',
      child: Card(
        color: AppColors.surface,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                Icons.schedule,
                color: AppColors.textSecondary,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Last Synced',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      'Today at $formattedTime',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ==================== Available Features ====================
  Widget _buildAvailableFeatures() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Available in Offline',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        ...[
          'View cached tremor data',
          'View health history',
          'View incident log',
          'Emergency SOS (will log locally)',
          'View medication reminders',
        ].map(
          (feature) => Semantics(
            label: feature,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.success,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      feature,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// ==================== Unavailable Features ====================
  Widget _buildUnavailableFeatures() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Unavailable in Offline',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        ...[
          'Real-time Bluetooth connection',
          'Upload data to cloud',
          'Receive cloud notifications',
          'Contact doctor',
        ].map(
          (feature) => Semantics(
            label: feature,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.error,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      feature,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// ==================== Action Buttons ====================
  Widget _buildActionButtons(BuildContext context, BLEService bleService) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Try to reconnect button
        SizedBox(
          height: 56,
          child: ElevatedButton.icon(
            onPressed: () {
              AccessibilityService.mediumTap();
              bleService.startScan();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Trying to reconnect...'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            icon: const Icon(Icons.refresh),
            label: const Text(
              'Try to Reconnect',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // View cached data button
        SizedBox(
          height: 56,
          child: OutlinedButton.icon(
            onPressed: () {
              AccessibilityService.mediumTap();
              Navigator.of(context).pushNamed('/history');
            },
            icon: const Icon(Icons.history),
            label: const Text(
              'View Cached Data',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }
}
