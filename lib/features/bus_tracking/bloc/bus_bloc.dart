import 'dart:async';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import '../../../data/repositories/bus_repository.dart';
import 'bus_event.dart';
import 'bus_state.dart';

class BusBloc extends Bloc<BusEvent, BusState> {
  final BusRepository _repository;
  Timer? _simulationTimer;
  final _random = Random();

  BusBloc(this._repository) : super(BusInitial()) {
    on<BusFetchRoutes>(_onFetchRoutes);
    on<BusSelectRoute>(_onSelectRoute);
    on<BusUpdatePosition>(_onUpdatePosition);
  }

  Future<void> _onFetchRoutes(
    BusFetchRoutes event,
    Emitter<BusState> emit,
  ) async {
    emit(BusLoading());
    final routes = await _repository.fetchRoutes();
    emit(BusLoaded(routes: routes, selectedRouteId: routes.first.id));
    _startSimulation();
  }

  void _onSelectRoute(BusSelectRoute event, Emitter<BusState> emit) {
    if (state is BusLoaded) {
      emit((state as BusLoaded).copyWith(selectedRouteId: event.routeId));
    }
  }

  void _onUpdatePosition(BusUpdatePosition event, Emitter<BusState> emit) {
    if (state is! BusLoaded) return;
    final current = state as BusLoaded;
    final updatedRoutes = current.routes.map((route) {
      final jitter = _random.nextDouble() * 0.0005 - 0.00025;
      final newLat = route.currentPosition.latitude + jitter;
      final newLng = route.currentPosition.longitude + jitter;
      final newEta = (route.estimatedMinutes - 1).clamp(1, 60);
      return route.copyWith(
        currentPosition: LatLng(newLat, newLng),
        estimatedMinutes: newEta,
      );
    }).toList();
    emit(current.copyWith(routes: updatedRoutes));
  }

  void _startSimulation() {
    _simulationTimer?.cancel();
    _simulationTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      add(const BusUpdatePosition());
    });
  }

  @override
  Future<void> close() {
    _simulationTimer?.cancel();
    return super.close();
  }
}
