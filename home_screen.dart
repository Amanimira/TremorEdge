import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tremor_ring_app/services/ble_service.dart';
import 'package:tremor_ring_app/services/accessibility_service.dart';
import 'package:tremor_ring_app/utils/colors.dart';
import 'package:tremor_ring_app/widgets/tremor_ring_widget.dart';
import 'package:tremor_ring_app/widgets/sos_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.85);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: _buildAppBar(),
          body: Consumer<BLEService>(
            builder: (context, bleService, _) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Welcome Header
                    _buildWelcomeHeader(),
                    const SizedBox(height: 20),

                    // 2. Device Status Card
                    _buildDeviceStatusCard(bleService),
                    const SizedBox(height: 24),

                    // 3. Tremor Ring Widget (Main Visualization)
                    _buildTremorRingSection(),
                    const SizedBox(height: 32),

                    // 4. Today's Metrics Grid
                    _buildMetricsSection(),
                    const SizedBox(height: 24),

                    // 5. Health Insight Card
                    _buildHealthInsightCard(),
                    const SizedBox(height: 24),

                    // 6. Quick Actions
                    _buildQuickActionsSection(),
                    const SizedBox(height: 32),
                  ],
                ),
              );
            },
          ),
          floatingActionButton: const SOSButton(),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        ),
      ],
    );
  }

  /// ==================== AppBar ====================
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: AppColors.surface,
      title: const Text(
        'TremorEdge',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: GestureDetector(
            onTap: () {
              AccessibilityService.mediumTap();
              Navigator.of(context).pushNamed('/connection');
            },
            child: Semantics(
              label: 'Device connection settings',
              button: true,
              onTap: () => Navigator.of(context).pushNamed('/connection'),
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.border,
                ),
                child: const Icon(
                  Icons.bluetooth_connected,
                  color: AppColors.textPrimary,
                  size: 28,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// ==================== Welcome Header ====================
  Widget _buildWelcomeHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome back, Ahmed!',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
          semanticsLabel: 'Welcome message',
        ),
        const SizedBox(height: 8),
        Semantics(
          label: 'Your health score',
          child: Text(
            "Today's Health Score: 78/100",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
        ),
      ],
    );
  }

  /// ==================== Device Status Card ====================
  Widget _buildDeviceStatusCard(BLEService bleService) {
    final isConnected = bleService.connectedDevice != null;
    final deviceName = bleService.connectedDevice?.name ?? 'Not Connected';
    final statusColor = isConnected ? AppColors.success : AppColors.warning;

    return Semantics(
      label: AccessibilityService.getDeviceStatusLabel(isConnected, deviceName),
      enabled: true,
      onTap: () {
        AccessibilityService.mediumTap();
        Navigator.of(context).pushNamed('/connection');
      },
      child: GestureDetector(
        onTap: () {
          AccessibilityService.mediumTap();
          Navigator.of(context).pushNamed('/connection');
        },
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Status indicator
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: statusColor,
                    boxShadow: [
                      BoxShadow(
                        color: statusColor.withValues(alpha: 0.5),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),

                // Device info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Device Status',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        deviceName,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),

                // Loading indicator or arrow
                if (bleService.isScanning)
                  const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                    ),
                  )
                else
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// ==================== Tremor Ring Section ====================
  Widget _buildTremorRingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tremor Analysis',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: TremorRingWidget(
              frequency: 5.2,
              amplitude: 0.25,
              confidence: 85,
              riskLevel: 'MODERATE',
            ),
          ),
        ),
      ],
    );
  }

  /// ==================== Metrics Section ====================
  Widget _buildMetricsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Today\'s Metrics',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.9,
          children: [
            _buildMetricCard(
              label: 'Tremor Frequency',
              value: '5.2 Hz',
              icon: Icons.show_chart,
              color: AppColors.warning,
              semanticLabel: 'Tremor frequency 5.2 hertz',
            ),
            _buildMetricCard(
              label: 'Heart Rate',
              value: '72 BPM',
              icon: Icons.monitor_heart,
              color: AppColors.accent,
              semanticLabel: 'Heart rate 72 beats per minute, normal',
            ),
            _buildMetricCard(
              label: 'Confidence',
              value: '85%',
              icon: Icons.check_circle,
              color: AppColors.success,
              semanticLabel: 'Reading confidence 85 percent',
            ),
            _buildMetricCard(
              label: 'Battery',
              value: '85%',
              icon: Icons.battery_full,
              color: AppColors.success,
              semanticLabel: 'Device battery level 85 percent',
            ),
          ],
        ),
      ],
    );
  }

  /// ==================== Health Insight Card ====================
  Widget _buildHealthInsightCard() {
    return Semantics(
      label: 'Health insight information',
      child: Card(
        color: AppColors.surface.withValues(alpha: 0.8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    color: AppColors.warning,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Medical Insight',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Your hand tremor increased by 15% in the past hour. '
                'Consider taking your next dose of medication now. '
                'Rest for 15 minutes to stabilize your condition.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.6,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ==================== Quick Actions ====================
  Widget _buildQuickActionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                label: 'Medication',
                icon: Icons.medication,
                color: AppColors.primary,
                onTap: () {
                  AccessibilityService.mediumTap();
                  Navigator.of(context).pushNamed('/medication');
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionButton(
                label: 'History',
                icon: Icons.history,
                color: AppColors.secondary,
                onTap: () {
                  AccessibilityService.mediumTap();
                  Navigator.of(context).pushNamed('/history');
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionButton(
                label: 'Settings',
                icon: Icons.settings,
                color: AppColors.accent,
                onTap: () {
                  AccessibilityService.mediumTap();
                  Navigator.of(context).pushNamed('/settings');
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// ==================== Helper Widgets ====================

  Widget _buildMetricCard({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
    required String semanticLabel,
  }) {
    return Semantics(
      label: semanticLabel,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 8),
              Text(
                value,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall,
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Semantics(
      label: label,
      button: true,
      enabled: true,
      onTap: onTap,
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          color: color.withValues(alpha: 0.15),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color, size: 32),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: color,
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
