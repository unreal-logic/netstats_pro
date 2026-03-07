import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netstats_pro/domain/entities/team.dart';
import 'package:netstats_pro/presentation/games/bloc/setup_wizard_bloc.dart';
import 'package:netstats_pro/presentation/games/bloc/setup_wizard_event.dart';
import 'package:netstats_pro/presentation/games/bloc/setup_wizard_state.dart';
import 'package:netstats_pro/presentation/games/widgets/picker_bottom_sheet.dart';

class TeamsSetupStep extends StatelessWidget {
  const TeamsSetupStep({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SetupWizardBloc, SetupWizardState>(
      builder: (context, state) {
        final bloc = context.read<SetupWizardBloc>();
        final homeTeam = state.teams
            .where((t) => t.id == state.homeTeamId)
            .firstOrNull;
        final awayTeam = state.teams
            .where((t) => t.id == state.opponentTeamId)
            .firstOrNull;

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Stat Tracking Scope ──────────────────────────────────────
              _StatScopeToggle(
                trackBoth: state.trackBothTeams,
                onChanged: (val) => bloc.add(TrackBothTeamsToggled(value: val)),
              ),

              const SizedBox(height: 32),

              // ── Match Card with VS ───────────────────────────────────────
              _MatchCard(
                homeTeam: homeTeam,
                awayTeam: awayTeam,
                teams: state.teams,
                homeTeamId: state.homeTeamId,
                opponentTeamId: state.opponentTeamId,
                onHomeTap: () => _openTeamPicker(
                  context: context,
                  bloc: bloc,
                  teams: state.teams,
                  selectedId: state.homeTeamId,
                  isHomeTeam: true,
                ),
                onAwayTap: () => _openTeamPicker(
                  context: context,
                  bloc: bloc,
                  teams: state.teams,
                  selectedId: state.opponentTeamId,
                  isHomeTeam: false,
                ),
              ),

              const SizedBox(height: 24),

              // ── Tip ──────────────────────────────────────────────────────
              Center(
                child: Text(
                  'Manage teams & players in the Management section.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _openTeamPicker({
    required BuildContext context,
    required SetupWizardBloc bloc,
    required List<Team> teams,
    required int? selectedId,
    required bool isHomeTeam,
  }) {
    showPickerSheet<Team>(
      context: context,
      title: isHomeTeam ? 'Home Team' : 'Opponent',
      icon: Icons.group_outlined,
      items: teams,
      selectedId: selectedId,
      getLabel: (t) => t.name,
      getId: (t) => t.id,
      onSelected: (id) {
        final team = teams.firstWhere((t) => t.id == id);
        if (isHomeTeam) {
          bloc.add(HomeTeamNameChanged(team.name, teamId: id));
        } else {
          bloc.add(OpponentNameChanged(team.name, teamId: id));
        }
      },
      onQuickCreate: (name, color) => bloc.add(
        QuickCreateTeam(name: name, isHomeTeam: isHomeTeam, color: color),
      ),
      colorOptions: const [
        Color(0xFF1A237E), // Navy
        Color(0xFFFFD700), // Gold
        Color(0xFF800000), // Maroon
        Color(0xFF2E7D32), // Green
        Color(0xFF03A9F4), // Sky Blue
        Color(0xFFD32F2F), // Red
        Color(0xFF008080), // Teal
        Color(0xFFFF9800), // Orange
        Color(0xFF212121), // Black
        Color(0xFF7B1FA2), // Purple
      ],
      getLeading: (team, {required isSelected}) {
        final teamColor =
            team.color ??
            (isHomeTeam
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.secondary);
        return CircleAvatar(
          radius: 16,
          backgroundColor: teamColor.withValues(alpha: 0.15),
          child: Text(
            team.name.substring(0, 1).toUpperCase(),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: teamColor,
            ),
          ),
        );
      },
      emptyIcon: Icons.group_outlined,
      emptyTitle: 'No Teams Yet',
      emptySubtitle: 'Create your first team to get started.',
      createLabel: 'New Team',
    );
  }
}

// ─── Stat scope toggle ──────────────────────────────────────────────────

class _StatScopeToggle extends StatelessWidget {
  const _StatScopeToggle({
    required this.trackBoth,
    required this.onChanged,
  });

  final bool trackBoth;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'STAT TRACKING SCOPE',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
            color: Colors.blueGrey,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: cs.surfaceContainerHighest.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: cs.outline.withValues(alpha: 0.5)),
          ),
          padding: const EdgeInsets.all(4),
          child: Row(
            children: [
              _ScopeOption(
                label: 'Your Team Only',
                icon: Icons.sports_outlined,
                isSelected: !trackBoth,
                onTap: () => onChanged(false),
              ),
              _ScopeOption(
                label: 'Both Teams',
                icon: Icons.groups_outlined,
                isSelected: trackBoth,
                onTap: () => onChanged(true),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            trackBoth
                ? 'You will track statistics for both teams.'
                : 'You will only track statistics for your home team.',
            style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant),
          ),
        ),
      ],
    );
  }
}

