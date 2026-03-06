import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netstats_pro/domain/usecases/get_match_summary_use_case.dart';
import 'package:netstats_pro/presentation/games/bloc/match_summary_event.dart';
import 'package:netstats_pro/presentation/games/bloc/match_summary_state.dart';

class MatchSummaryBloc extends Bloc<MatchSummaryEvent, MatchSummaryState> {
  MatchSummaryBloc({required this.getMatchSummaryUseCase})
    : super(const MatchSummaryState()) {
    on<LoadMatchSummary>(_onLoadMatchSummary);
  }

  final GetMatchSummaryUseCase getMatchSummaryUseCase;

  Future<void> _onLoadMatchSummary(
    LoadMatchSummary event,
    Emitter<MatchSummaryState> emit,
  ) async {
    emit(state.copyWith(status: MatchSummaryStatus.loading));

    try {
      final summaryData = await getMatchSummaryUseCase(event.gameId);
      emit(
        state.copyWith(
          status: MatchSummaryStatus.success,
          summaryData: summaryData,
        ),
      );
    } on Object catch (e) {
      emit(
        state.copyWith(
          status: MatchSummaryStatus.failure,
          errorMessage: 'Failed to load match summary: $e',
        ),
      );
    }
  }
}
