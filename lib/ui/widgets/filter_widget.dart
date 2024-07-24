import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubits/assets_cubit.dart';
import '../../cubits/states/assets_state.dart';

class FilterWidget extends StatelessWidget {
  const FilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: const InputDecoration(
              labelText: 'Filter by name',
              border: OutlineInputBorder(),
            ),
            onChanged: (text) {
              context.read<AssetsCubit>().applyFilters(filterText: text);
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Text('Energy Sensors'),
            Switch(
              value: context.select((AssetsCubit cubit) => cubit.state is AssetsLoaded && (cubit.state as AssetsLoaded).energyFilter),
              onChanged: (bool value) {
                context.read<AssetsCubit>().applyFilters(filterEnergy: value);
              },
            ),
            const Text('Critical Sensors'),
            Switch(
              value: context.select((AssetsCubit cubit) => cubit.state is AssetsLoaded && (cubit.state as AssetsLoaded).criticalFilter),
              onChanged: (bool value) {
                context.read<AssetsCubit>().applyFilters(filterCritical: value);
              },
            ),
          ],
        ),
      ],
    );
  }
}
