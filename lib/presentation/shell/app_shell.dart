import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class AppShell extends StatelessWidget {
  const AppShell({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  void _onTap(BuildContext context, int index) {
    unawaited(HapticFeedback.lightImpact());
    if (index == 3) {
      unawaited(_showMoreMenu(context));
    } else {
      navigationShell.goBranch(
        index,
        initialLocation: index == navigationShell.currentIndex,
      );
    }
  }

  Future<void> _showMoreMenu(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _MoreMenuSheet(
        onItemSelected: (route) {
          Navigator.pop(context);
          navigationShell.goBranch(3); // Switch to the More branch
          context.go(route);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return Scaffold(
            body: navigationShell,
            bottomNavigationBar: NavigationBar(
              selectedIndex: navigationShell.currentIndex,
              onDestinationSelected: (index) => _onTap(context, index),
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.dashboard_outlined),
                  selectedIcon: Icon(Icons.dashboard),
                  label: 'DASHBOARD',
                ),
                NavigationDestination(
                  icon: Icon(Icons.sports_score_outlined),
                  selectedIcon: Icon(Icons.sports_score),
                  label: 'GAMES',
                ),
                NavigationDestination(
                  icon: Icon(Icons.groups_outlined),
                  selectedIcon: Icon(Icons.groups),
                  label: 'TEAM',
                ),
                NavigationDestination(
                  icon: Icon(Icons.more_horiz_outlined),
                  selectedIcon: Icon(Icons.more_horiz),
                  label: 'MORE',
                ),
              ],
            ),
          );
        }

        return Scaffold(
          body: Row(
            children: [
              NavigationRail(
                selectedIndex: navigationShell.currentIndex,
                onDestinationSelected: (index) => _onTap(context, index),
                labelType: NavigationRailLabelType.all,
                destinations: const [
                  NavigationRailDestination(
                    icon: Icon(Icons.dashboard_outlined),
                    selectedIcon: Icon(Icons.dashboard),
                    label: Text('DASHBOARD'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.sports_score_outlined),
                    selectedIcon: Icon(Icons.sports_score),
                    label: Text('GAMES'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.groups_outlined),
                    selectedIcon: Icon(Icons.groups),
                    label: Text('TEAM'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.more_horiz_outlined),
                    selectedIcon: Icon(Icons.more_horiz),
                    label: Text('MORE'),
                  ),
                ],
              ),
              const VerticalDivider(thickness: 1, width: 1),
              Expanded(child: navigationShell),
            ],
          ),
        );
      },
    );
  }
}

class _MoreMenuSheet extends StatelessWidget {
  const _MoreMenuSheet({required this.onItemSelected});

  final void Function(String route) onItemSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 32,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            _buildMenuItem(
              context,
              icon: Icons.emoji_events_outlined,
              label: 'Competitions',
              onTap: () => onItemSelected('/more/competitions'),
            ),
            _buildMenuItem(
              context,
              icon: Icons.stadium_outlined,
              label: 'Venues',
              onTap: () => onItemSelected('/more/venues'),
            ),
            _buildMenuItem(
              context,
              icon: Icons.settings_outlined,
              label: 'Settings',
              onTap: () => onItemSelected('/more/settings'),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(
        label,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, size: 20),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
    );
  }
}
