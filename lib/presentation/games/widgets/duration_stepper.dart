import 'package:flutter/material.dart';

class DurationStepper extends StatelessWidget {
  const DurationStepper({
    required this.minutes,
    required this.onChanged,
    this.title = 'DURATION (MINUTES)',
    this.minMinutes = 1,
    this.maxMinutes = 60,
    super.key,
  });

  final int minutes;
  final ValueChanged<int> onChanged;
  final String title;
  final int minMinutes;
  final int maxMinutes;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title.toUpperCase(),
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
            color: Colors.blueGrey,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            // Minus button
            StepperButton(
              icon: Icons.remove,
              onPressed: minutes > minMinutes
                  ? () => onChanged(minutes - 1)
                  : null,
            ),
            const SizedBox(width: 8),
            // Central display
            Expanded(
              child: Container(
                height: 58,
                decoration: BoxDecoration(
                  color: cs.surfaceContainerHighest.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: cs.outline.withValues(alpha: 0.15)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$minutes',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.timer_outlined,
                      size: 20,
                      color: cs.onSurfaceVariant.withValues(alpha: 0.6),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Plus button
            StepperButton(
              icon: Icons.add,
              onPressed: minutes < maxMinutes
                  ? () => onChanged(minutes + 1)
                  : null,
            ),
          ],
        ),
      ],
    );
  }
}

class StepperButton extends StatelessWidget {
  const StepperButton({required this.icon, this.onPressed, super.key});

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDisabled = onPressed == null;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            color: cs.surfaceContainerHighest.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDisabled
                  ? cs.outline.withValues(alpha: 0.1)
                  : cs.outline.withValues(alpha: 0.3),
            ),
          ),
          child: Icon(
            icon,
            color: isDisabled
                ? cs.onSurface.withValues(alpha: 0.2)
                : cs.onSurface,
          ),
        ),
      ),
    );
  }
}
