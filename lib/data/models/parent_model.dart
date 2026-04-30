import 'package:equatable/equatable.dart';

class ParentModel extends Equatable {
  final String id;
  final String name;

  const ParentModel({required this.id, required this.name});

  String get firstName => name.split(' ').first;

  @override
  List<Object?> get props => [id];
}
