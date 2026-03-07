import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netstats_pro/domain/entities/player.dart';
import 'package:netstats_pro/domain/repositories/player_repository.dart';
import 'package:netstats_pro/injection_container.dart';
import 'package:netstats_pro/presentation/games/bloc/setup_wizard_bloc.dart';
import 'package:netstats_pro/presentation/games/bloc/setup_wizard_event.dart';
import 'package:netstats_pro/presentation/games/bloc/setup_wizard_state.dart';

class LineupSelectionStep extends StatelessWidget {
  const LineupSelectionStep({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SetupWizardBloc, SetupWizardState>(
      builder: (context, state) {
        // When tracking both teams, show two lineup sections with a tab switch
        if (state.trackBothTeams) {
          return _DualTeamLineup(state: state);
        }
        return _SingleTeamLineup(
          state: state,
          lineup: state.lineup,
          teamId: state.homeTeamId,
          teamName: state.homeTeamName,
          isHomeTeam: true,
        );
      },
    );
  }
}

// ─── Single team lineup ──────────────────────────────────────────────────

class _SingleTeamLineup extends StatelessWidget {
  const _SingleTeamLineup({
    required this.state,
    required this.lineup,
    required this.teamId,
    required this.teamName,
    required this.isHomeTeam,
  });

  final SetupWizardState state;
  final Map<NetballPosition, Player?> lineup;
  final int? teamId;
  final String teamName;
  final bool isHomeTeam;

