import 'package:assets_manager/models/tree_node.dart';
import 'package:flutter/material.dart';

import '../../models/asset.dart';

class AssetsTreeNode extends StatelessWidget {
  final TreeNode node;
  final List<Widget>? children;
  final Image icon;
  const AssetsTreeNode(
      {super.key, this.children, required this.node, required this.icon});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    Widget title = Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        LimitedBox(
          maxWidth: w * .50,
          child: Text(
            node.name!,
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...(node is Asset && (node as Asset).sensorType == 'energy')
                ? [
                    Icon(
                      Icons.flash_on_rounded,
                      color: Colors.blue[700],
                    )
                  ]
                : [],
            ...(node is Asset && (node as Asset).status == 'alert')
                ? [
                    Icon(
                      Icons.report_problem_rounded,
                      color: Colors.red[700],
                    )
                  ]
                : [],
          ],
        ),
      ],
    );

    if (children == null || children!.isEmpty) {
      return ListTile(
        leading: icon,
        title: title,
      );
    }
    return ExpansionTile(
      // initiallyExpanded: true,
      leading: icon,
      title: title,
      childrenPadding: const EdgeInsets.only(left: 14),
      collapsedShape: Border.all(color: Colors.transparent),
      shape: Border.all(color: Colors.transparent),
      children: children ?? [],
    );
  }
}
