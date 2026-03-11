import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:netstats_pro/core/design_system/design_overlay_settings.dart';
import 'package:netstats_pro/data/services/demo_data_service.dart';
import 'package:netstats_pro/injection_container.dart';
import 'package:netstats_pro/presentation/widgets/premium_app_bar.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PremiumAppBar(
        title: 'SETTINGS',
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.palette_outlined),
              title: const Text('Design Style Guide'),
              subtitle: const Text('Preview theme & components'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.go('/settings/style-guide'),
            ),
          ),
          const SizedBox(height: 16),
          const _DesignHelpersSection(),
          const SizedBox(height: 16),
          Card(
            color: Theme.of(context).colorScheme.errorContainer,
            child: ListTile(
              leading: Icon(
                Icons.data_object,
                color: Theme.of(context).colorScheme.onErrorContainer,
              ),
              title: Text(
                'Generate Demo Data',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onErrorContainer,
                ),
              ),
              subtitle: Text(
                'Creates 5 teams, 12 players each, venues, and competitions',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onErrorContainer,
                ),
              ),
              trailing: const Icon(Icons.warning, color: Colors.orange),
              onTap: () async {
                unawaited(
                  showDialog<void>(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) =>
                        const Center(child: CircularProgressIndicator()),
                  ),
                );

                try {
                  await sl<DemoDataService>().generateDemoData();
                  if (context.mounted) {
                    Navigator.of(
                      context,
                      rootNavigator: true,
                    ).pop(); // Dismiss loading Dialog
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Demo data generated successfully!'),
                      ),
                    );
                  }
                } on Exception catch (e) {
                  if (context.mounted) {
                    Navigator.of(
                      context,
                      rootNavigator: true,
                    ).pop(); // Dismiss loading Dialog
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to generate data: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                } on Object catch (e) {
                  if (context.mounted) {
                    Navigator.of(context, rootNavigator: true).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('An unexpected error occurred: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _DesignHelpersSection extends StatelessWidget {
  const _DesignHelpersSection();

  @override
  Widget build(BuildContext context) {
    final settings = sl<DesignOverlaySettings>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 8),
          child: Text(
            'DESIGN HELPERS',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
        Card(
          child: ListenableBuilder(
            listenable: settings,
            builder: (context, _) {
              return Column(
                children: [
                  SwitchListTile(
                    secondary: const Icon(Icons.ads_click),
                    title: const Text('Thumb Zone Overlay'),
                    subtitle: const Text('Visualize ergonomic reachability'),
                    value: settings.showThumbZone,
                    onChanged: (value) => settings.showThumbZone = value,
                  ),
                  const Divider(height: 1, indent: 56),
                  SwitchListTile(
                    secondary: const Icon(Icons.gesture),
                    title: const Text('Z-Pattern Overlay'),
                    subtitle: const Text('Visualize visual scanning path'),
                    value: settings.showZPattern,
                    onChanged: (value) => settings.showZPattern = value,
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
