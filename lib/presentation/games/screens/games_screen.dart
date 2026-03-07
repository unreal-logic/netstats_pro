import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:netstats_pro/domain/entities/game.dart';
import 'package:netstats_pro/injection_container.dart';
import 'package:netstats_pro/presentation/games/bloc/games_bloc.dart';
import 'package:netstats_pro/presentation/games/bloc/games_event.dart';
import 'package:netstats_pro/presentation/games/bloc/games_state.dart';
import 'package:netstats_pro/presentation/widgets/premium_app_bar.dart';

class GamesScreen extends StatelessWidget {
  const GamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<GamesBloc>()..add(const LoadGames()),
      child: Scaffold(
        appBar: const PremiumAppBar(
          title: 'GAMES',
        ),
        body: BlocBuilder<GamesBloc, GamesState>(
          builder: (context, state) {
            if (state.status == GamesStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.games.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.sports_handball,
                      size: 64,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No matches played yet',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                    const SizedBox(height: 8),
                    FilledButton.icon(
                      onPressed: () => context.go('/games/setup'),
                      icon: const Icon(Icons.add),
                      label: const Text('START YOUR FIRST MATCH'),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.games.length,
              itemBuilder: (context, index) {
                final game = state.games[index];
                final dateFormat = DateFormat('EEE, d MMM yyyy • HH:mm');

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    title: Text(
                      '${game.homeTeamName} vs ${game.opponentName}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(dateFormat.format(game.scheduledAt)),
                        Text(
                          '${game.competitionName} • ${game.venueName}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      if (game.status == GameStatus.completed) {
                        unawaited(context.push('/games/summary/${game.id}'));
                      } else {
                        unawaited(context.push('/games/live/${game.id}'));
                      }
                    },
                  ),
                );
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => context.go('/games/setup'),
          label: const Text('NEW MATCH'),
          icon: const Icon(Icons.add),
        ),
      ),
    );
  }
}
