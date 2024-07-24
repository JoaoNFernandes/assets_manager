import 'package:assets_manager/models/company.dart';
import 'package:assets_manager/ui/widgets/filter_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubits/assets_cubit.dart';
import '../../cubits/states/assets_state.dart';
import '../widgets/assets_tree.dart';

class AssetsPage extends StatelessWidget {
  final Company company;
  const AssetsPage({super.key, required this.company});

  @override
  Widget build(BuildContext context) {
    final assetsCubit = context.read<AssetsCubit>();
    final companyId = company.id ?? "";
    final companyName = company.name ?? "";
    assetsCubit.clearState();
    return Scaffold(
      appBar: AppBar(
        title: Text('$companyName Assets Tree'),
      ),
      body: Column(
        children: [
          const FilterWidget(),
          Expanded(
            child: BlocBuilder<AssetsCubit, AssetsState>(
              builder: (context, state) {
                if (state is AssetsInitial) {
                  context
                      .read<AssetsCubit>()
                      .fetchAssetsAndLocations(companyId: companyId);
                  return const Center(child: CircularProgressIndicator());
                } else if (state is AssetsLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is AssetsLoaded) {
                  return AssetsTree(
                      locations: state.locations, assets: state.assets);
                } else if (state is AssetsError) {
                  return Center(child: Text('Error: ${state.message}'));
                } else {
                  return Container();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
