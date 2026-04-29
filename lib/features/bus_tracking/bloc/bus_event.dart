import 'package:equatable/equatable.dart';

abstract class BusEvent extends Equatable {
  const BusEvent();
  @override
  List<Object?> get props => [];
}

class BusFetchRoutes extends BusEvent {
  const BusFetchRoutes();
}

class BusSelectRoute extends BusEvent {
  final String routeId;
  const BusSelectRoute(this.routeId);
  @override
  List<Object?> get props => [routeId];
}

class BusUpdatePosition extends BusEvent {
  const BusUpdatePosition();
}
