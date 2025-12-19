import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:tremor_ring_app/utils/colors.dart';

class DeviceListItem extends StatelessWidget {
  final BluetoothDevice device;
  final VoidCallback onTap;
  final bool isConnecting;

  const DeviceListItem({
    super.key,
    required this.device,
    required this.onTap,
    required this.isConnecting,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary.withValues(alpha: 0.1),
          ),
          child: const Icon(
            Icons.watch,
            color: AppColors.primary,
          ),
        ),
        title: Text(
          device.platformName.isEmpty ? 'Unknown Device' : device.platformName,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Text(
          device.remoteId.toString(),
          style: Theme.of(context).textTheme.bodySmall,
        ),
        trailing: isConnecting
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : ElevatedButton(
                onPressed: onTap,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                child: const Text('Connect'),
              ),
      ),
    );
  }
}
