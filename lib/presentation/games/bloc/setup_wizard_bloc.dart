import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netstats_pro/domain/entities/competition.dart';
import 'package:netstats_pro/domain/entities/game.dart';
import 'package:netstats_pro/domain/entities/player.dart';
import 'package:netstats_pro/domain/entities/team.dart';
import 'package:netstats_pro/domain/entities/venue.dart';
import 'package:netstats_pro/domain/repositories/competition_repository.dart';
import 'package:netstats_pro/domain/repositories/game_repository.dart';
import 'package:netstats_pro/domain/repositories/player_repository.dart';
import 'package:netstats_pro/domain/repositories/team_repository.dart';
import 'package:netstats_pro/domain/repositories/venue_repository.dart';
import 'package:netstats_pro/presentation/games/bloc/setup_wizard_event.dart';
import 'package:netstats_pro/presentation/games/bloc/setup_wizard_state.dart';

import 'package:rxdart/rxdart.dart';

class SetupWizardBloc extends Bloc<SetupWizardEvent, SetupWizardState> {
  SetupWizardBloc({
    required GameRepository gameRepository,
    required PlayerRepository playerRepository,
    required CompetitionRepository competitionRepository,
    required VenueRepository venueRepository,
    required TeamRepository teamRepository,
  }) : _gameRepository = gameRepository,
       _playerRepository = playerRepository,
       _competitionRepository = competitionRepository,
       _venueRepository = venueRepository,
       _teamRepository = teamRepository,
       super(SetupWizardState()) {
    on<LoadSetupData>(_onLoadSetupData);
    on<StepChanged>(_onStepChanged);
    on<OpponentNameChanged>(_onOpponentNameChanged);
    on<HomeTeamNameChanged>(_onHomeTeamNameChanged);
    on<CompetitionSelected>(_onCompetitionSelected);
    on<VenueSelected>(_onVenueSelected);
    on<ScheduledAtChanged>(_onScheduledAtChanged);
    on<FormatChanged>(_onFormatChanged);
    on<TrackingModeChanged>(_onTrackingModeChanged);
    on<PositionAssigned>(_onPositionAssigned);
    on<AutoAssignLineup>(_onAutoAssignLineup);
    on<FirstCentrePassToggled>(_onFirstCentrePassToggled);
    on<IsSuperShotToggled>(_onIsSuperShotToggled);
    on<QuickCreateCompetition>(_onQuickCreateCompetition);
    on<QuickCreateVenue>(_onQuickCreateVenue);
    on<QuickCreateTeam>(_onQuickCreateTeam);
    on<TrackBothTeamsToggled>(_onTrackBothTeamsToggled);
    on<OpponentPositionAssigned>(_onOpponentPositionAssigned);
    on<QuickCreatePlayer>(_onQuickCreatePlayer);
    on<QuarterDurationChanged>(_onQuarterDurationChanged);
    on<SetupSubmitted>(_onSetupSubmitted);
  }
  final GameRepository _gameRepository;
  final PlayerRepository _playerRepository;
  final CompetitionRepository _competitionRepository;
  final VenueRepository _venueRepository;
  final TeamRepository _teamRepository;

  Future<void> _onLoadSetupData(
    LoadSetupData event,
    Emitter<SetupWizardState> emit,
  ) async {
    await emit.forEach(
      CombineLatestStream.combine3(
        _competitionRepository.watchCompetitions(),
        _venueRepository.watchVenues(),
        _teamRepository.watchAllTeams(),
        (comps, venues, teams) => (comps, venues, teams),
      ),
      onData: (data) {
        return state.copyWith(
          competitions: data.$1,
          venues: data.$2,
          teams: data.$3,
        );
      },
      onError: (e, stack) => state.copyWith(
        status: SetupWizardStatus.failure,
        errorMessage: 'Failed to watch setup data: $e',
      ),
    );
  }

  void _onStepChanged(StepChanged event, Emitter<SetupWizardState> emit) {
    emit(state.copyWith(currentStep: event.step));
  }

  void _onOpponentNameChanged(
    OpponentNameChanged event,
    Emitter<SetupWizardState> emit,
  ) {
    emit(
      state.copyWith(opponentName: event.name, opponentTeamId: event.teamId),
    );
  }

  void _onHomeTeamNameChanged(
    HomeTeamNameChanged event,
    Emitter<SetupWizardState> emit,
  ) {
    emit(state.copyWith(homeTeamName: event.name, homeTeamId: event.teamId));
  }

  void _onCompetitionSelected(
    CompetitionSelected event,
    Emitter<SetupWizardState> emit,
  ) {
    emit(state.copyWith(competitionId: event.id));
  }

  void _onVenueSelected(
    VenueSelected event,
    Emitter<SetupWizardState> emit,
  ) {
    emit(state.copyWith(venueId: event.id));
  }

