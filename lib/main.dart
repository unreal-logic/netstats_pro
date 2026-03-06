import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:netstats_pro/core/design_system/design_system.dart';
import 'package:netstats_pro/core/theme/transitions.dart';
import 'package:netstats_pro/injection_container.dart' as di;
import 'package:netstats_pro/injection_container.dart' show sl;
import 'package:netstats_pro/presentation/dashboard/screens/dashboard_screen.dart';
import 'package:netstats_pro/presentation/games/bloc/live_match_bloc.dart';
import 'package:netstats_pro/presentation/games/screens/games_screen.dart';
import 'package:netstats_pro/presentation/games/screens/live_match_screen.dart';
import 'package:netstats_pro/presentation/games/screens/match_summary_screen.dart';
import 'package:netstats_pro/presentation/games/screens/setup_wizard_screen.dart';
import 'package:netstats_pro/presentation/management/bloc/competitions_bloc.dart';
import 'package:netstats_pro/presentation/management/bloc/players_bloc.dart';
import 'package:netstats_pro/presentation/management/bloc/players_event.dart';
import 'package:netstats_pro/presentation/management/bloc/venues_bloc.dart';
import 'package:netstats_pro/presentation/management/screens/competitions_screen.dart';
import 'package:netstats_pro/presentation/management/screens/players_screen.dart';
import 'package:netstats_pro/presentation/management/screens/venues_screen.dart';
import 'package:netstats_pro/presentation/settings/screens/settings_screen.dart';
import 'package:netstats_pro/presentation/shell/app_shell.dart';
import 'package:netstats_pro/presentation/style_guide/style_guide_screen.dart';
import 'package:netstats_pro/presentation/team/bloc/teams_bloc.dart';
import 'package:netstats_pro/presentation/team/screens/add_player_screen.dart';
import 'package:netstats_pro/presentation/team/screens/player_detail_screen.dart';
import 'package:netstats_pro/presentation/team/screens/team_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const NetstatsProApp());
}

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter _router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/dashboard',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return AppShell(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/dashboard',
              pageBuilder: (context, state) => FadePageRoute(
                child: const DashboardScreen(),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/games',
              pageBuilder: (context, state) => FadePageRoute(
                child: const GamesScreen(),
              ),
              routes: [
                GoRoute(
                  path: 'setup',
                  builder: (context, state) => const SetupWizardScreen(),
                ),
                GoRoute(
                  path: 'live/:gameId',
                  builder: (context, state) {
                    final gameId = int.parse(state.pathParameters['gameId']!);
                    return BlocProvider(
                      create: (context) => sl<LiveMatchBloc>(),
                      child: LiveMatchScreen(gameId: gameId),
                    );
                  },
                ),
                GoRoute(
                  path: 'summary/:gameId',
                  builder: (context, state) {
                    final gameId = int.parse(state.pathParameters['gameId']!);
                    return MatchSummaryScreen(gameId: gameId);
                  },
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/team',
              pageBuilder: (context, state) => FadePageRoute(
                child: BlocProvider(
                  create: (context) => sl<TeamsBloc>(),
                  child: const TeamScreen(),
                ),
              ),
              routes: [
                GoRoute(
                  path: 'profile/:teamId',
                  builder: (context, state) {
                    final teamId = int.parse(state.pathParameters['teamId']!);
                    return BlocProvider(
                      create: (context) =>
                          sl<PlayersBloc>()..add(LoadPlayers(teamId: teamId)),
                      child: PlayersScreen(teamId: teamId),
                    );
                  },
                ),
                GoRoute(
                  path: 'add',
                  builder: (context, state) => const AddPlayerScreen(),
                ),
                GoRoute(
                  path: 'player/:id',
                  builder: (context, state) {
                    final id = int.parse(state.pathParameters['id']!);
                    return PlayerDetailScreen(playerId: id);
                  },
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/more',
              pageBuilder: (context, state) => FadePageRoute(
                child: const SizedBox.shrink(),
              ),
              routes: [
                GoRoute(
                  path: 'competitions',
                  builder: (context, state) => BlocProvider(
                    create: (context) => sl<CompetitionsBloc>(),
                    child: const CompetitionsScreen(),
                  ),
                ),
                GoRoute(
                  path: 'venues',
                  builder: (context, state) => BlocProvider(
                    create: (context) => sl<VenuesBloc>(),
                    child: const VenuesScreen(),
                  ),
                ),
                GoRoute(
                  path: 'settings',
                  builder: (context, state) => const SettingsScreen(),
                  routes: [
                    GoRoute(
                      path: 'style-guide',
                      builder: (context, state) => const StyleGuideScreen(),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);

final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.dark);

class NetstatsProApp extends StatelessWidget {
  const NetstatsProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, currentMode, _) {
        return MaterialApp.router(
          routerConfig: _router,
          title: 'Netstats Pro System',
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: currentMode,
        );
      },
    );
  }
}
