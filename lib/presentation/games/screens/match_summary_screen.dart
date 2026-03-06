import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:netstats_pro/core/theme/colors.dart';
import 'package:netstats_pro/domain/usecases/get_match_summary_use_case.dart';
import 'package:netstats_pro/injection_container.dart';
import 'package:netstats_pro/presentation/games/bloc/match_summary_bloc.dart';
import 'package:netstats_pro/presentation/games/bloc/match_summary_event.dart';
import 'package:netstats_pro/presentation/games/bloc/match_summary_state.dart';

class MatchSummaryScreen extends StatelessWidget {
  const MatchSummaryScreen({required this.gameId, super.key});

  final int gameId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<MatchSummaryBloc>()..add(LoadMatchSummary(gameId)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('MATCH SUMMARY'),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => context.go('/games'),
          ),
        ),
        body: BlocBuilder<MatchSummaryBloc, MatchSummaryState>(
          builder: (context, state) {
            if (state.status == MatchSummaryStatus.loading ||
                state.status == MatchSummaryStatus.initial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.status == MatchSummaryStatus.failure) {
              return Center(
                child: Text(
                  state.errorMessage ?? 'An error occurred',
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              );
            }

            final data = state.summaryData!;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildScoreHeader(context, data),
                  const SizedBox(height: 32),
                  const Text(
                    'TEAM STATISTICS',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildStatRow(
                    context,
                    'Goals',
                    data.homeStats.goals.toString(),
                    data.awayStats.goals.toString(),
                  ),
                  _buildStatRow(
                    context,
                    'Misses',
                    data.homeStats.misses.toString(),
                    data.awayStats.misses.toString(),
                  ),
                  _buildStatRow(
                    context,
                    'Shooting %',
                    '${data.homeStats.shootingPercentage.toStringAsFixed(1)}%',
                    '${data.awayStats.shootingPercentage.toStringAsFixed(1)}%',
                  ),
                  _buildStatRow(
                    context,
                    'Intercepts',
                    data.homeStats.intercepts.toString(),
                    data.awayStats.intercepts.toString(),
                  ),
                  _buildStatRow(
                    context,
                    'Turnovers',
                    data.homeStats.turnovers.toString(),
                    data.awayStats.turnovers.toString(),
                  ),
                  _buildStatRow(
                    context,
                    'Rebounds',
                    data.homeStats.rebounds.toString(),
                    data.awayStats.rebounds.toString(),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => context.go('/games'),
                      child: const Text('BACK TO GAMES'),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildScoreHeader(BuildContext context, MatchSummaryData data) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              children: [
                Text(
                  data.game.homeTeamName.toUpperCase(),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: NetStatsColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  '${data.game.homeScore ?? 0}',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: NetStatsColors.primary,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Lexend',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Text(
            'FT',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Theme.of(context).colorScheme.outline,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              children: [
                Text(
                  data.game.opponentName.toUpperCase(),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: NetStatsColors.accentTeal,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  '${data.game.awayScore ?? 0}',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: NetStatsColors.accentTeal,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Lexend',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(
    BuildContext context,
    String label,
    String homeValue,
    String awayValue,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              homeValue,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: NetStatsColors.primary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Text(
              awayValue,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: NetStatsColors.accentTeal,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
