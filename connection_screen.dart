import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tremor_ring_app/services/ble_service.dart';
import 'package:tremor_ring_app/widgets/device_list_item.dart';
import 'package:tremor_ring_app/utils/colors.dart';

class ConnectionScreen extends StatefulWidget {
  const ConnectionScreen({super.key});

  @override
  State<ConnectionScreen> createState() => _ConnectionScreenState();
}

class _ConnectionScreenState extends State<ConnectionScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        context.read<BLEService>().startScan();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connect to Device'),
      ),
      body: Consumer<BLEService>(
        builder: (context, bleService, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status Card
                Card(
                  color: AppColors.info.withValues(alpha: 0.1),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              bleService.isScanning ? Icons.search : Icons.bluetooth,
                              color: AppColors.info,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Scanning for Devices',
                                    style: Theme.of(context).textTheme.titleMedium,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    bleService.isScanning
                                        ? 'Looking for TremorRing devices...'
                                        : 'Scan complete. Found ${bleService.discoveredDevices.length} device(s)',
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            if (bleService.isScanning)
                              const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Control Buttons
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: bleService.isScanning
                          ? null
                          : () => bleService.startScan(),
                      icon: const Icon(Icons.search),
                      label: const Text('Scan'),
                    ),
                    const SizedBox(width: 12),
                    if (bleService.isScanning)
                      ElevatedButton.icon(
                        onPressed: () => bleService.stopScan(),
                        icon: const Icon(Icons.stop),
                        label: const Text('Stop'),
                      ),
                  ],
                ),
                const SizedBox(height: 24),

                // Devices List
                Text(
                  'Available Devices',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                if (bleService.discoveredDevices.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        children: [
                          Icon(
                            Icons.bluetooth_searching,
                            size: 64,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No devices found',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Make sure your Tremor Ring is powered on',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: bleService.discoveredDevices.length,
                    itemBuilder: (context, index) {
                      final device = bleService.discoveredDevices[index];
                      return DeviceListItem(
                        device: device,
                        onTap: () => bleService.connectToDevice(device),
                        isConnecting: bleService.isConnecting,
                      );
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    context.read<BLEService>().stopScan();
    super.dispose();
  }
}
