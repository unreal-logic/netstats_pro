import 'package:flutter/material.dart';
import 'package:netstats_pro/core/design_system/design_system.dart';
import 'package:netstats_pro/domain/entities/game.dart';

class PremiumScoreboard extends StatefulWidget {
  const PremiumScoreboard({
    required this.isFinished,
    required this.homeTeamName,
    required this.awayTeamName,
    required this.homeScore,
    required this.awayScore,
    required this.currentQuarter,
    required this.matchTime,
    required this.homeHasPossession,
    required this.isTimerRunning,
    this.isAtStart = true,
    this.isSpecialScoringActive = false,
    this.isHomePowerPlayActive = false,
    this.isAwayPowerPlayActive = false,
    this.format = GameFormat.sevenAside,
    this.fast5PowerPlayMode,
    this.isSuperShotEnabled = false,
    this.homeColor,
    this.awayColor,
    this.isLastQuarter = false,
    this.activeRecordingHome,
    this.isRecordingMode = false,
    this.onTimerTap,
    this.onPossessionTap,
    this.onHomePowerPlayToggle,
    this.onAwayPowerPlayToggle,
    super.key,
  });

  final String homeTeamName;
  final String awayTeamName;
  final int homeScore;
  final int awayScore;
  final int currentQuarter;
  final String matchTime;
  final bool homeHasPossession;
  final bool isTimerRunning;
  final bool isAtStart;
  final bool isSpecialScoringActive;
  final bool isHomePowerPlayActive;
  final bool isAwayPowerPlayActive;
  final GameFormat format;
  final Fast5PowerPlayMode? fast5PowerPlayMode;
  final bool isSuperShotEnabled;
  final Color? homeColor;
  final Color? awayColor;
  final bool isFinished;
  final bool isLastQuarter;
  final bool? activeRecordingHome;
  final bool isRecordingMode;
  final VoidCallback? onTimerTap;
  final VoidCallback? onPossessionTap;
  final VoidCallback? onHomePowerPlayToggle;
  final VoidCallback? onAwayPowerPlayToggle;

  @override
  State<PremiumScoreboard> createState() => _PremiumScoreboardState();
}

