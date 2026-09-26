import 'package:equatable/equatable.dart';

/// A dealer (agro-input shop) that can be rated and mapped as trustworthy
/// or untrustworthy based on farmer reports and verification history.
class Dealer extends Equatable {
  final String id;
  final String name;
  final String location;
  final double latitude;
  final double longitude;
  final double rating; // 0.0 - 5.0
  final int reportsCount;

  const Dealer({
    required this.id,
    required this.name,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.rating,
    this.reportsCount = 0,
  });

  /// A dealer is considered trusted when their average rating is healthy
  /// and they have not accumulated a heavy count of counterfeit reports.
  bool get isTrusted => rating >= 3.5 && reportsCount < 3;

  @override
  List<Object?> get props => [id, name, location, latitude, longitude, rating, reportsCount];
}
