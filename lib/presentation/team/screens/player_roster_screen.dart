import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:netstats_pro/domain/entities/player.dart';
import 'package:netstats_pro/domain/repositories/player_repository.dart';
import 'package:netstats_pro/injection_container.dart';
import 'package:netstats_pro/presentation/widgets/premium_app_bar.dart';

class PlayerRosterScreen extends StatelessWidget {
  const PlayerRosterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final repository = sl<PlayerRepository>();

    return Scaffold(
      appBar: PremiumAppBar(
        title: 'PLAYER ROSTER',
        actions: [
          IconButton(
            tooltip: 'Add Demo Players',
            icon: const Icon(Icons.playlist_add_outlined),
            onPressed: () => _seedSampleData(repository),
          ),
          IconButton(
            tooltip: 'Add Player',
            icon: const Icon(Icons.person_add_outlined),
            onPressed: () => context.push('/team/add'),
          ),
        ],
      ),
      body: StreamBuilder<List<Player>>(
        stream: repository.watchAllPlayers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final players = snapshot.data ?? [];

          if (players.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.group_outlined,
                    size: 64,
                    color: theme.colorScheme.outline.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No players found',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  FilledButton.icon(
                    onPressed: () => _seedSampleData(repository),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Sample Players'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: players.length,
            itemBuilder: (context, index) {
              final player = players[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: theme.colorScheme.primaryContainer,
                    child: Text(
                      player.primaryNumber?.toString() ?? '?',
                      style: TextStyle(
                        color: theme.colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(player.fullName),
                  subtitle: Text(
                    player.preferredPositions.map((e) => e.name).join(', '),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/team/player/${player.id}'),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _seedSampleData(PlayerRepository repository) async {
    final samples = [
      Player(
        id: 0,
        firstName: 'Sarah',
        lastName: 'Netballer',
        nickname: 'Saz',
        primaryNumber: 7,
        preferredPositions: const [NetballPosition.gs, NetballPosition.ga],
        createdAt: DateTime.now(),
      ),
      Player(
        id: 0,
        firstName: 'Emma',
        lastName: 'Defender',
        nickname: 'Em',
        primaryNumber: 12,
        preferredPositions: const [NetballPosition.gk, NetballPosition.gd],
        createdAt: DateTime.now(),
      ),
      Player(
        id: 0,
        firstName: 'Jessica',
        lastName: 'Center',
        nickname: 'Jess',
        primaryNumber: 4,
        preferredPositions: const [NetballPosition.c, NetballPosition.wa],
        createdAt: DateTime.now(),
      ),
      Player(
        id: 0,
        firstName: 'Laura',
        lastName: 'Wing',
        nickname: 'Loz',
        primaryNumber: 9,
        preferredPositions: const [NetballPosition.wa, NetballPosition.c],
        createdAt: DateTime.now(),
      ),
      Player(
        id: 0,
        firstName: 'Mia',
        lastName: 'Goalie',
        nickname: 'Mi',
        primaryNumber: 1,
        preferredPositions: const [NetballPosition.gs, NetballPosition.ga],
        createdAt: DateTime.now(),
      ),
      Player(
        id: 0,
        firstName: 'Chloe',
        lastName: 'Intercept',
        nickname: 'Chlo',
        primaryNumber: 15,
        preferredPositions: const [NetballPosition.gd, NetballPosition.wd],
        createdAt: DateTime.now(),
      ),
      Player(
        id: 0,
        firstName: 'Isabella',
        lastName: 'Steady',
        nickname: 'Izzy',
        primaryNumber: 22,
        preferredPositions: const [NetballPosition.wd, NetballPosition.c],
        createdAt: DateTime.now(),
      ),
      Player(
        id: 0,
        firstName: 'Sophia',
        lastName: 'Shooter',
        nickname: 'Soph',
        primaryNumber: 3,
        preferredPositions: const [NetballPosition.ga, NetballPosition.gs],
        createdAt: DateTime.now(),
      ),
      Player(
        id: 0,
        firstName: 'Olivia',
        lastName: 'Wall',
        nickname: 'Liv',
        primaryNumber: 88,
        preferredPositions: const [NetballPosition.gk],
        createdAt: DateTime.now(),
      ),
      Player(
        id: 0,
        firstName: 'Grace',
        lastName: 'Mover',
        nickname: 'Gracie',
        primaryNumber: 10,
        preferredPositions: const [NetballPosition.c, NetballPosition.wd],
        createdAt: DateTime.now(),
      ),
      Player(
        id: 0,
        firstName: 'Ava',
        lastName: 'Attacker',
        nickname: 'Av',
        primaryNumber: 11,
        preferredPositions: const [NetballPosition.wa, NetballPosition.ga],
        createdAt: DateTime.now(),
      ),
      Player(
        id: 0,
        firstName: 'Harper',
        lastName: 'Blocker',
        nickname: 'Harp',
        primaryNumber: 5,
        preferredPositions: const [NetballPosition.wd, NetballPosition.gd],
        createdAt: DateTime.now(),
      ),
      Player(
        id: 0,
        firstName: 'Evelyn',
        lastName: 'Pivot',
        nickname: 'Evie',
        primaryNumber: 2,
        preferredPositions: const [NetballPosition.c, NetballPosition.wa],
        createdAt: DateTime.now(),
      ),
      Player(
        id: 0,
        firstName: 'Abigail',
        lastName: 'Screen',
        nickname: 'Abby',
        primaryNumber: 14,
        preferredPositions: const [NetballPosition.gd, NetballPosition.gk],
        createdAt: DateTime.now(),
      ),
    ];

    for (final p in samples) {
      await repository.createPlayer(p);
    }
  }
}
