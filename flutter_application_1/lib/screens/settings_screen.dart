import 'package:flutter/material.dart';
import 'package:tremor_ring_app/utils/colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(context, '👤 Profile'),
          Card(
            color: AppColors.surface,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ahmed Mohammed Al-Mansouri',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    'Age: 68 | Parkinson\'s Disease',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text('Edit Profile'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionTitle(context, '🔔 Notifications'),
          SwitchListTile(
            title: const Text('Medication Reminders'),
            subtitle: const Text('Get reminders for your medications'),
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() => _notificationsEnabled = value);
            },
          ),
          SwitchListTile(
            title: const Text('Health Alerts'),
            subtitle: const Text('Alerts for abnormal readings'),
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() => _notificationsEnabled = value);
            },
          ),
          const SizedBox(height: 24),
          _buildSectionTitle(context, '🆘 Emergency'),
          ListTile(
            title: const Text('Emergency Settings'),
            subtitle: const Text('Manage emergency contacts'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).pushNamed('/emergency-settings'),
          ),
          ListTile(
            title: const Text('Incident History'),
            subtitle: const Text('View all reported incidents'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).pushNamed('/incident-history'),
          ),
          const SizedBox(height: 24),
          _buildSectionTitle(context, '🔧 Device'),
          const ListTile(
            title: Text('Ring Firmware'),
            subtitle: Text('v1.2.0'),
            trailing: Text('Up to date'),
          ),
          const ListTile(
            title: Text('Battery Health'),
            subtitle: Text('96%'),
            trailing: Icon(Icons.check_circle, color: AppColors.accentGreen),
          ),
          const SizedBox(height: 24),
          _buildSectionTitle(context, 'ℹ️ About'),
          const ListTile(
            title: Text('App Version'),
            trailing: Text('1.0.0'),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }
}