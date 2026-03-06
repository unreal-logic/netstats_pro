import 'package:flutter/material.dart';
import 'package:netstats_pro/core/theme/colors.dart';
import 'package:netstats_pro/main.dart'; // To access themeNotifier
import 'package:netstats_pro/presentation/widgets/kpi_card.dart';

class StyleGuideScreen extends StatefulWidget {
  const StyleGuideScreen({super.key});

  @override
  State<StyleGuideScreen> createState() => _StyleGuideScreenState();
}

class _StyleGuideScreenState extends State<StyleGuideScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              'MATCH SETUP',
              style: textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                letterSpacing: 2,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text('Modern Card System'),
          ],
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              themeNotifier.value = isDark ? ThemeMode.light : ThemeMode.dark;
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Profile Header simulation
            _buildProfileSection(theme),
            const SizedBox(height: 24),

            // Buttons simulation
            _buildButtonSection(theme),
            const SizedBox(height: 24),

            // KPI Grid
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('PERFORMANCE KPI', style: textTheme.labelMedium),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.expand_more, size: 16),
                  label: const Text('SEASON 23'),
                  style: TextButton.styleFrom(
                    foregroundColor: colorScheme.primary,
                    textStyle: textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.85,
              children: [
                KpiCard(
                  title: 'Shooting Accuracy',
                  value: '85',
                  unit: '%',
                  trendValue: '+5%',
                  icon: Icons.track_changes,
                  baseColor: colorScheme.tertiary,
                  benchmarkLabel: 'Vs Team Avg',
                  benchmarkStatus: 'Above Target (80%)',
                  benchmarkProgress: 0.85,
                ),
                KpiCard(
                  title: 'Interceptions',
                  value: '12',
                  trendValue: '+2.1',
                  icon: Icons.back_hand,
                  baseColor: colorScheme.primary,
                  benchmarkLabel: 'League Rank',
                  benchmarkStatus: 'Top 15% in League',
                  benchmarkProgress: 0.70,
                ),
                KpiCard(
                  title: 'Rebounds',
                  value: '08',
                  trendValue: '-1.2',
                  icon: Icons.keyboard_double_arrow_up,
                  baseColor: colorScheme.error,
                  benchmarkLabel: 'Vs Season Goal',
                  benchmarkStatus: 'Action Required: Low',
                  benchmarkProgress: 0.40,
                ),
                const KpiCard(
                  title: 'Avg Playtime',
                  value: '42',
                  unit: 'm',
                  trendValue: 'STA',
                  icon: Icons.timer,
                  baseColor: NetStatsColors.staminaPurple,
                  benchmarkLabel: 'Stamina Trend',
                  benchmarkStatus: 'Elite Endurance',
                  benchmarkProgress: 0.95,
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Typography Scale
            Text('TYPOGRAPHY SCALE', style: textTheme.labelMedium),
            const SizedBox(height: 16),
            Card(
              color: colorScheme.surfaceContainerHighest,
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Display Small', style: textTheme.displaySmall),
                    const Divider(),
                    Text('Headline Medium', style: textTheme.headlineMedium),
                    const Divider(),
                    Text('Title Large', style: textTheme.titleLarge),
                    const Divider(),
                    Text('Body Medium', style: textTheme.bodyMedium),
                    const Divider(),
                    Text('Label Small', style: textTheme.labelSmall),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) =>
            setState(() => _selectedIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.grid_view_outlined),
            selectedIcon: Icon(Icons.grid_view),
            label: 'BOARD',
          ),
          NavigationDestination(
            icon: Icon(Icons.groups_outlined),
            selectedIcon: Icon(Icons.groups),
            label: 'ROSTER',
          ),
          NavigationDestination(
            icon: Icon(Icons.analytics_outlined),
            selectedIcon: Icon(Icons.analytics),
            label: 'TACTICS',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_circle_outlined),
            selectedIcon: Icon(Icons.account_circle),
            label: 'PROFILE',
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection(ThemeData theme) {
    return Column(
      children: [
        CircleAvatar(
          radius: 56,
          backgroundColor: theme.colorScheme.surfaceContainerHighest,
          child: Icon(
            Icons.person,
            size: 56,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 16),
        Text('Sarah Johnson', style: theme.textTheme.headlineSmall),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: theme.colorScheme.tertiaryContainer,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'GS',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onTertiaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Goal Shooter',
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'MELBOURNE VIXENS • 24 YEARS',
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildButtonSection(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: FilledButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.monitor_weight),
            label: const Text('DEVELOPMENT'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: FilledButton.tonalIcon(
            onPressed: () {},
            icon: const Icon(Icons.edit_note),
            label: const Text('NOTES'),
          ),
        ),
      ],
    );
  }
}
