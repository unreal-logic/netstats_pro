import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:netstats_pro/core/theme/colors.dart';
import 'package:netstats_pro/injection_container.dart';
import 'package:netstats_pro/presentation/dashboard/bloc/dashboard_bloc.dart';
import 'package:netstats_pro/presentation/dashboard/bloc/dashboard_event.dart';
import 'package:netstats_pro/presentation/dashboard/bloc/dashboard_state.dart';
import 'package:netstats_pro/presentation/widgets/kpi_card.dart';
import 'package:netstats_pro/presentation/widgets/premium_app_bar.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<DashboardBloc>()..add(LoadDashboard()),
      child: Scaffold(
        appBar: const PremiumAppBar(
          title: 'DASHBOARD',
        ),
        body: BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    children: [
                      KpiCard(
                        title: 'WIN RATE',
                        value: '${state.winRate}%',
                        icon: Icons.emoji_events_outlined,
                        trendValue: state.totalGames > 0 ? 'Live' : 'No data',
                        baseColor: NetStatsColors.accentTeal,
                        benchmarkLabel: 'Target 80%',
                        benchmarkStatus: state.winRate >= 80
                            ? 'ON TRACK'
                            : 'BELOW TARGET',
                        benchmarkProgress: (state.winRate / 100).clamp(
                          0.0,
                          1.0,
                        ),
                      ),
                      KpiCard(
                        title: 'GOAL AVG',
                        value: state.goalAvg.toStringAsFixed(1),
                        icon: Icons.adjust,
                        trendValue: 'Avg goals',
                        baseColor: NetStatsColors.primary,
                        benchmarkLabel: 'Top Decile 45.0',
                        benchmarkStatus: state.goalAvg >= 40
                            ? 'EXCELLENT'
                            : 'GOOD',
                        benchmarkProgress: (state.goalAvg / 50).clamp(0.0, 1.0),
                      ),
                      KpiCard(
                        title: 'STAMINA',
                        value: '${state.staminaAvg}%',
                        icon: Icons.bolt,
                        trendValue: 'stable',
                        baseColor: NetStatsColors.staminaPurple,
                        benchmarkLabel: 'peak level',
                        benchmarkStatus: 'PEAK',
                        benchmarkProgress: (state.staminaAvg / 100).clamp(
                          0.0,
                          1.0,
                        ),
                      ),
                      KpiCard(
                        title: 'TURNOVERS',
                        value: state.turnoversAvg.toStringAsFixed(0),
                        icon: Icons.sync_problem,
                        trendValue: '-2.0',
                        baseColor: NetStatsColors.accentCoral,
                        benchmarkLabel: 'avg 15',
                        benchmarkStatus: 'IMPROVING',
                        benchmarkProgress: (1 - (state.turnoversAvg / 30))
                            .clamp(0.0, 1.0),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: () => context.go('/match/setup'),
                    icon: const Icon(Icons.add),
                    label: const Text('START NEW MATCH'),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(double.infinity, 56),
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
}
