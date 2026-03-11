import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:netstats_pro/core/design_system/widgets/buttons/app_button.dart';
import 'package:netstats_pro/domain/entities/game.dart';
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
            context.go('/match/live/${state.createdGameId}');
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
        appBar: PremiumAppBar(
          title: 'MATCH SETUP',
          leading: IconButton(
            icon: const Icon(Icons.close_rounded),
            onPressed: () => context.go('/games'),
          ),
        ),
        body: BlocBuilder<SetupWizardBloc, SetupWizardState>(
          builder: (context, state) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                  child: SetupProgressIndicator(
                    currentStep: state.currentStep,
                    totalSteps: state.trackingMode == TrackingMode.scoreOnly
                        ? 3
                        : 4,
                  ),
                ),
                const SizedBox(height: 32),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: IndexedStack(
                      index: state.currentStep,
                      children: [
                        const MatchDetailsStep(),
                        const TeamsSetupStep(),
                        if (state.trackingMode != TrackingMode.scoreOnly)
                          const LineupSelectionStep(),
                        const GameSettingsStep(),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        bottomNavigationBar: BlocBuilder<SetupWizardBloc, SetupWizardState>(
          builder: (context, state) {
            return BottomAppBar(
              height: 100,
              padding: const EdgeInsets.all(24),
              child: _buildControls(context, state),
            );
          },
        ),
      ),
    );
  }

  Widget _buildControls(BuildContext context, SetupWizardState state) {
    final maxStep = state.trackingMode == TrackingMode.scoreOnly ? 2 : 3;
    final isLastStep = state.currentStep == maxStep;
    final bloc = context.read<SetupWizardBloc>();

    return Row(
      children: [
        if (state.currentStep > 0) ...[
          Expanded(
            child: AppButton(
              label: 'BACK',
              onPressed: () => bloc.add(StepChanged(state.currentStep - 1)),
              variant: AppButtonVariant.outlined,
              size: AppButtonSize.lg,
            ),
          ),
          const SizedBox(width: 12),
        ] else ...[
          Expanded(
            child: AppButton(
              label: 'CANCEL',
              onPressed: () => context.go('/games'),
              variant: AppButtonVariant.outlined,
              size: AppButtonSize.lg,
            ),
          ),
          const SizedBox(width: 12),
        ],
        Expanded(
          child: AppButton(
            label: isLastStep ? 'START' : 'NEXT',
            onPressed: state.status == SetupWizardStatus.loading
                ? null
                : () {
                    // Validation
                    if (state.currentStep == 0 && !state.isMatchInfoValid) {
                      _showError(
                        context,
                        'Please select competition',
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
                    if (state.currentStep == 2 &&
                        state.trackingMode != TrackingMode.scoreOnly &&
                        !state.isLineupValid) {
                      _showError(
                        context,
                        'Please assign all starting positions',
                      );
                      return;
                    }

                    if (state.currentStep >= maxStep) {
                      bloc.add(SetupSubmitted());
                    } else {
                      bloc.add(StepChanged(state.currentStep + 1));
                    }
                  },
            isLoading: state.status == SetupWizardStatus.loading,
            size: AppButtonSize.lg,
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
