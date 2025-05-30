import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartuaqyt/data/services/connectivity_service.dart';

class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red.shade100,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        children: [
          const Icon(Icons.cloud_off, color: Colors.red),
          const SizedBox(width: 16),
          const Expanded(
            child: Text(
              'You are offline. Some features may be limited.',
              style: TextStyle(color: Colors.red),
            ),
          ),
          Consumer<ConnectivityService>(
            builder: (context, connectivity, _) {
              if (connectivity.isOnline) {
                return TextButton.icon(
                  icon: const Icon(Icons.sync),
                  label: const Text('Sync'),
                  onPressed: () {
                    // TODO: Implement sync logic
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Syncing data...'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
