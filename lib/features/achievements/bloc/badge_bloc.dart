import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/badge_repository.dart';
import 'badge_event.dart';
import 'badge_state.dart';

class BadgeBloc extends Bloc<BadgeEvent, BadgeState> {
  final BadgeRepository _badgeRepository;

  BadgeBloc(this._badgeRepository) : super(BadgesInitial()) {
    on<BadgesFetch>(_onFetch);
  }

  Future<void> _onFetch(BadgesFetch event, Emitter<BadgeState> emit) async {
    emit(BadgesLoading());
    try {
      // Kick off both requests in parallel then await each.
      final typesFuture = _badgeRepository.fetchBadgeTypes();
      final earnedFuture = _badgeRepository.fetchBadges(event.studentId);
      final types = await typesFuture;
      final earned = await earnedFuture;
      emit(BadgesLoaded(badgeTypes: types, earnedBadges: earned));
    } catch (_) {
      emit(const BadgesError('Failed to load badges.'));
    }
  }
}
