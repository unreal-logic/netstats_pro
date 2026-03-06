import 'package:flutter/material.dart';
import 'package:netstats_pro/domain/entities/player.dart';
import 'package:netstats_pro/domain/repositories/player_repository.dart';
import 'package:netstats_pro/injection_container.dart';
import 'package:netstats_pro/presentation/widgets/premium_app_bar.dart';

class PlayerDetailScreen extends StatelessWidget {
  const PlayerDetailScreen({required this.playerId, super.key});
  final int playerId;

  @override
  Widget build(BuildContext context) {
    final repository = sl<PlayerRepository>();

    return FutureBuilder<Player?>(
      future: repository.getPlayerById(playerId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final player = snapshot.data;
        if (player == null) {
          return Scaffold(
            appBar: const PremiumAppBar(title: 'Player Not Found'),
            body: Center(child: Text('Player with ID $playerId not found')),
          );
        }

        return Scaffold(
          appBar: PremiumAppBar(title: player.fullName.toUpperCase()),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.primaryContainer,
                    child: Text(
                      player.primaryNumber?.toString() ?? '?',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                _buildInfoSection(context, 'Details', {
                  'First Name': player.firstName,
                  'Last Name': player.lastName,
                  'Nickname': player.nickname ?? 'None',
                  'Primary Number': player.primaryNumber?.toString() ?? 'N/A',
                }),
                const SizedBox(height: 24),
                _buildInfoSection(context, 'Positions', {
                  'Preferred': player.preferredPositions
                      .map((e) => e.name)
                      .join(', '),
                }),
                const SizedBox(height: 32),
                Center(
                  child: Text(
                    'Stats & History coming soon',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoSection(
    BuildContext context,
    String title,
    Map<String, String> items,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...items.entries.map(
          (e) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  e.key,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  e.value,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