class _PremiumScoreboardState extends State<PremiumScoreboard> {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        AppSpacing.md,
      ),
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.md,
        horizontal: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            cs.primaryContainer.withValues(alpha: 0.25),
            cs.secondaryContainer.withValues(alpha: 0.15),
          ],
        ),
        borderRadius: AppRadius.brXl,
        border: Border.all(
          color:
              (widget.isSpecialScoringActive ||
                  widget.isHomePowerPlayActive ||
                  widget.isAwayPowerPlayActive)
              ? AppColors.warning.withValues(alpha: 0.6)
              : cs.outline.withValues(alpha: 0.2),
          width:
              (widget.isSpecialScoringActive ||
                  widget.isHomePowerPlayActive ||
                  widget.isAwayPowerPlayActive)
              ? 2
              : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
            spreadRadius: -5,
          ),
          BoxShadow(
            color: cs.primary.withValues(alpha: 0.05),
            blurRadius: 40,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _TeamZone(
              name: widget.homeTeamName,
              score: widget.homeScore,
              color: widget.homeColor ?? cs.primary,
              isHome: true,
              isPowerPlayActive: widget.isHomePowerPlayActive,
              isNominatedMode:
                  widget.format == GameFormat.fiveAside &&
                  widget.fast5PowerPlayMode == Fast5PowerPlayMode.nominated,
              onPowerPlayToggle: widget.onHomePowerPlayToggle,
              format: widget.format,
              isActiveRecording:
                  widget.isRecordingMode &&
                  (widget.activeRecordingHome ?? false),
            ),
          ),
          SizedBox(
            width: 120,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: widget.onTimerTap,
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (widget.isSpecialScoringActive ||
                              (widget.format == GameFormat.sevenAside &&
                                  widget.isSuperShotEnabled) ||
                              widget.format == GameFormat.fiveAside) ...[
                            Icon(
                              widget.format == GameFormat.fiveAside
                                  ? Icons.whatshot
                                  : Icons.bolt,
                              size: 16,
                              color:
                                  (widget.isSpecialScoringActive ||
                                      widget.isHomePowerPlayActive ||
                                      widget.isAwayPowerPlayActive)
                                  ? AppColors.warning
                                  : (widget.homeColor ?? cs.primary).withValues(
                                      alpha: 0.1,
                                    ),
                              shadows:
                                  (widget.isSpecialScoringActive ||
                                      widget.isHomePowerPlayActive ||
                                      widget.isAwayPowerPlayActive)
                                  ? [
                                      Shadow(
                                        color: AppColors.warning.withValues(
                                          alpha: 0.5,
                                        ),
                                        blurRadius: 8,
                                      ),
                                    ]
                                  : null,
                            ),
                            const SizedBox(width: 4),
                          ],
                          Text(
                            'QUARTER ${widget.currentQuarter}',
                            style: AppTypography.labelSmall.copyWith(
                              color:
                                  (widget.isSpecialScoringActive ||
                                      widget.isHomePowerPlayActive ||
                                      widget.isAwayPowerPlayActive)
                                  ? AppColors.warning
                                  : cs.onSurfaceVariant,
                              letterSpacing: 2,
                              fontWeight:
                                  (widget.isSpecialScoringActive ||
                                      widget.isHomePowerPlayActive ||
                                      widget.isAwayPowerPlayActive)
                                  ? FontWeight.w900
                                  : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.px2),
                      Text(
                        widget.matchTime,
                        style: AppTypography.headlineMedium.copyWith(
                          fontWeight: FontWeight.w900,
                          fontFeatures: const [
                            FontFeature.tabularFigures(),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.px2),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            widget.isFinished
                                ? (widget.isLastQuarter
                                      ? Icons.check_circle_outline_rounded
                                      : Icons.fast_forward_rounded)
                                : (widget.isTimerRunning
                                      ? Icons.pause_circle_outline_rounded
                                      : (widget.isAtStart
                                            ? Icons.play_arrow_rounded
                                            : Icons
                                                  .play_circle_outline_rounded)),
                            size: 10,
                            color: widget.isFinished
                                ? cs.primary
                                : (widget.isTimerRunning
                                      ? cs.error
                                      : AppColors.success),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            widget.isFinished
                                ? (widget.isLastQuarter ? 'FINISH' : 'NEXT QTR')
                                : (widget.isTimerRunning
                                      ? 'PAUSE'
                                      : (widget.isAtStart
                                            ? 'START'
                                            : 'RESUME')),
                            style: AppTypography.labelSmall.copyWith(
                              color: widget.isFinished
                                  ? cs.primary
                                  : (widget.isTimerRunning
                                        ? cs.error
                                        : AppColors.success),
                              fontSize: 8,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                GestureDetector(
                  onTap: widget.onPossessionTap,
                  behavior: HitTestBehavior.opaque,
                  child: _PossessionIndicator(
                    homeHasPossession: widget.homeHasPossession,
                    homeColor: widget.homeColor ?? cs.primary,
                    awayColor: widget.awayColor ?? cs.secondary,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _TeamZone(
              name: widget.awayTeamName,
              score: widget.awayScore,
              color: widget.awayColor ?? cs.outline,
              isHome: false,
              isPowerPlayActive: widget.isAwayPowerPlayActive,
              isNominatedMode:
                  widget.format == GameFormat.fiveAside &&
                  widget.fast5PowerPlayMode == Fast5PowerPlayMode.nominated,
              onPowerPlayToggle: widget.onAwayPowerPlayToggle,
              format: widget.format,
              isActiveRecording:
                  widget.isRecordingMode &&
                  !(widget.activeRecordingHome ?? true),
            ),
          ),
        ],
      ),
    );
  }
}

class _TeamZone extends StatelessWidget {
  const _TeamZone({
    required this.name,
    required this.score,
    required this.color,
    required this.isHome,
    required this.isPowerPlayActive,
    required this.isNominatedMode,
    required this.format,
    required this.isActiveRecording,
    this.onPowerPlayToggle,
  });

  final String name;
  final int score;
  final Color color;
  final bool isHome;
  final bool isPowerPlayActive;
  final bool isNominatedMode;
  final GameFormat format;
  final bool isActiveRecording;
  final VoidCallback? onPowerPlayToggle;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Opacity(
      opacity: isActiveRecording
          ? 1.0
          : (context
                        .findAncestorWidgetOfExactType<PremiumScoreboard>()
                        ?.isRecordingMode ??
                    false
                ? 0.6
                : 1.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _TeamAvatar(
            color: color,
            name: name,
            isRecording: isActiveRecording,
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                name.toUpperCase(),
                maxLines: 1,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.labelMedium.copyWith(
                  fontWeight: FontWeight.w900,
                  color: cs.onSurfaceVariant,
                  fontSize: 10,
                ),
              ),
              if (isPowerPlayActive && !isNominatedMode) ...[
                const SizedBox(width: 4),
                Icon(
                  format == GameFormat.fiveAside ? Icons.whatshot : Icons.bolt,
                  size: 12,
                  color: AppColors.warning,
                ),
              ],
            ],
          ),
          _AnimatedScore(score: score, color: cs.onSurface),
        ],
      ),
    );
  }
}

