import 'package:equatable/equatable.dart';
import 'package:netstats_pro/domain/usecases/get_match_summary_use_case.dart';

enum MatchSummaryStatus { initial, loading, success, failure }

class MatchSummaryState extends Equatable {
  const MatchSummaryState({
    this.status = MatchSummaryStatus.initial,
    this.summaryData,
    this.errorMessage,
  });

  final MatchSummaryStatus status;
  final MatchSummaryData? summaryData;
  final String? errorMessage;

  MatchSummaryState copyWith({
    MatchSummaryStatus? status,
    MatchSummaryData? summaryData,
    String? errorMessage,
  }) {
    return MatchSummaryState(
      status: status ?? this.status,
      summaryData: summaryData ?? this.summaryData,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, summaryData, errorMessage];
}
