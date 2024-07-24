import 'package:assets_manager/models/tree_node.dart';

class Asset extends TreeNode {
  String? gatewayId;
  String? locationId;
  String? sensorId;
  String? sensorType;
  String? status;
  String? display;

  Asset({
    required String super.id,
    required String super.name,
    super.parentId,
    this.gatewayId,
    this.locationId,
    this.sensorId,
    this.sensorType,
    this.status,
  });

  factory Asset.fromJson(Map<String, dynamic> json) {
    return Asset(
      id: json['id'],
      name: json['name'],
      gatewayId: json['gatewayId'],
      locationId: json['locationId'],
      parentId: json['parentId'],
      sensorId: json['sensorId'],
      sensorType: json['sensorType'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'gatewayId': gatewayId,
        'id': id,
        'locationId': locationId,
        'name': name,
        'parentId': parentId,
        'sensorId': sensorId,
        'sensorType': sensorType,
        'status': status,
      };
}
