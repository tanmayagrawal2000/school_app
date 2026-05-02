import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/badge_repository.dart';
import 'badge_event.dart';
import 'badge_state.dart';

class BadgeBloc extends Bloc<BadgeEvent, BadgeState> {
  final BadgeRepository _badgeRepository;

  BadgeBloc(this._badgeRepository) : super(BadgesInitial()) {
    on<BadgesFetch>(_onFetch);
    on<BadgeRevoke>(_onRevoke);
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

  Future<void> _onRevoke(BadgeRevoke event, Emitter<BadgeState> emit) async {
    if (state is! BadgesLoaded) return;
    final previous = state as BadgesLoaded;
    emit(previous.copyWithout(event.badgeId));
    try {
      await _badgeRepository.revokeBadge(event.badgeId);
    } catch (_) {
      emit(previous);
    }
  }
}