  void _onScheduledAtChanged(
    ScheduledAtChanged event,
    Emitter<SetupWizardState> emit,
  ) {
    emit(state.copyWith(scheduledAt: event.date));
  }

  void _onFormatChanged(
    FormatChanged event,
    Emitter<SetupWizardState> emit,
  ) {
    // Reset lineup if format changes as positions differ
    emit(state.copyWith(format: event.format, lineup: {}));
  }

  void _onTrackingModeChanged(
    TrackingModeChanged event,
    Emitter<SetupWizardState> emit,
  ) {
    emit(state.copyWith(trackingMode: event.mode));
  }

  Future<void> _onQuickCreateCompetition(
    QuickCreateCompetition event,
    Emitter<SetupWizardState> emit,
  ) async {
    try {
      final newComp = Competition(
        id: 0,
        name: event.name.trim(),
        createdAt: DateTime.now(),
      );
      await _competitionRepository.saveCompetition(newComp);
      // The watchCompetitions stream will auto-update state.competitions.
      // Fetch the list directly to find and auto-select the new item.
      final competitions = await _competitionRepository.getCompetitions();
      final created = competitions.lastWhere(
        (c) => c.name == event.name.trim(),
        orElse: () => competitions.last,
      );
      emit(state.copyWith(competitionId: created.id));
    } on Object catch (e) {
      emit(
        state.copyWith(
          status: SetupWizardStatus.failure,
          errorMessage: 'Failed to create competition: $e',
        ),
      );
    }
  }

  Future<void> _onQuickCreateVenue(
    QuickCreateVenue event,
    Emitter<SetupWizardState> emit,
  ) async {
    try {
      final newVenue = Venue(
        id: 0,
        name: event.name.trim(),
        createdAt: DateTime.now(),
      );
      await _venueRepository.saveVenue(newVenue);
      final venues = await _venueRepository.getVenues();
      final created = venues.lastWhere(
        (v) => v.name == event.name.trim(),
        orElse: () => venues.last,
      );
      emit(state.copyWith(venueId: created.id));
    } on Object catch (e) {
      emit(
        state.copyWith(
          status: SetupWizardStatus.failure,
          errorMessage: 'Failed to create venue: $e',
        ),
      );
    }
  }

  Future<void> _onQuickCreateTeam(
    QuickCreateTeam event,
    Emitter<SetupWizardState> emit,
  ) async {
    try {
      final newTeam = Team(
        id: 0,
        name: event.name.trim(),
        color: event.color,
        createdAt: DateTime.now(),
      );
      // createTeam returns the new row's integer ID directly
      final newId = await _teamRepository.createTeam(newTeam);
      if (event.isHomeTeam) {
        emit(
          state.copyWith(homeTeamId: newId, homeTeamName: event.name.trim()),
        );
      } else {
        emit(
          state.copyWith(
            opponentTeamId: newId,
            opponentName: event.name.trim(),
          ),
        );
      }
    } on Object catch (e) {
      emit(
        state.copyWith(
          status: SetupWizardStatus.failure,
          errorMessage: 'Failed to create team: $e',
        ),
      );
    }
  }

  void _onTrackBothTeamsToggled(
    TrackBothTeamsToggled event,
    Emitter<SetupWizardState> emit,
  ) {
    emit(state.copyWith(trackBothTeams: event.value));
  }

  void _onOpponentPositionAssigned(
    OpponentPositionAssigned event,
    Emitter<SetupWizardState> emit,
  ) {
    final newLineup = Map<NetballPosition, Player?>.from(state.opponentLineup);
    newLineup[event.position] = event.player;
    emit(state.copyWith(opponentLineup: newLineup));
  }

  Future<void> _onQuickCreatePlayer(
    QuickCreatePlayer event,
    Emitter<SetupWizardState> emit,
  ) async {
    try {
      final teamId = event.isHomeTeam ? state.homeTeamId : state.opponentTeamId;
      final newPlayer = Player(
        id: 0,
        firstName: event.firstName.trim(),
        lastName: event.lastName.trim(),
        preferredPositions: [event.position],
        teamId: teamId,
        gender: event.gender,
        heightCm: event.heightCm,
        createdAt: DateTime.now(),
      );
      final newId = await _playerRepository.createPlayer(newPlayer);
      final created = Player(
        id: newId,
        firstName: event.firstName.trim(),
        lastName: event.lastName.trim(),
        preferredPositions: [event.position],
        teamId: teamId,
        gender: event.gender,
        heightCm: event.heightCm,
        createdAt: newPlayer.createdAt,
      );
      // Auto-assign the newly created player to the requested position
      if (event.isHomeTeam) {
        final newLineup = Map<NetballPosition, Player?>.from(state.lineup);
        newLineup[event.position] = created;
        emit(state.copyWith(lineup: newLineup));
      } else {
        final newLineup = Map<NetballPosition, Player?>.from(
          state.opponentLineup,
        );
        newLineup[event.position] = created;
        emit(state.copyWith(opponentLineup: newLineup));
      }
    } on Object catch (e) {
      emit(
        state.copyWith(
          status: SetupWizardStatus.failure,
          errorMessage: 'Failed to create player: $e',
        ),
      );
    }
  }