class _ScopeOption extends StatelessWidget {
  const _ScopeOption({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          unawaited(HapticFeedback.selectionClick());
          onTap();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? cs.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: cs.primary.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected ? cs.onPrimary : cs.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label.toUpperCase(),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.4,
                    color: isSelected ? cs.onPrimary : cs.onSurfaceVariant,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Match card with VS badge ──────────────────────────────────────────

class _MatchCard extends StatelessWidget {
  const _MatchCard({
    required this.homeTeam,
    required this.awayTeam,
    required this.teams,
    required this.homeTeamId,
    required this.opponentTeamId,
    required this.onHomeTap,
    required this.onAwayTap,
  });

  final Team? homeTeam;
  final Team? awayTeam;
  final List<Team> teams;
  final int? homeTeamId;
  final int? opponentTeamId;
  final VoidCallback onHomeTap;
  final VoidCallback onAwayTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            cs.primaryContainer.withValues(alpha: 0.25),
            cs.secondaryContainer.withValues(alpha: 0.15),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cs.outline.withValues(alpha: 0.2)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Home team
          _TeamSlot(
            label: 'HOME',
            team: homeTeam,
            accentColor: cs.primary,
            onTap: onHomeTap,
          ),

          // VS badge
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              children: [
                Expanded(
                  child: Divider(color: cs.outline.withValues(alpha: 0.3)),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: _VsBadge(),
                ),
                Expanded(
                  child: Divider(color: cs.outline.withValues(alpha: 0.3)),
                ),
              ],
            ),
          ),

          // Away team
          _TeamSlot(
            label: 'OPPONENT',
            team: awayTeam,
            accentColor: cs.secondary,
            onTap: onAwayTap,
          ),
        ],
      ),
    );
  }
}

class _TeamSlot extends StatelessWidget {
  const _TeamSlot({
    required this.label,
    required this.team,
    required this.accentColor,
    required this.onTap,
  });

  final String label;
  final Team? team;
  final Color accentColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final hasTeam = team != null;
    final initial = hasTeam ? team!.name.substring(0, 1).toUpperCase() : '?';
    final teamColor = teamColorFromSelection;

    return GestureDetector(
      onTap: () {
        unawaited(HapticFeedback.selectionClick());
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: hasTeam
              ? teamColor.withValues(alpha: 0.08)
              : cs.surfaceContainerHighest.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: hasTeam
                ? teamColor.withValues(alpha: 0.5)
                : cs.outline.withValues(alpha: 0.3),
            width: hasTeam ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            // Team avatar
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: hasTeam
                    ? teamColor.withValues(alpha: 0.15)
                    : cs.surfaceContainerHighest.withValues(alpha: 0.5),
                shape: BoxShape.circle,
                border: Border.all(
                  color: hasTeam
                      ? teamColor.withValues(alpha: 0.6)
                      : cs.outline.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: Center(
                child: team?.avatarUrl != null
                    ? ClipOval(
                        child: Image.network(
                          team!.avatarUrl!,
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              _buildInitialPlaceholder(
                                initial,
                                teamColor,
                                cs,
                                hasTeam,
                              ),
                        ),
                      )
                    : _buildInitialPlaceholder(initial, teamColor, cs, hasTeam),
              ),
            ),

            const SizedBox(width: 14),

            // Name and label
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                      color: hasTeam ? teamColor : cs.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    hasTeam ? team!.name : 'Tap to select team',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: hasTeam ? FontWeight.w700 : FontWeight.w400,
                      color: hasTeam ? cs.onSurface : cs.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            // Action icon
            Icon(
              hasTeam ? Icons.edit_outlined : Icons.chevron_right,
              color: hasTeam ? teamColor : cs.onSurfaceVariant,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Color get teamColorFromSelection => team?.color ?? accentColor;

  Widget _buildInitialPlaceholder(
    String initial,
    Color teamColor,
    ColorScheme cs,
    bool hasTeam,
  ) {
    return Text(
      initial,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w900,
        color: hasTeam ? teamColor : cs.onSurfaceVariant,
      ),
    );
  }
}

class _VsBadge extends StatelessWidget {
  const _VsBadge();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [cs.primary, cs.secondary],
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: cs.primary.withValues(alpha: 0.35),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Text(
          'VS',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w900,
            color: cs.onPrimary,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}
