import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:netstats_pro/domain/entities/match_event.dart';
import 'package:netstats_pro/presentation/games/widgets/ergonomic_stats_grid.dart';
import 'package:netstats_pro/presentation/games/widgets/stats_input_grid.dart';

void main() {
  group('Stats Widgets Verification', () {
    final expectedStats = [
      MatchEventType.goal,
      MatchEventType.intercept,
      MatchEventType.deflection,
      MatchEventType.offensiveRebound,
      MatchEventType.defensiveRebound,
      MatchEventType.assist,
      MatchEventType.pickup,
      MatchEventType.miss,
      MatchEventType.turnover,
      MatchEventType.penaltyContact,
      MatchEventType.penaltyObstruction,
      MatchEventType.heldBall,
      MatchEventType.centerPass,
    ];

    testWidgets('StatsInputGrid should have all expected buttons', (
      tester,
    ) async {
      MatchEventType? selectedStat;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatsInputGrid(
              onStatSelected: (stat) => selectedStat = stat,
            ),
          ),
        ),
      );

      for (final stat in expectedStats) {
        final finder = find
            .textContaining(
              _getStatLabel(stat).toUpperCase(),
              findRichText: true,
            )
            .last; // Use .last

        expect(
          finder,
          findsOneWidget,
          reason: 'Button for ${stat.name} not found',
        );

        await tester.ensureVisible(finder);
        await tester.pumpAndSettle();
        await tester.tap(finder);
        expect(
          selectedStat,
          stat,
          reason: 'Callback not triggered for ${stat.name}',
        );
      }
    });

    testWidgets(
      'ErgonomicStatsGrid should have all expected buttons (Functional Parity)',
      (tester) async {
        MatchEventType? selectedStat;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: ErgonomicStatsGrid(
                  onStatSelected: (stat) => selectedStat = stat,
                ),
              ),
            ),
          ),
        );

        for (final stat in expectedStats) {
          final finder = find
              .textContaining(
                _getStatLabel(stat).toUpperCase(),
                findRichText: true,
              )
              .last;

          expect(
            finder,
            findsOneWidget,
            reason: 'Button for ${stat.name} not found in Ergonomic grid',
          );

          await tester.ensureVisible(finder);
          await tester.pumpAndSettle();
          await tester.tap(finder);
          expect(
            selectedStat,
            stat,
            reason: 'Callback not triggered for ${stat.name} in Ergonomic grid',
          );
        }
      },
    );
  });
}

String _getStatLabel(MatchEventType type) {
  return switch (type) {
    MatchEventType.goal => 'GOAL',
    MatchEventType.intercept => 'Intercept',
    MatchEventType.deflection => 'Deflec', // Matches "Deflection" or "Deflect"
    MatchEventType.offensiveRebound => 'Off. Reb',
    MatchEventType.defensiveRebound => 'Def. Reb',
    MatchEventType.assist => 'Assist',
    MatchEventType.pickup => 'Pickup',
    MatchEventType.miss => 'Miss',
    MatchEventType.turnover => 'Turnover',
    MatchEventType.penaltyContact => 'Contact',
    MatchEventType.penaltyObstruction =>
      'Obstruct', // Matches "Obstruction" or "Obstruct"
    MatchEventType.heldBall => 'Held Ball',
    MatchEventType.centerPass => 'Cent', // Matches "Centre Pass" or "Centre"
    _ => '',
  };
}
