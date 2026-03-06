import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netstats_pro/domain/entities/venue.dart';
import 'package:netstats_pro/presentation/management/bloc/venues_bloc.dart';
import 'package:netstats_pro/presentation/management/bloc/venues_event.dart';
import 'package:netstats_pro/presentation/management/bloc/venues_state.dart';
import 'package:netstats_pro/presentation/widgets/premium_app_bar.dart';

class VenuesScreen extends StatefulWidget {
  const VenuesScreen({super.key});

  @override
  State<VenuesScreen> createState() => _VenuesScreenState();
}

class _VenuesScreenState extends State<VenuesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<VenuesBloc>().add(LoadVenues());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PremiumAppBar(
        title: 'Venues',
      ),
      body: BlocBuilder<VenuesBloc, VenuesState>(
        builder: (context, state) {
          if (state is VenuesLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is VenuesError) {
            return Center(child: Text(state.message));
          }
          if (state is VenuesLoaded) {
            if (state.venues.isEmpty) {
              return const Center(
                child: Text('No venues yet. Add one below.'),
              );
            }
            return ListView.builder(
              itemCount: state.venues.length,
              itemBuilder: (context, index) {
                final venue = state.venues[index];
                return ListTile(
                  title: Text(venue.name),
                  subtitle: Text(
                    '${venue.indoor ? 'Indoor' : 'Outdoor'} | '
                    '${venue.address ?? ''}',
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      context.read<VenuesBloc>().add(
                        DeleteVenue(venue.id),
                      );
                    },
                  ),
                );
              },
            );
          }
          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => unawaited(_showAddVenueDialog(context)),
        icon: const Icon(Icons.add),
        label: const Text('New Venue'),
      ),
    );
  }

  Future<void> _showAddVenueDialog(BuildContext context) async {
    final venuesBloc = context.read<VenuesBloc>();
    final nameController = TextEditingController();
    final addressController = TextEditingController();
    var isIndoor = true;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) => StatefulBuilder(
        builder: (stateContext, setModalState) => Container(
          decoration: BoxDecoration(
            color: Theme.of(stateContext).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 16,
            bottom: MediaQuery.of(stateContext).viewInsets.bottom + 24,
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
                    color: Theme.of(context).colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Add New Venue',
                style: Theme.of(stateContext).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Venue Name',
                  hintText: 'e.g. State Netball Centre',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.stadium_outlined),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: addressController,
                decoration: InputDecoration(
                  labelText: 'Address',
                  hintText: 'e.g. 10 Brougham St, Parkville',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.location_on_outlined),
                ),
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Indoor Venue'),
                subtitle: const Text('Is this venue an indoor facility?'),
                value: isIndoor,
                onChanged: (val) => setModalState(() => isIndoor = val),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: Theme.of(stateContext).colorScheme.outlineVariant,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    if (nameController.text.isNotEmpty) {
                      final venue = Venue(
                        id: 0,
                        name: nameController.text,
                        address: addressController.text,
                        indoor: isIndoor,
                        createdAt: DateTime.now(),
                      );
                      venuesBloc.add(AddVenue(venue));
                      Navigator.pop(stateContext);
                    }
                  },
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Save Venue'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
