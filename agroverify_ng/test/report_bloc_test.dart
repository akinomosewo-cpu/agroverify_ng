import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:agroverify_ng/presentation/blocs/report/report_bloc.dart';

void main() {
  group('ReportBloc', () {
    blocTest<ReportBloc, ReportState>(
      'emits a new report at the front of the list on ReportSubmitted',
      build: () => ReportBloc(),
      act: (bloc) => bloc.add(const ReportSubmitted(
        productCode: 'sc-1234-5678',
        description: 'Seeds failed to germinate',
        latitude: 9.05,
        longitude: 7.49,
      )),
      expect: () => [
        isA<ReportListState>()
            .having((s) => s.reports.length, 'reports.length', 1)
            .having((s) => s.reports.first.productCode, 'productCode', 'SC-1234-5678')
            .having((s) => s.reports.first.hasLocation, 'hasLocation', isTrue),
      ],
    );

    blocTest<ReportBloc, ReportState>(
      'ignores a submission with an empty description',
      build: () => ReportBloc(),
      act: (bloc) => bloc.add(const ReportSubmitted(productCode: 'SC-1234-5678', description: '')),
      expect: () => [],
    );

    blocTest<ReportBloc, ReportState>(
      'ignores a submission with an empty product code',
      build: () => ReportBloc(),
      act: (bloc) => bloc.add(const ReportSubmitted(productCode: '  ', description: 'bad batch')),
      expect: () => [],
    );

    blocTest<ReportBloc, ReportState>(
      'accumulates multiple reports newest-first',
      build: () => ReportBloc(),
      act: (bloc) {
        bloc.add(const ReportSubmitted(productCode: 'A-111111', description: 'first'));
        bloc.add(const ReportSubmitted(productCode: 'B-222222', description: 'second'));
      },
      expect: () => [
        isA<ReportListState>().having((s) => s.reports.length, 'reports.length', 1),
        isA<ReportListState>()
            .having((s) => s.reports.length, 'reports.length', 2)
            .having((s) => s.reports.first.productCode, 'first is newest', 'B-222222'),
      ],
    );
  });
}
