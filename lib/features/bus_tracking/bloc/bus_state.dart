import 'package:equatable/equatable.dart';
import '../../../data/models/bus_model.dart';

abstract class BusState extends Equatable {
  const BusState();
  @override
  List<Object?> get props => [];
}

class BusInitial extends BusState {}

class BusLoading extends BusState {}

class BusLoaded extends BusState {
  final List<BusRoute> routes;
  final String selectedRouteId;

  const BusLoaded({required this.routes, required this.selectedRouteId});

  BusRoute get selectedRoute =>
      routes.firstWhere((r) => r.id == selectedRouteId);

  BusLoaded copyWith({List<BusRoute>? routes, String? selectedRouteId}) {
    return BusLoaded(
      routes: routes ?? this.routes,
      selectedRouteId: selectedRouteId ?? this.selectedRouteId,
    );
  }

  @override
  List<Object?> get props => [routes, selectedRouteId];
}

class BusError extends BusState {
  final String message;
  const BusError(this.message);
  @override
  List<Object?> get props => [message];
}
