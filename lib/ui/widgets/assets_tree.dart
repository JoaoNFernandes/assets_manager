import 'package:assets_manager/ui/widgets/assets_tree_node.dart';
import 'package:flutter/material.dart';
import '../../models/asset.dart';
import '../../models/location.dart';
import '../../models/tree_node.dart';

class AssetsTree extends StatelessWidget {
  final List<Location> locations;
  final List<Asset> assets;

  const AssetsTree({super.key, required this.locations, required this.assets});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: buildTree(),
    );
  }

  List<Widget> buildTree() {
    List<Location> rootLocations =
        locations.where((location) => location.parentId == null).toList();
    List<Widget> treeNodes = [];

    for (var location in rootLocations) {
      treeNodes.add(buildNode(location));
    }

    List<Asset> rootAssets = assets
        .where((asset) => asset.locationId == null && asset.parentId == null)
        .toList();

    for (var asset in rootAssets) {
      treeNodes.add(buildNode(asset));
    }

    return treeNodes;
  }

  Widget buildNode(TreeNode node) {
    List<Widget> children = [];
    Image icon;
    if (node is Location) {
      icon = Image.asset('assets/icons/location.png');
      List<Location> subLocations =
          locations.where((loc) => loc.parentId == node.id).toList();
      for (var subLocation in subLocations) {
        children.add(buildNode(subLocation));
      }

      List<Asset> localAssets = assets
          .where(
              (asset) => asset.locationId == node.id && asset.parentId == null)
          .toList();
      for (var localAsset in localAssets) {
        children.add(buildNode(localAsset));
      }

      return AssetsTreeNode(node: node, icon: icon, children: children);
    }

    if (node is Asset) {
      icon = node.sensorType == null
          ? Image.asset('assets/icons/asset.png')
          : Image.asset('assets/icons/component.png');
      List<Asset> subAssets =
          assets.where((a) => a.parentId == node.id).toList();
      for (var subAsset in subAssets) {
        children.add(buildNode(subAsset));
      }

      return AssetsTreeNode(
        node: node,
        icon: icon,
        children: children,
      );
    }

    return Container();
  }
}

