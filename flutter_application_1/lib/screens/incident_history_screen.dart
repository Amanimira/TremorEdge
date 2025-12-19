import 'package:flutter/material.dart';
import 'package:tremor_ring_app/services/emergency_service.dart';
import 'package:tremor_ring_app/utils/colors.dart';

class IncidentHistoryScreen extends StatefulWidget {
  const IncidentHistoryScreen({super.key});

  @override
  State<IncidentHistoryScreen> createState() => _IncidentHistoryScreenState();
}

class _IncidentHistoryScreenState extends State<IncidentHistoryScreen> {
  late Future<List> _incidentsFuture;

  @override
  void initState() {
    super.initState();
    _incidentsFuture = EmergencyService().getIncidentHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('سجل الحوادث'),
        elevation: 0,
      ),
      body: FutureBuilder(
        future: _incidentsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final incidents = snapshot.data ?? [];

          if (incidents.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.check_circle,
                      size: 80,
                      color: AppColors.accentGreen,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'لا توجد حوادث مسجلة',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'جميع القراءات طبيعية حتى الآن',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: incidents.length,
            itemBuilder: (context, index) {
              final incident = incidents[index];
              return _buildIncidentCard(context, incident);
            },
          );
        },
      ),
    );
  }

  Widget _buildIncidentCard(BuildContext context, dynamic incident) {
    final isResolved = incident.isResolved;
    final color = incident.severityColor;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          border: Border.all(
            color: color,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getIncidentTypeLabel(incident.type),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      incident.formattedTime,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isResolved
                        ? AppColors.accentGreen.withValues(alpha: 0.2)
                        : AppColors.warning.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    isResolved ? '✅ تم حلها' : '⏳ معلقة',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: isResolved
                          ? AppColors.accentGreen
                          : AppColors.warning,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            if (incident.severity != null) ...[
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'مستوى الخطورة',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    '${(incident.severity! * 100).toStringAsFixed(0)}%',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _getIncidentTypeLabel(String type) {
    switch (type) {
      case 'FALL':
        return '🚨 كشف سقوط';
      case 'MANUAL_SOS':
        return '🆘 استدعاء طوارئ يدوي';
      case 'HIGH_TREMOR':
        return '⚠️ ارتعاش مرتفع';
      default:
        return 'حادثة غير محددة';
    }
  }
}
