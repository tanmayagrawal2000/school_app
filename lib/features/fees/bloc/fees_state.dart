import 'package:equatable/equatable.dart';
import '../../../data/models/fee_model.dart';
import '../../../data/models/student_model.dart';

abstract class FeesState extends Equatable {
  const FeesState();
  @override
  List<Object?> get props => [];
}

class FeesInitial extends FeesState {}

class FeesLoading extends FeesState {}

class FeesLoaded extends FeesState {
  final StudentModel student;
  final List<FeeInstallment> installments;

  const FeesLoaded({required this.student, required this.installments});

  double get paidAmount =>
      installments.where((i) => i.status == FeeInstallmentStatus.paid).fold(0, (s, i) => s + i.amount);

  double get balanceAmount => student.totalFee - paidAmount;

  double get paidPercent =>
      student.totalFee == 0 ? 0 : (paidAmount / student.totalFee).clamp(0.0, 1.0);

  @override
  List<Object?> get props => [student, installments];
}

class FeesError extends FeesState {
  final String message;
  const FeesError(this.message);
  @override
  List<Object?> get props => [message];
}