  @override
  Widget build(BuildContext context) {
    final positions = state.format.positions;
    final assignedPlayers = lineup.values.whereType<Player>().toList();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'STARTING LINEUP',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                        color: Colors.blueGrey,
                      ),
                    ),
                    Text(
                      state.format.displayName,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
              FilledButton.tonalIcon(
                onPressed: () => context.read<SetupWizardBloc>().add(
                  AutoAssignLineup(isHomeTeam: isHomeTeam),
                ),
                icon: const Icon(Icons.auto_awesome, size: 16),
                label: const Text(
                  'AUTO-ASSIGN',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Progress
          _LineupProgress(
            filled: assignedPlayers.length,
            total: positions.length,
          ),

          const SizedBox(height: 20),

          // Position slots
          ...positions.map((pos) {
            final player = lineup[pos];
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _PositionSlot(
                position: pos,
                assignedPlayer: player,
                onTap: () => _showPlayerPicker(
                  context: context,
                  position: pos,
                  assignedPlayers: assignedPlayers,
                  currentPlayer: player,
                  teamId: teamId,
                  isHomeTeam: isHomeTeam,
                ),
                teamColor: isHomeTeam
                    ? state.homeTeamColor
                    : state.opponentTeamColor,
                onClear: player != null
                    ? () {
                        if (isHomeTeam) {
                          context.read<SetupWizardBloc>().add(
                            PositionAssigned(pos, null),
                          );
                        } else {
                          context.read<SetupWizardBloc>().add(
                            OpponentPositionAssigned(pos, null),
                          );
                        }
                      }
                    : null,
              ),
            );
          }),
        ],
      ),
    );
  }

  void _showPlayerPicker({
    required BuildContext context,
    required NetballPosition position,
    required List<Player> assignedPlayers,
    required Player? currentPlayer,
    required int? teamId,
    required bool isHomeTeam,
  }) {
    final bloc = context.read<SetupWizardBloc>();

    unawaited(
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        backgroundColor: Colors.transparent,
        builder: (_) => BlocProvider.value(
          value: bloc,
          child: _PlayerPickerSheet(
            position: position,
            assignedPlayers: assignedPlayers,
            currentPlayer: currentPlayer,
            filterTeamId: teamId,
            isHomeTeam: isHomeTeam,
            teamColor: isHomeTeam
                ? bloc.state.homeTeamColor
                : bloc.state.opponentTeamColor,
            onSelected: (player) {
              unawaited(HapticFeedback.selectionClick());
              if (isHomeTeam) {
                bloc.add(PositionAssigned(position, player));
              } else {
                bloc.add(OpponentPositionAssigned(position, player));
              }
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
    );
  }
}

// ─── Dual team lineup (tabbed) ──────────────────────────────────────────

class _DualTeamLineup extends StatefulWidget {
  const _DualTeamLineup({required this.state});

  final SetupWizardState state;

  @override
  State<_DualTeamLineup> createState() => _DualTeamLineupState();
}

class _DualTeamLineupState extends State<_DualTeamLineup>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {}); // Trigger rebuild to update indicator color
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final state = widget.state;

    return Column(
      children: [
        // Tab bar switcher
        Container(
          decoration: BoxDecoration(
            color: cs.surfaceContainerHighest.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: cs.outline.withValues(alpha: 0.4)),
          ),
          padding: const EdgeInsets.all(4),
          child: TabBar(
            controller: _tabController,
            indicator: BoxDecoration(
              color: _tabController.index == 0
                  ? (state.homeTeamColor ?? cs.primary)
                  : (state.opponentTeamColor ?? cs.secondary),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color:
                      (_tabController.index == 0
                              ? (state.homeTeamColor ?? cs.primary)
                              : (state.opponentTeamColor ?? cs.secondary))
                          .withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: Colors.transparent,
            labelColor: Colors.white,
            unselectedLabelColor: cs.onSurfaceVariant,
            labelStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
            tabs: [
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                      backgroundImage: state.homeTeamAvatar != null
                          ? NetworkImage(state.homeTeamAvatar!)
                          : null,
                      child: state.homeTeamAvatar == null
                          ? Text(
                              (state.homeTeamName.isNotEmpty
                                      ? state.homeTeamName[0]
                                      : 'H')
                                  .toUpperCase(),
                              style: const TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        state.homeTeamName.isEmpty
                            ? 'Home'
                            : state.homeTeamName,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                      backgroundImage: state.opponentTeamAvatar != null
                          ? NetworkImage(state.opponentTeamAvatar!)
                          : null,
                      child: state.opponentTeamAvatar == null
                          ? Text(
                              (state.opponentName.isNotEmpty
                                      ? state.opponentName[0]
                                      : 'O')
                                  .toUpperCase(),
                              style: const TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        state.opponentName.isEmpty
                            ? 'Opponent'
                            : state.opponentName,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _SingleTeamLineup(
                state: state,
                lineup: state.lineup,
                teamId: state.homeTeamId,
                teamName: state.homeTeamName,
                isHomeTeam: true,
              ),
              _SingleTeamLineup(
                state: state,
                lineup: state.opponentLineup,
                teamId: state.opponentTeamId,
                teamName: state.opponentName,
                isHomeTeam: false,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Progress bar ────────────────────────────────────────────────────────

class _LineupProgress extends StatelessWidget {
  const _LineupProgress({required this.filled, required this.total});

  final int filled;
  final int total;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final pct = total == 0 ? 0.0 : filled / total;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$filled / $total players assigned',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: cs.onSurfaceVariant,
              ),
            ),
            if (filled == total && total > 0)
              Row(
                children: [
                  Icon(Icons.check_circle, size: 14, color: cs.primary),
                  const SizedBox(width: 4),
                  Text(
                    'Complete',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: cs.primary,
                    ),
                  ),
                ],
              ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: pct,
            minHeight: 6,
            backgroundColor: cs.surfaceContainerHighest,
            color: cs.primary,
          ),
        ),
      ],
    );
  }
}

// ─── Position slot card ──────────────────────────────────────────────────

class _PositionSlot extends StatelessWidget {
  const _PositionSlot({
    required this.position,
    required this.onTap,
    this.assignedPlayer,
    this.onClear,
    this.teamColor,
  });

  final NetballPosition position;
  final Player? assignedPlayer;
  final VoidCallback onTap;
  final VoidCallback? onClear;
  final Color? teamColor;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final hasPlayer = assignedPlayer != null;

    return GestureDetector(
      onTap: () {
        unawaited(HapticFeedback.selectionClick());
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: hasPlayer
              ? (teamColor ?? cs.primary).withValues(alpha: 0.12)
              : cs.surfaceContainerHighest.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: hasPlayer
                ? (teamColor ?? cs.primary).withValues(alpha: 0.45)
                : cs.outline.withValues(alpha: 0.3),
            width: hasPlayer ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            _PositionBib(
              bib: position.bib,
              isAssigned: hasPlayer,
              teamColor: teamColor,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hasPlayer
                        ? assignedPlayer!.fullName
                        : 'Tap to assign player',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: hasPlayer ? FontWeight.w700 : FontWeight.w400,
                      color: hasPlayer ? cs.onSurface : cs.onSurfaceVariant,
                    ),
                  ),
                  if (hasPlayer)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        '#${assignedPlayer!.primaryNumber ?? "?"}  •  '
                        '${assignedPlayer!.gender.displayName}  •  '
                        '${assignedPlayer!.preferredPositions.map(
                          (p) => p.bib.toUpperCase(),
                        ).join(', ')}',
                        style: TextStyle(
                          fontSize: 11,
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (hasPlayer && onClear != null)
              GestureDetector(
                onTap: () {
                  unawaited(HapticFeedback.lightImpact());
                  onClear!();
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Icon(
                    Icons.close,
                    size: 18,
                    color: cs.onSurfaceVariant.withValues(alpha: 0.7),
                  ),
                ),
              )
            else
              Icon(
                hasPlayer ? Icons.edit_outlined : Icons.chevron_right,
                size: 20,
                color: hasPlayer
                    ? (teamColor ?? cs.primary)
                    : cs.onSurfaceVariant,
              ),
          ],
        ),
      ),
    );
  }
}

