import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:netstats_pro/domain/entities/game.dart';
import 'package:netstats_pro/presentation/games/widgets/score_only_grid.dart';

void main() {
  group('ScoreOnlyGrid Aesthetic Verification', () {
    testWidgets('Buttons should have tinted background and correct labels', (
      tester,
    ) async {
      final game = Game(
        id: 1,
        opponentName: 'Opponent',
        competitionName: 'Comp',
        venueName: 'Venue',
        scheduledAt: DateTime.now(),
        format: GameFormat.sevenAside,
        status: GameStatus.inProgress,
        ourFirstCentrePass: true,
        createdAt: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ScoreOnlyGrid(
              game: game,
              onStatSelected: (_, {required isHome}) {},
              homeColor: Colors.blue,
              awayColor: Colors.red,
            ),
          ),
        ),
      );

      // Verify "GOAL" labels - Only 1PT should be visible for standard 7-aside
      expect(
        find.text('GOAL'),
        findsOneWidget, // 1PT Goal (shared between Home/Away)
      );
      expect(
        find.text('2PT'),
        findsNothing,
      );
      expect(
        find.text('CORRECTION'),
        findsOneWidget, // Correction (shared between Home/Away)
      );

      // Verify tinted background for first addition button
      final addIcons = find.byIcon(Icons.add);
      final Material material = tester.widget<Material>(
        find
            .ancestor(of: addIcons.first, matching: find.byType(Material))
            .first,
      );

      // opacity should be around 0.1
      expect(material.color?.opacity, closeTo(0.1, 0.1));
    });
  });

  group('ScoreOnlyGrid Refinement Rules', () {
    testWidgets(
      '7-aside with Super Shot: 2PT visible but disabled until active',
      (
        tester,
      ) async {
        final game = Game(
          id: 1,
          opponentName: 'Opponent',
          competitionName: 'Comp',
          venueName: 'Venue',
          scheduledAt: DateTime.now(),
          format: GameFormat.sevenAside,
          isSuperShot: true,
          status: GameStatus.inProgress,
          ourFirstCentrePass: true,
          createdAt: DateTime.now(),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ScoreOnlyGrid(
                game: game,
                isSpecialScoringActive: false,
                onStatSelected: (_, {required isHome}) {},
                homeColor: Colors.blue,
                awayColor: Colors.red,
              ),
            ),
          ),
        );

        expect(find.text('1PT'), findsNWidgets(2)); // Goal & Correction
        expect(find.text('2PT'), findsOneWidget); // One row for 2PT
        expect(find.text('3PT'), findsNothing);

        // Verify 2PT buttons are disabled (opacity check on the icon)
        final boltIcons = find.byIcon(Icons.bolt);
        // The first bolt icon is the 2PT goal
        final icon2pt = tester.widget<Icon>(boltIcons.at(0));
        expect(icon2pt.color?.opacity, closeTo(0.3, 0.1));
      },
    );

    testWidgets('5-aside: All point buttons visible and enabled', (
      tester,
    ) async {
      final game = Game(
        id: 1,
        opponentName: 'Opponent',
        competitionName: 'Comp',
        venueName: 'Venue',
        scheduledAt: DateTime.now(),
        format: GameFormat.fiveAside,
        status: GameStatus.inProgress,
        ourFirstCentrePass: true,
        createdAt: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ScoreOnlyGrid(
              game: game,
              onStatSelected: (_, {required isHome}) {},
              homeColor: Colors.blue,
              awayColor: Colors.red,
            ),
          ),
        ),
      );

      expect(find.text('1PT'), findsNWidgets(2));
      expect(find.text('2PT'), findsOneWidget);
      expect(find.text('3PT'), findsOneWidget);

      // Verify 3PT buttons are enabled
      final boltIcons = find.byIcon(Icons.bolt);
      // In 5-aside, we have 2PT (at 0,1) and 3PT (at 2,3)
      final icon3pt = tester.widget<Icon>(boltIcons.at(2)); // 3PT Home
      expect(icon3pt.color?.opacity, 1.0);
    });
  });
}
