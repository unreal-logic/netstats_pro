import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netstats_pro/domain/entities/game.dart';
import 'package:netstats_pro/domain/entities/player.dart';
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
    on<PositionAssigned>(_onPositionAssigned);
    on<AutoAssignLineup>(_onAutoAssignLineup);
    on<FirstCentrePassToggled>(_onFirstCentrePassToggled);
    on<IsSuperShotToggled>(_onIsSuperShotToggled);
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
    final newLineup = Map<NetballPosition, Player?>.from(state.lineup);
    final assignedPlayerIds = newLineup.values
        .whereType<Player>()
        .map((p) => p.id)
        .toSet();

    for (final pos in requiredPositions) {
      // Skip if already manually assigned
      if (newLineup[pos] != null) continue;

      // Find an unassigned player who prefers this position
      try {
        final matchingPlayer = allPlayers.firstWhere(
          (p) =>
              !assignedPlayerIds.contains(p.id) &&
              p.preferredPositions.contains(pos),
        );

        newLineup[pos] = matchingPlayer;
        assignedPlayerIds.add(matchingPlayer.id);
      } on Object catch (_) {
        // No matching unassigned player found for this position, leave it empty
      }
    }

    emit(state.copyWith(lineup: newLineup));
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
        status: GameStatus.scheduled,
        homeTeamName: state.homeTeamName.isEmpty ? 'Home' : state.homeTeamName,
        ourFirstCentrePass: state.ourFirstCentrePass,
        isSuperShot: state.isSuperShot,
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
