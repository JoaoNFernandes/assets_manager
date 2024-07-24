import '../../models/asset.dart';
import '../../models/location.dart';

sealed class AssetsState {}

class AssetsInitial implements AssetsState {
  const AssetsInitial();
}

class AssetsLoading implements AssetsState {
  const AssetsLoading();
}

class AssetsLoaded implements AssetsState {
  List<Location> allLocations;
  List<Asset> allAssets;
  String companyId;
  List<Location> locations;
  List<Asset> assets;
  String textFilter;
  bool energyFilter;
  bool criticalFilter;

  AssetsLoaded({
    required this.allLocations,
    required this.allAssets,
    required this.companyId,
    required this.locations,
    required this.assets,
    this.textFilter = "",
    this.energyFilter = false,
    this.criticalFilter = false,
  });
}

class AssetsError implements AssetsState {
  final String message;
  const AssetsError(this.message);
}
