import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:netstats_pro/domain/entities/player.dart';
import 'package:netstats_pro/domain/repositories/player_repository.dart';
import 'package:netstats_pro/injection_container.dart';
import 'package:netstats_pro/presentation/team/bloc/player_form_bloc.dart';
import 'package:netstats_pro/presentation/widgets/premium_app_bar.dart';

class AddPlayerScreen extends StatelessWidget {
  const AddPlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider(
      create: (context) => PlayerFormBloc(
        playerRepository: sl<PlayerRepository>(),
      ),
      child: BlocListener<PlayerFormBloc, PlayerFormState>(
        listener: (context, state) {
          if (state.status == PlayerFormStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Player added successfully!')),
            );
            context.pop();
          } else if (state.status == PlayerFormStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.errorMessage}')),
            );
          }
        },
        child: Scaffold(
          appBar: const PremiumAppBar(
            title: 'ADD NEW PLAYER',
          ),
          body: Builder(
            builder: (context) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Personal Details',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _FormField(
                      label: 'First Name',
                      onChanged: (val) => context.read<PlayerFormBloc>().add(
                        PlayerFirstNameChanged(val),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _FormField(
                      label: 'Last Name',
                      onChanged: (val) => context.read<PlayerFormBloc>().add(
                        PlayerLastNameChanged(val),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _FormField(
                      label: 'Nickname (Optional)',
                      onChanged: (val) => context.read<PlayerFormBloc>().add(
                        PlayerNicknameChanged(val),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Team Details',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _FormField(
                      label: 'Primary Number',
                      subtitle: "The player's bib or jersey number",
                      keyboardType: TextInputType.number,
                      onChanged: (val) => context.read<PlayerFormBloc>().add(
                        PlayerNumberChanged(val),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        Text(
                          'Preferred Positions',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        BlocBuilder<PlayerFormBloc, PlayerFormState>(
                          buildWhen: (p, c) =>
                              p.preferredPositions.isEmpty !=
                              c.preferredPositions.isEmpty,
                          builder: (context, state) {
                            if (state.preferredPositions.isNotEmpty) {
                              return const SizedBox.shrink();
                            }
                            return Text(
                              '(Select at least one)',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.error,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const _PositionSelector(),
                    const SizedBox(height: 48),
                    const _SubmitButton(),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _FormField extends StatelessWidget {
  const _FormField({
    required this.label,
    required this.onChanged,
    this.subtitle,
    this.keyboardType,
  });
  final String label;
  final String? subtitle;
  final ValueChanged<String> onChanged;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge,
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(
            subtitle!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
        const SizedBox(height: 8),
        TextField(
          onChanged: onChanged,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            filled: true,
            fillColor: Theme.of(
              context,
            ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }
}

class _PositionSelector extends StatelessWidget {
  const _PositionSelector();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayerFormBloc, PlayerFormState>(
      buildWhen: (p, c) => p.preferredPositions != c.preferredPositions,
      builder: (context, state) {
        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: NetballPosition.values.map((pos) {
            final isSelected = state.preferredPositions.contains(pos);
            return FilterChip(
              label: Text(pos.name),
              selected: isSelected,
              onSelected: (_) {
                context.read<PlayerFormBloc>().add(PlayerPositionToggled(pos));
              },
              backgroundColor: Theme.of(
                context,
              ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              selectedColor: Theme.of(context).colorScheme.primaryContainer,
              labelStyle: TextStyle(
                color: isSelected
                    ? Theme.of(context).colorScheme.onPrimaryContainer
                    : Theme.of(context).colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayerFormBloc, PlayerFormState>(
      builder: (context, state) {
        final isLoading = state.status == PlayerFormStatus.submitting;

        return SizedBox(
          width: double.infinity,
          height: 56,
          child: FilledButton(
            onPressed: state.isValid && !isLoading
                ? () =>
                      context.read<PlayerFormBloc>().add(PlayerFormSubmitted())
                : null,
            style: FilledButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: isLoading
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text(
                    'CREATE PLAYER',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
          ),
        );
      },
    );
  }
}
