import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';

class BusRoute extends Equatable {
  final String id;
  final String routeName;
  final String busNumber;
  final String driverName;
  final String driverContact;
  final String conductorName;
  final List<BusStop> stops;
  final LatLng currentPosition;
  final int nextStopIndex;
  final BusStatus status;
  final int estimatedMinutes;

  const BusRoute({
    required this.id,
    required this.routeName,
    required this.busNumber,
    required this.driverName,
    required this.driverContact,
    required this.conductorName,
    required this.stops,
    required this.currentPosition,
    required this.nextStopIndex,
    required this.status,
    required this.estimatedMinutes,
  });

  factory BusRoute.fromJson(Map<String, dynamic> json) => BusRoute(
        id: json['id'] as String,
        routeName: json['routeName'] as String,
        busNumber: json['busNumber'] as String,
        driverName: json['driverName'] as String,
        driverContact: json['driverContact'] as String,
        conductorName: json['conductorName'] as String,
        stops: (json['stops'] as List<dynamic>)
            .map((s) => BusStop.fromJson(s as Map<String, dynamic>))
            .toList(),
        currentPosition: LatLng(
          (json['currentLat'] as num).toDouble(),
          (json['currentLng'] as num).toDouble(),
        ),
        nextStopIndex: json['nextStopIndex'] as int,
        status: BusStatus.values.byName(json['status'] as String),
        estimatedMinutes: json['estimatedMinutes'] as int,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'routeName': routeName,
        'busNumber': busNumber,
        'driverName': driverName,
        'driverContact': driverContact,
        'conductorName': conductorName,
        'stops': stops.map((s) => s.toJson()).toList(),
        'currentLat': currentPosition.latitude,
        'currentLng': currentPosition.longitude,
        'nextStopIndex': nextStopIndex,
        'status': status.name,
        'estimatedMinutes': estimatedMinutes,
      };

  BusStop? get nextStop =>
      nextStopIndex < stops.length ? stops[nextStopIndex] : null;

  BusRoute copyWith({
    LatLng? currentPosition,
    int? nextStopIndex,
    BusStatus? status,
    int? estimatedMinutes,
  }) =>
      BusRoute(
        id: id,
        routeName: routeName,
        busNumber: busNumber,
        driverName: driverName,
        driverContact: driverContact,
        conductorName: conductorName,
        stops: stops,
        currentPosition: currentPosition ?? this.currentPosition,
        nextStopIndex: nextStopIndex ?? this.nextStopIndex,
        status: status ?? this.status,
        estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      );

  @override
  List<Object?> get props => [id, currentPosition, nextStopIndex, status];
}

class BusStop extends Equatable {
  final String name;
  final LatLng position;
  final String arrivalTime;
  final bool isPassed;

  const BusStop({
    required this.name,
    required this.position,
    required this.arrivalTime,
    this.isPassed = false,
  });

  factory BusStop.fromJson(Map<String, dynamic> json) => BusStop(
        name: json['name'] as String,
        position: LatLng(
          (json['lat'] as num).toDouble(),
          (json['lng'] as num).toDouble(),
        ),
        arrivalTime: json['arrivalTime'] as String,
        isPassed: json['isPassed'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'lat': position.latitude,
        'lng': position.longitude,
        'arrivalTime': arrivalTime,
        'isPassed': isPassed,
      };

  @override
  List<Object?> get props => [name, position];
}

enum BusStatus { onRoute, atStop, delayed, completed }
