import 'dart:math';
import 'package:flutter/material.dart';
import 'package:netstats_pro/domain/entities/competition.dart';
import 'package:netstats_pro/domain/entities/player.dart';
import 'package:netstats_pro/domain/entities/team.dart';
import 'package:netstats_pro/domain/entities/venue.dart';
import 'package:netstats_pro/domain/repositories/competition_repository.dart';
import 'package:netstats_pro/domain/repositories/player_repository.dart';
import 'package:netstats_pro/domain/repositories/team_repository.dart';
import 'package:netstats_pro/domain/repositories/venue_repository.dart';

class DemoDataService {
  DemoDataService({
    required this.teamRepository,
    required this.playerRepository,
    required this.competitionRepository,
    required this.venueRepository,
  });

  final TeamRepository teamRepository;
  final PlayerRepository playerRepository;
  final CompetitionRepository competitionRepository;
  final VenueRepository venueRepository;

  Future<void> generateDemoData() async {
    final random = Random();

    await _generateVenues(random);
    await _generateCompetitions(random);
    await _generateTeamsAndPlayers(random);
  }

  Future<void> _generateVenues(Random random) async {
    final venueNames = [
      'City Arena',
      'Sports Complex North',
      'Riverside Stadium',
      'East Side Courts',
      'Central Netball Centre',
    ];

    for (final name in venueNames) {
      final venue = Venue(
        id: 0,
        name: name,
        createdAt: DateTime.now(),
        indoor: random.nextBool(),
      );
      await venueRepository.saveVenue(venue);
    }
  }

  Future<void> _generateCompetitions(Random random) async {
    final competitionNames = [
      'Winter Premiership 2026',
      'Summer Social League',
      'Junior Development Cup',
      'State Championships',
    ];

    for (final name in competitionNames) {
      final competition = Competition(
        id: 0,
        name: name,
        createdAt: DateTime.now(),
        seasonYear: 2026,
      );
      await competitionRepository.saveCompetition(competition);
    }
  }

  Future<void> _generateTeamsAndPlayers(Random random) async {
    final teamNames = [
      'Vipers',
      'Thunder',
      'Lightning',
      'Firebirds',
      'Swifts',
      'Magpies',
      'Fever',
      'Giants',
      'Mystics',
      'Pulse',
      'Stars',
      'Tactix',
    ];
    final firstNames = [
      'Sarah',
      'Emma',
      'Jessica',
      'Emily',
      'Chloe',
      'Mia',
      'Olivia',
      'Charlotte',
      'Amelia',
      'Isabella',
      'Sophie',
      'Ruby',
      'Grace',
      'Lily',
      'Evie',
      'Zoe',
      'Harper',
      'Lucy',
      'Hannah',
      'Zara',
    ];
    final lastNames = [
      'Smith',
      'Jones',
      'Williams',
      'Brown',
      'Taylor',
      'Davies',
      'Evans',
      'Thomas',
      'Roberts',
      'Johnson',
      'Wilson',
      'Wright',
      'Wood',
      'Jackson',
      'Anderson',
      'Thompson',
      'Moore',
      'Martin',
    ];
    final colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.purple,
      Colors.orange,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
      Colors.cyan,
      Colors.amber,
      Colors.deepOrange,
      Colors.deepPurple,
    ];

    teamNames.shuffle(random);
    colors.shuffle(random);

    for (var t = 0; t < 5; t++) {
      final teamColor = colors[t % colors.length];

      final team = Team(
        id: 0,
        name: '${teamNames[t]} FC',
        color: teamColor,
        createdAt: DateTime.now(),
      );

      final teamId = await teamRepository.createTeam(team);

      // 12 players per team covering standard positions
      final availablePositions = [
        NetballPosition.gs,
        NetballPosition.ga,
        NetballPosition.wa,
        NetballPosition.c,
        NetballPosition.wd,
        NetballPosition.gd,
        NetballPosition.gk,
        NetballPosition.gs,
        NetballPosition.ga,
        NetballPosition.c,
        NetballPosition.gd,
        NetballPosition.gk,
      ];

      for (var p = 0; p < 12; p++) {
        final firstName = firstNames[random.nextInt(firstNames.length)];
        final lastName = lastNames[random.nextInt(lastNames.length)];

        final player = Player(
          id: 0,
          firstName: firstName,
          lastName: lastName,
          preferredPositions: [availablePositions[p]],
          teamId: teamId,
          primaryNumber: p + 1,
          createdAt: DateTime.now(),
        );

        await playerRepository.createPlayer(player);
      }
    }
  }
}