  void _onPositionAssigned(
    PositionAssigned event,
    Emitter<SetupWizardState> emit,
  ) {
    final newLineup = Map<NetballPosition, Player?>.from(state.lineup);
    newLineup[event.position] = event.player;
    emit(state.copyWith(lineup: newLineup));
  }

  Future<void> _onAutoAssignLineup(
    AutoAssignLineup event,
    Emitter<SetupWizardState> emit,
  ) async {
    final allPlayers = await _playerRepository.getAllPlayers();
    final requiredPositions = state.format.positions;

    // Filter to the relevant team's roster if a team is selected
    final teamId = event.isHomeTeam ? state.homeTeamId : state.opponentTeamId;
    final teamPlayers = teamId != null
        ? allPlayers.where((p) => p.teamId == teamId).toList()
        : allPlayers;

    final currentLineup = event.isHomeTeam
        ? Map<NetballPosition, Player?>.from(state.lineup)
        : Map<NetballPosition, Player?>.from(state.opponentLineup);

    final assignedPlayerIds = currentLineup.values
        .whereType<Player>()
        .map((p) => p.id)
        .toSet();

    for (final pos in requiredPositions) {
      // Skip if already manually assigned
      if (currentLineup[pos] != null) continue;

      // Find an unassigned player who prefers this position
      try {
        final matchingPlayer = teamPlayers.firstWhere(
          (p) =>
              !assignedPlayerIds.contains(p.id) &&
              p.preferredPositions.contains(pos),
        );
        currentLineup[pos] = matchingPlayer;
        assignedPlayerIds.add(matchingPlayer.id);
      } on Object catch (_) {
        // No matching unassigned player found for this position, leave empty
      }
    }

    if (event.isHomeTeam) {
      emit(state.copyWith(lineup: currentLineup));
    } else {
      emit(state.copyWith(opponentLineup: currentLineup));
    }
  }

  void _onFirstCentrePassToggled(
    FirstCentrePassToggled event,
    Emitter<SetupWizardState> emit,
  ) {
    emit(state.copyWith(ourFirstCentrePass: event.ourPass));
  }

  void _onIsSuperShotToggled(
    IsSuperShotToggled event,
    Emitter<SetupWizardState> emit,
  ) {
    emit(state.copyWith(isSuperShot: event.isSuperShot));
  }

  void _onQuarterDurationChanged(
    QuarterDurationChanged event,
    Emitter<SetupWizardState> emit,
  ) {
    final clamped = event.minutes.clamp(1, 60);
    emit(state.copyWith(quarterDurationMinutes: clamped));
  }

  Future<void> _onSetupSubmitted(
    SetupSubmitted event,
    Emitter<SetupWizardState> emit,
  ) async {
    if (!state.isAllValid) {
      emit(
        state.copyWith(
          status: SetupWizardStatus.failure,
          errorMessage: 'Please complete all steps correctly.',
        ),
      );
      return;
    }

    emit(state.copyWith(status: SetupWizardStatus.loading));

    try {
      final compName =
          state.competitions
              .where((c) => c.id == state.competitionId)
              .map((c) => c.name)
              .firstOrNull ??
          'Unknown Competition';

      final venName =
          state.venues
              .where((v) => v.id == state.venueId)
              .map((v) => v.name)
              .firstOrNull ??
          'Unknown Venue';

      final game = Game(
        id: 0,
        opponentName: state.opponentName,
        competitionName: compName,
        venueName: venName,
        competitionId: state.competitionId,
        venueId: state.venueId,
        scheduledAt: state.scheduledAt,
        format: state.format,
        trackingMode: state.trackingMode,
        status: GameStatus.scheduled,
        homeTeamName: state.homeTeamName.isEmpty ? 'Home' : state.homeTeamName,
        ourFirstCentrePass: state.ourFirstCentrePass,
        isSuperShot: state.isSuperShot,
        quarterDurationMinutes: state.quarterDurationMinutes,
        createdAt: DateTime.now(),
      );

      final gameId = await _gameRepository.createGame(game);

      // Save Lineup
      final positionMapping = state.lineup.map(
        (pos, player) => MapEntry(pos, player!.id),
      );

      final lineup = MatchLineup(
        id: 0,
        gameId: gameId,
        positionToPlayerId: positionMapping,
      );

      await _gameRepository.saveLineup(lineup);

      emit(
        state.copyWith(
          status: SetupWizardStatus.success,
          createdGameId: gameId,
        ),
      );
    } on Object catch (e) {
      emit(
        state.copyWith(
          status: SetupWizardStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
