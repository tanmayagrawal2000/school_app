import 'package:equatable/equatable.dart';

enum FeeInstallmentStatus { paid, pending, overdue, partial }

class FeeInstallment extends Equatable {
  final String term;
  final String period;
  final double amount;
  final FeeInstallmentStatus status;
  final DateTime dueDate;
  final DateTime? paidDate;

  const FeeInstallment({
    required this.term,
    required this.period,
    required this.amount,
    required this.status,
    required this.dueDate,
    this.paidDate,
  });

  factory FeeInstallment.fromJson(Map<String, dynamic> json) => FeeInstallment(
        term: json['term'] as String,
        period: json['period'] as String,
        amount: (json['amount'] as num).toDouble(),
        status:
            FeeInstallmentStatus.values.byName(json['status'] as String),
        dueDate: DateTime.parse(json['dueDate'] as String),
        paidDate: json['paidDate'] != null
            ? DateTime.parse(json['paidDate'] as String)
            : null,
      );

  Map<String, dynamic> toJson() => {
        'term': term,
        'period': period,
        'amount': amount,
        'status': status.name,
        'dueDate': dueDate.toIso8601String(),
        'paidDate': paidDate?.toIso8601String(),
      };

  @override
  List<Object?> get props => [term, period, amount, status];
}
