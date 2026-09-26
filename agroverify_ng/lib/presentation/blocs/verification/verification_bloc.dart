import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../core/services/verification_service.dart';

abstract class VerificationEvent extends Equatable {
  const VerificationEvent();
  @override
  List<Object?> get props => [];
}

class CodeSubmitted extends VerificationEvent {
  final String code;
  const CodeSubmitted(this.code);
  @override
  List<Object?> get props => [code];
}

class VerificationReset extends VerificationEvent {
  const VerificationReset();
}

abstract class VerificationState extends Equatable {
  const VerificationState();
  @override
  List<Object?> get props => [];
}

class VerificationIdle extends VerificationState {
  const VerificationIdle();
}

class VerificationInProgress extends VerificationState {
  const VerificationInProgress();
}

class VerificationSuccess extends VerificationState {
  final VerificationResult result;
  const VerificationSuccess(this.result);
  @override
  List<Object?> get props => [result];
}

/// Drives the scan/verify flow: takes a scanned or typed code and asks the
/// [VerificationService] whether it is genuine, counterfeit, or unknown.
class VerificationBloc extends Bloc<VerificationEvent, VerificationState> {
  final VerificationService service;

  VerificationBloc({VerificationService? service})
      : service = service ?? VerificationService(),
        super(const VerificationIdle()) {
    on<CodeSubmitted>(_onCodeSubmitted);
    on<VerificationReset>((event, emit) => emit(const VerificationIdle()));
  }

  Future<void> _onCodeSubmitted(CodeSubmitted event, Emitter<VerificationState> emit) async {
    emit(const VerificationInProgress());
    final result = service.verify(event.code);
    emit(VerificationSuccess(result));
  }
}