class _AnimatedScore extends StatelessWidget {
  const _AnimatedScore({required this.score, required this.color});

  final int score;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position:
                Tween<Offset>(
                  begin: const Offset(0, 0.2),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutBack,
                  ),
                ),
            child: child,
          ),
        );
      },
      child: Text(
        score.toString(),
        key: ValueKey<int>(score),
        style: AppTypography.displayLarge.copyWith(
          fontWeight: FontWeight.w900,
          color: color,
          height: 1,
        ),
      ),
    );
  }
}

class _TeamAvatar extends StatefulWidget {
  const _TeamAvatar({
    required this.color,
    required this.name,
    this.isRecording = false,
  });

  final Color color;
  final String name;
  final bool isRecording;

  @override
  State<_TeamAvatar> createState() => _TeamAvatarState();
}

class _TeamAvatarState extends State<_TeamAvatar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final initial = widget.name.isNotEmpty ? widget.name[0].toUpperCase() : '?';

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: cs.surface,
        shape: BoxShape.circle,
        border: Border.all(
          color: widget.color.withValues(
            alpha: widget.isRecording ? 1.0 : 0.4,
          ),
          width: 2,
        ),
      ),
      child: Center(
        child: Text(
          initial,
          style: AppTypography.labelLarge.copyWith(
            color: widget.color,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class _PossessionIndicator extends StatelessWidget {
  const _PossessionIndicator({
    required this.homeHasPossession,
    required this.homeColor,
    required this.awayColor,
  });

  final bool homeHasPossession;
  final Color homeColor;
  final Color awayColor;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final targetColor = homeHasPossession ? homeColor : awayColor;

    return Container(
      width: 64,
      height: 28,
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withValues(alpha: 0.1),
        borderRadius: AppRadius.brPill,
        border: Border.all(
          color: cs.outline.withValues(alpha: 0.05),
        ),
      ),
      child: AnimatedAlign(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
        alignment: homeHasPossession
            ? Alignment.centerLeft
            : Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: TweenAnimationBuilder<Color?>(
            duration: const Duration(milliseconds: 500),
            tween: ColorTween(end: targetColor),
            builder: (context, color, child) {
              final activeColor = color ?? targetColor;
              return Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: activeColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: activeColor.withValues(alpha: 0.2),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.sports_volleyball,
                  size: 14,
                  color: activeColor,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
