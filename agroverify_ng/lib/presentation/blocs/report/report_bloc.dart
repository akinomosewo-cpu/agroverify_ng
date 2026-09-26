import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';
import '../../../domain/models/fake_batch_report.dart';

abstract class ReportEvent extends Equatable {
  const ReportEvent();
  @override
  List<Object?> get props => [];
}

class ReportSubmitted extends ReportEvent {
  final String productCode;
  final String description;
  final String? photoPath;
  final double? latitude;
  final double? longitude;

  const ReportSubmitted({
    required this.productCode,
    required this.description,
    this.photoPath,
    this.latitude,
    this.longitude,
  });

  @override
  List<Object?> get props => [productCode, description, photoPath, latitude, longitude];
}

abstract class ReportState extends Equatable {
  const ReportState();
  @override
  List<Object?> get props => [];
}

class ReportListState extends ReportState {
  final List<FakeBatchReport> reports;
  final FakeBatchReport? lastSubmitted;

  const ReportListState({this.reports = const [], this.lastSubmitted});

  ReportListState copyWith({List<FakeBatchReport>? reports, FakeBatchReport? lastSubmitted}) =>
      ReportListState(reports: reports ?? this.reports, lastSubmitted: lastSubmitted);

  @override
  List<Object?> get props => [reports, lastSubmitted];
}

/// Manages the list of "fake batch" reports a farmer has submitted from
/// this device, including validation of the minimum required fields.
class ReportBloc extends Bloc<ReportEvent, ReportState> {
  final Uuid _uuid;

  ReportBloc({Uuid? uuid}) : _uuid = uuid ?? const Uuid(), super(const ReportListState()) {
    on<ReportSubmitted>(_onReportSubmitted);
  }

  void _onReportSubmitted(ReportSubmitted event, Emitter<ReportState> emit) {
    final current = state;
    if (current is! ReportListState) return;
    if (event.productCode.trim().isEmpty || event.description.trim().isEmpty) {
      return;
    }
    final report = FakeBatchReport(
      id: _uuid.v4(),
      productCode: event.productCode.trim().toUpperCase(),
      description: event.description.trim(),
      photoPath: event.photoPath,
      latitude: event.latitude,
      longitude: event.longitude,
      createdAt: DateTime.now(),
    );
    emit(ReportListState(reports: [report, ...current.reports], lastSubmitted: report));
  }
}
