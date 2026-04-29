import 'package:equatable/equatable.dart';
import '../../../data/models/homework_model.dart';

abstract class HomeworkState extends Equatable {
  const HomeworkState();
  @override
  List<Object?> get props => [];
}

class HomeworkInitial extends HomeworkState {}

class HomeworkLoading extends HomeworkState {}

class HomeworkLoaded extends HomeworkState {
  final List<HomeworkItem> allItems;
  final String filter;

  const HomeworkLoaded({required this.allItems, this.filter = 'All'});

  List<HomeworkItem> get filtered {
    switch (filter) {
      case 'Pending':
        return allItems.where((h) => !h.isSubmitted).toList();
      case 'Submitted':
        return allItems.where((h) => h.isSubmitted).toList();
      default:
        return allItems;
    }
  }

  int get pendingCount => allItems.where((h) => !h.isSubmitted).length;
  int get submittedCount => allItems.where((h) => h.isSubmitted).length;
  int get overdueCount => allItems.where((h) => h.isOverdue).length;

  HomeworkLoaded copyWith({String? filter}) =>
      HomeworkLoaded(allItems: allItems, filter: filter ?? this.filter);

  @override
  List<Object?> get props => [allItems, filter];
}

class HomeworkError extends HomeworkState {
  final String message;
  const HomeworkError(this.message);
  @override
  List<Object?> get props => [message];
}
