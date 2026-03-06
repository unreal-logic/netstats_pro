import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:netstats_pro/injection_container.dart';
import 'package:netstats_pro/presentation/games/bloc/setup_wizard_bloc.dart';
import 'package:netstats_pro/presentation/games/bloc/setup_wizard_event.dart';
import 'package:netstats_pro/presentation/games/bloc/setup_wizard_state.dart';
import 'package:netstats_pro/presentation/games/screens/steps/game_settings_step.dart';
import 'package:netstats_pro/presentation/games/screens/steps/lineup_selection_step.dart';
import 'package:netstats_pro/presentation/games/screens/steps/match_details_step.dart';
import 'package:netstats_pro/presentation/games/screens/steps/teams_setup_step.dart';
import 'package:netstats_pro/presentation/games/widgets/setup_progress_indicator.dart';
import 'package:netstats_pro/presentation/widgets/premium_app_bar.dart';

class SetupWizardScreen extends StatelessWidget {
  const SetupWizardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SetupWizardBloc>()..add(LoadSetupData()),
      child: const SetupWizardView(),
    );
  }
}

class SetupWizardView extends StatelessWidget {
  const SetupWizardView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SetupWizardBloc, SetupWizardState>(
      listener: (context, state) {
        if (state.status == SetupWizardStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Match Setup Complete!')),
          );
          if (state.createdGameId != null) {
            context.go('/games/live/${state.createdGameId}');
          } else {
            context.go('/games');
          }
        } else if (state.status == SetupWizardStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage ?? 'Setup failed')),
          );
        }
      },
      child: Scaffold(
        appBar: const PremiumAppBar(
          title: 'MATCH SETUP',
        ),
        body: BlocBuilder<SetupWizardBloc, SetupWizardState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  SetupProgressIndicator(
                    currentStep: state.currentStep,
                    totalSteps: 4,
                  ),
                  const SizedBox(height: 32),
                  Expanded(
                    child: IndexedStack(
                      index: state.currentStep,
                      children: const [
                        MatchDetailsStep(),
                        TeamsSetupStep(),
                        LineupSelectionStep(),
                        GameSettingsStep(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildControls(context, state),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildControls(BuildContext context, SetupWizardState state) {
    final isLastStep = state.currentStep == 3;
    final bloc = context.read<SetupWizardBloc>();

    return Row(
      children: [
        if (state.currentStep > 0) ...[
          Expanded(
            child: OutlinedButton(
              onPressed: () => bloc.add(StepChanged(state.currentStep - 1)),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('BACK'),
            ),
          ),
          const SizedBox(width: 12),
        ],
        Expanded(
          flex: 2,
          child: FilledButton(
            onPressed: state.status == SetupWizardStatus.loading
                ? null
                : () {
                    // Validation
                    if (state.currentStep == 0 && !state.isMatchInfoValid) {
                      _showError(
                        context,
                        'Please select competition and venue',
                      );
                      return;
                    }
                    if (state.currentStep == 1 && !state.isTeamsValid) {
                      _showError(
                        context,
                        'Please enter home and opponent names',
                      );
                      return;
                    }
                    if (state.currentStep == 2 && !state.isLineupValid) {
                      _showError(
                        context,
                        'Please assign all starting positions',
                      );
                      return;
                    }

                    if (isLastStep) {
                      bloc.add(SetupSubmitted());
                    } else {
                      bloc.add(StepChanged(state.currentStep + 1));
                    }
                  },
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: state.status == SetupWizardStatus.loading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text(isLastStep ? 'FINALIZE MATCH' : 'CONTINUE'),
          ),
        ),
      ],
    );
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }
}
