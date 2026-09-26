import 'package:equatable/equatable.dart';

/// A farmer-submitted report of a suspected counterfeit or bad batch.
///
/// [photoPath] and [latitude]/[longitude] are nullable because capturing a
/// photo or GPS fix can fail or be denied by the user; the report is still
/// accepted so the text description alone is not lost.
class FakeBatchReport extends Equatable {
  final String id;
  final String productCode;
  final String description;
  final String? photoPath;
  final double? latitude;
  final double? longitude;
  final DateTime createdAt;

  const FakeBatchReport({
    required this.id,
    required this.productCode,
    required this.description,
    this.photoPath,
    this.latitude,
    this.longitude,
    required this.createdAt,
  });

  bool get hasLocation => latitude != null && longitude != null;
  bool get hasPhoto => photoPath != null && photoPath!.isNotEmpty;

  Map<String, dynamic> toJson() => {
        'id': id,
        'productCode': productCode,
        'description': description,
        'photoPath': photoPath,
        'latitude': latitude,
        'longitude': longitude,
        'createdAt': createdAt.toIso8601String(),
      };

  factory FakeBatchReport.fromJson(Map<String, dynamic> json) => FakeBatchReport(
        id: json['id'] as String,
        productCode: json['productCode'] as String,
        description: json['description'] as String,
        photoPath: json['photoPath'] as String?,
        latitude: (json['latitude'] as num?)?.toDouble(),
        longitude: (json['longitude'] as num?)?.toDouble(),
        createdAt: DateTime.parse(json['createdAt'] as String),
      );

  @override
  List<Object?> get props => [id, productCode, description, photoPath, latitude, longitude, createdAt];
}