// ─── Bib badge ──────────────────────────────────────────────────────────

class _PositionBib extends StatelessWidget {
  const _PositionBib({
    required this.bib,
    required this.isAssigned,
    this.teamColor,
  });

  final String bib;
  final bool isAssigned;
  final Color? teamColor;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: isAssigned
            ? (teamColor ?? cs.primary)
            : cs.surfaceContainerHighest,
        shape: BoxShape.circle,
        boxShadow: isAssigned
            ? [
                BoxShadow(
                  color: (teamColor ?? cs.primary).withValues(alpha: 0.35),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Center(
        child: Text(
          bib.toUpperCase(),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w900,
            color: isAssigned ? cs.onPrimary : cs.onSurfaceVariant,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}

// ─── Player picker bottom sheet ──────────────────────────────────────────

class _PlayerPickerSheet extends StatefulWidget {
  const _PlayerPickerSheet({
    required this.position,
    required this.assignedPlayers,
    required this.onSelected,
    required this.isHomeTeam,
    this.currentPlayer,
    this.filterTeamId,
    this.teamColor,
  });

  final NetballPosition position;
  final List<Player> assignedPlayers;
  final Player? currentPlayer;
  final int? filterTeamId;
  final bool isHomeTeam;
  final Color? teamColor;
  final void Function(Player player) onSelected;

  @override
  State<_PlayerPickerSheet> createState() => _PlayerPickerSheetState();
}

class _PlayerPickerSheetState extends State<_PlayerPickerSheet> {
  final _searchController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _heightController = TextEditingController();
  Gender _gender = Gender.female;
  String _query = '';
  bool _showCreateForm = false;

  @override
  void dispose() {
    _searchController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  void _submitCreate(SetupWizardBloc bloc) {
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    if (firstName.isEmpty) return;

    final heightText = _heightController.text.trim();
    final heightCm = double.tryParse(heightText);

    unawaited(HapticFeedback.mediumImpact());
    bloc.add(
      QuickCreatePlayer(
        firstName: firstName,
        lastName: lastName,
        position: widget.position,
        isHomeTeam: widget.isHomeTeam,
        gender: _gender,
        heightCm: heightCm,
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final bloc = context.read<SetupWizardBloc>();

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: cs.onSurface.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: widget.teamColor ?? cs.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: (widget.teamColor ?? cs.primary).withValues(
                          alpha: 0.35,
                        ),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      widget.position.bib.toUpperCase(),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        color:
                            (widget.teamColor ?? cs.primary)
                                    .computeLuminance() >
                                0.5
                            ? Colors.black87
                            : Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Player',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          if (_showCreateForm) ...[
            // ── Quick create player form ─────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'NEW PLAYER',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _firstNameController,
                          autofocus: true,
                          textCapitalization: TextCapitalization.words,
                          decoration: const InputDecoration(
                            hintText: 'First name',
                            prefixIcon: Icon(Icons.person_outline),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _lastNameController,
                          textCapitalization: TextCapitalization.words,
                          decoration: const InputDecoration(
                            hintText: 'Last name',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: SegmentedButton<Gender>(
                          segments: Gender.values
                              .map(
                                (g) => ButtonSegment(
                                  value: g,
                                  label: Text(
                                    g.displayName,
                                    style: const TextStyle(fontSize: 11),
                                  ),
                                ),
                              )
                              .toList(),
                          selected: {_gender},
                          onSelectionChanged: (set) =>
                              setState(() => _gender = set.first),
                          showSelectedIcon: false,
                          style: SegmentedButton.styleFrom(
                            visualDensity: VisualDensity.compact,
                            padding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 2,
                        child: TextField(
                          controller: _heightController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          onSubmitted: (_) => _submitCreate(bloc),
                          decoration: const InputDecoration(
                            hintText: 'Height (cm)',
                            prefixIcon: Icon(Icons.height, size: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'Will be added to '
                      '${widget.isHomeTeam ? "home" : "opponent"} team '
                      'roster and auto-assigned to '
                      '${widget.position.name.toUpperCase()}.',
                      style: TextStyle(
                        fontSize: 12,
                        color: cs.onSurfaceVariant,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () =>
                              setState(() => _showCreateForm = false),
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () => _submitCreate(bloc),
                          icon: const Icon(Icons.check, size: 18),
                          label: const Text('Save & Assign'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ] else ...[
            // ── Search bar ───────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: TextField(
                controller: _searchController,
                onChanged: (v) => setState(() => _query = v),
                decoration: InputDecoration(
                  hintText: 'Search players...',
                  prefixIcon: const Icon(Icons.search, size: 20),
                  suffixIcon: _query.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () => setState(() {
                            _query = '';
                            _searchController.clear();
                          }),
                        )
                      : null,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  isDense: true,
                ),
              ),
            ),

            // ── Player list ──────────────────────────────────────────────
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.42,
              ),
              child: StreamBuilder<List<Player>>(
                stream: sl<PlayerRepository>().watchAllPlayers(),
                builder: (ctx, snapshot) {
                  if (!snapshot.hasData) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 32),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  final q = _query.toLowerCase();
                  // Filter to the selected team (or all if no team chosen)
                  final teamFiltered = widget.filterTeamId != null
                      ? snapshot.data!
                            .where((p) => p.teamId == widget.filterTeamId)
                            .toList()
                      : snapshot.data!;

                  final filtered = q.isEmpty
                      ? teamFiltered
                      : teamFiltered
                            .where(
                              (p) =>
                                  p.fullName.toLowerCase().contains(q) ||
                                  p.preferredPositions.any(
                                    (pos) => pos.bib.toLowerCase().contains(q),
                                  ),
                            )
                            .toList();

                  if (teamFiltered.isEmpty) {
                    return _EmptyPlayerState(
                      hasTeam: widget.filterTeamId != null,
                    );
                  }

                  if (filtered.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Column(
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 36,
                            color: cs.onSurfaceVariant.withValues(alpha: 0.5),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'No results for "$_query"',
                            style: TextStyle(color: cs.onSurfaceVariant),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    shrinkWrap: true,
                    itemCount: filtered.length,
                    separatorBuilder: (_, _) =>
                        const Divider(height: 1, indent: 72),
                    itemBuilder: (_, i) {
                      final player = filtered[i];
                      final isAlreadyAssigned = widget.assignedPlayers.any(
                        (p) => p.id == player.id,
                      );
                      final isCurrent = widget.currentPlayer?.id == player.id;
                      final initial = player.firstName.isNotEmpty
                          ? player.firstName[0]
                          : '?';

                      return ListTile(
                        enabled: !isAlreadyAssigned || isCurrent,
                        leading: CircleAvatar(
                          backgroundColor: isCurrent
                              ? cs.primary
                              : isAlreadyAssigned
                              ? cs.surfaceContainerHighest
                              : cs.primaryContainer.withValues(alpha: 0.5),
                          backgroundImage: player.avatarUrl != null
                              ? NetworkImage(player.avatarUrl!)
                              : null,
                          child: player.avatarUrl == null
                              ? Text(
                                  initial,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: isCurrent
                                        ? cs.onPrimary
                                        : isAlreadyAssigned
                                        ? cs.onSurfaceVariant
                                        : cs.primary,
                                  ),
                                )
                              : null,
                        ),
                        title: Row(
                          children: [
                            Text(
                              player.fullName,
                              style: TextStyle(
                                fontWeight: isCurrent
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: isAlreadyAssigned && !isCurrent
                                    ? cs.onSurfaceVariant
                                    : cs.onSurface,
                              ),
                            ),
                            if (player.preferredPositions.isNotEmpty) ...[
                              const SizedBox(width: 8),
                              Padding(
                                padding: const EdgeInsets.only(top: 1),
                                child: Wrap(
                                  spacing: 4,
                                  children: player.preferredPositions.map((
                                    pos,
                                  ) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: (widget.teamColor ?? cs.primary)
                                            .withValues(
                                              alpha: 0.1,
                                            ),
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(
                                          color:
                                              (widget.teamColor ?? cs.primary)
                                                  .withValues(
                                                    alpha: 0.2,
                                                  ),
                                        ),
                                      ),
                                      child: Text(
                                        pos.bib.toUpperCase(),
                                        style: TextStyle(
                                          fontSize:
                                              9, // Slightly smaller for inline
                                          fontWeight: FontWeight.w900,
                                          color: widget.teamColor ?? cs.primary,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ],
                        ),
                        subtitle: Text(
                          [
                            player.gender.displayName,
                            if (player.heightCm != null)
                              '${player.heightCm!.toStringAsFixed(0)}cm',
                          ].join('  •  '),
                          style: TextStyle(
                            fontSize: 11,
                            color: cs.onSurfaceVariant.withValues(alpha: 0.8),
                          ),
                        ),
                        trailing: isCurrent
                            ? Icon(Icons.check_circle, color: cs.primary)
                            : isAlreadyAssigned
                            ? Tooltip(
                                message: 'Already assigned',
                                child: Icon(
                                  Icons.block,
                                  size: 18,
                                  color: cs.onSurfaceVariant.withValues(
                                    alpha: 0.4,
                                  ),
                                ),
                              )
                            : null,
                        onTap: isAlreadyAssigned && !isCurrent
                            ? null
                            : () => widget.onSelected(player),
                      );
                    },
                  );
                },
              ),
            ),

            // ── Add new player footer ────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: OutlinedButton.icon(
                onPressed: () => setState(() => _showCreateForm = true),
                icon: const Icon(Icons.person_add_outlined, size: 18),
                label: const Text('+ New Player'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(44),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Empty player state ──────────────────────────────────────────────────

class _EmptyPlayerState extends StatelessWidget {
  const _EmptyPlayerState({this.hasTeam = false});

  final bool hasTeam;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: cs.primaryContainer.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.person_add_outlined, size: 36, color: cs.primary),
          ),
          const SizedBox(height: 16),
          Text(
            hasTeam ? 'No Players on This Team' : 'No Players in Roster',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            hasTeam
                ? 'Use the "+ New Player" button below to create a player '
                      'and add them to this team.'
                : 'Add players to your team in the Management section, '
                      'or use the quick-create below.',
            textAlign: TextAlign.center,
            style: TextStyle(color: cs.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
