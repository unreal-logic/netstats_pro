import 'package:flutter/material.dart';

class KpiCard extends StatelessWidget {
  const KpiCard({
    required this.title,
    required this.value,
    required this.trendValue,
    required this.icon,
    required this.baseColor,
    required this.benchmarkLabel,
    required this.benchmarkStatus,
    required this.benchmarkProgress,
    super.key,
    this.unit = '',
  });
  final String title;
  final String value;
  final String unit;
  final String trendValue;
  final IconData icon;
  final Color baseColor;
  final String benchmarkLabel;
  final String benchmarkStatus;
  final double benchmarkProgress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row (Icon & Trend Badge)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: baseColor, size: 20),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: baseColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: baseColor.withValues(alpha: 0.2)),
                  ),
                  child: Text(
                    trendValue,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: baseColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            // Value & Title
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.toUpperCase(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurfaceVariant,
                    letterSpacing: -0.2,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Flexible(
                      child: Text(
                        value,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          height: 1.1,
                          fontSize: 24,
                        ),
                      ),
                    ),
                    if (unit.isNotEmpty) ...[
                      const SizedBox(width: 4),
                      Text(
                        unit,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
            const Spacer(),
            // Bottom Benchmark
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        benchmarkLabel.toUpperCase(),
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontSize: 8,
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    Text(
                      benchmarkStatus,
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontSize: 8,
                        fontWeight: FontWeight.w900,
                        color: baseColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: benchmarkProgress,
                  backgroundColor: theme.colorScheme.surfaceContainerHigh,
                  color: baseColor,
                  borderRadius: BorderRadius.circular(2),
                  minHeight: 3,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
