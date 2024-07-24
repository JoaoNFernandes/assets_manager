import 'package:assets_manager/models/tree_node.dart';

class Location extends TreeNode {
  Location({
    required String super.id,
    required String super.name,
    super.parentId,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'],
      name: json['name'],
      parentId: json['parentId'],
    );
  }
}
