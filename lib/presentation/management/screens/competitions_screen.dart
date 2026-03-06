import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netstats_pro/domain/entities/competition.dart';
import 'package:netstats_pro/presentation/management/bloc/competitions_bloc.dart';
import 'package:netstats_pro/presentation/management/bloc/competitions_event.dart';
import 'package:netstats_pro/presentation/management/bloc/competitions_state.dart';
import 'package:netstats_pro/presentation/widgets/premium_app_bar.dart';

class CompetitionsScreen extends StatefulWidget {
  const CompetitionsScreen({super.key});

  @override
  State<CompetitionsScreen> createState() => _CompetitionsScreenState();
}

class _CompetitionsScreenState extends State<CompetitionsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CompetitionsBloc>().add(LoadCompetitions());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PremiumAppBar(
        title: 'Competitions',
      ),
      body: BlocBuilder<CompetitionsBloc, CompetitionsState>(
        builder: (context, state) {
          if (state is CompetitionsLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is CompetitionsError) {
            return Center(child: Text(state.message));
          }
          if (state is CompetitionsLoaded) {
            if (state.competitions.isEmpty) {
              return const Center(
                child: Text('No competitions yet. Add one below.'),
              );
            }
            return ListView.builder(
              itemCount: state.competitions.length,
              itemBuilder: (context, index) {
                final comp = state.competitions[index];
                return ListTile(
                  title: Text(comp.name),
                  subtitle: Text(
                    'Year: ${comp.seasonYear ?? 'N/A'} | Points: ${comp.pointsWin}/${comp.pointsDraw}/${comp.pointsLoss}',
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => context.read<CompetitionsBloc>().add(
                      DeleteCompetition(comp.id),
                    ),
                  ),
                );
              },
            );
          }
          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => unawaited(_showAddCompetitionDialog(context)),
        icon: const Icon(Icons.add),
        label: const Text('New Competition'),
      ),
    );
  }

  Future<void> _showAddCompetitionDialog(BuildContext context) async {
    final competitionsBloc = context.read<CompetitionsBloc>();
    final nameController = TextEditingController();
    final yearController = TextEditingController(
      text: DateTime.now().year.toString(),
    );
    final winController = TextEditingController(text: '4');
    final drawController = TextEditingController(text: '2');
    final lossController = TextEditingController(text: '0');

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) => Container(
        decoration: BoxDecoration(
          color: Theme.of(modalContext).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 16,
          bottom: MediaQuery.of(modalContext).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 32,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(modalContext).colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Add New Competition',
              style: Theme.of(modalContext).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Competition Name',
                hintText: 'e.g. Victorian Netball League',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.emoji_events_outlined),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: yearController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Season Year',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Scoring Rules (Points)',
              style: Theme.of(modalContext).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: winController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      labelText: 'Win',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: drawController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      labelText: 'Draw',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: lossController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      labelText: 'Loss',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  if (nameController.text.isNotEmpty) {
                    final comp = Competition(
                      id: 0,
                      name: nameController.text,
                      seasonYear: int.tryParse(yearController.text),
                      pointsWin: int.tryParse(winController.text) ?? 4,
                      pointsDraw: int.tryParse(drawController.text) ?? 2,
                      pointsLoss: int.tryParse(lossController.text) ?? 0,
                      createdAt: DateTime.now(),
                    );
                    competitionsBloc.add(AddCompetition(comp));
                    Navigator.pop(modalContext);
                  }
                },
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Save Competition'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
