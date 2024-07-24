import 'package:assets_manager/models/tree_node.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:core';

import '../models/asset.dart';
import '../models/location.dart';
import '../services/api_service.dart';
import 'states/assets_state.dart';

class AssetsCubit extends Cubit<AssetsState> {
  final ApiService apiService;

  AssetsCubit({required this.apiService}) : super(const AssetsInitial());

  Future<void> fetchAssetsAndLocations({
    required String companyId,
  }) async {
    try {
      emit(const AssetsLoading());
      final locations = await apiService.getLocations(companyId);
      final assets = await apiService.getAssets(companyId);
      emit(AssetsLoaded(
        allAssets: assets,
        allLocations: locations,
        companyId: companyId,
        locations: locations,
        assets: assets,
      ));
    } catch (e) {
      emit(AssetsError(e.toString()));
    }
  }

  void clearState() {
    emit(const AssetsInitial());
  }

  applyFilters({String? filterText, bool? filterEnergy, bool? filterCritical}) {
    if (state is AssetsLoaded) {
      final currentState = state as AssetsLoaded;
      final newTextFilter = filterText ?? currentState.textFilter;
      final newEnergyFilter = filterEnergy ?? currentState.energyFilter;
      final newCriticalFilter = filterCritical ?? currentState.criticalFilter;

      List<Location> locations = [];
      List<Asset> assets = [];

      locations.addAll(currentState.allLocations);
      assets.addAll(currentState.allAssets);

      if (newTextFilter.isNotEmpty) {
        List<Location> locationResults = [];
        List<Asset> assetsResults = [];
        final result = textFilter(
            text: newTextFilter, locations: locations, assets: assets);
        locationResults.addAll(result?["locations"] as List<Location>);
        assetsResults.addAll(result?["assets"] as List<Asset>);

        locations =
            intersecLocationLists(list1: locations, list2: locationResults);
        assets = intersecAssetLists(list1: assets, list2: assetsResults);
      }

      if (newEnergyFilter) {
        List<Location> locationResults = [];
        List<Asset> assetsResults = [];
        final result = energyFilter(locations: locations, assets: assets);
        locationResults.addAll(result?["locations"] as List<Location>);
        assetsResults.addAll(result?["assets"] as List<Asset>);

        locations =
            intersecLocationLists(list1: locations, list2: locationResults);
        assets = intersecAssetLists(list1: assets, list2: assetsResults);
      }

      if (newCriticalFilter) {
        List<Location> locationResults = [];
        List<Asset> assetsResults = [];
        final result = criticalFilter(locations: locations, assets: assets);
        locationResults.addAll(result?["locations"] as List<Location>);
        assetsResults.addAll(result?["assets"] as List<Asset>);

        locations =
            intersecLocationLists(list1: locations, list2: locationResults);
        assets = intersecAssetLists(list1: assets, list2: assetsResults);
      }

      emit(AssetsLoaded(
        allLocations: currentState.allLocations,
        allAssets: currentState.allAssets,
        companyId: currentState.companyId,
        locations: locations,
        assets: assets,
        textFilter: newTextFilter,
        energyFilter: newEnergyFilter,
        criticalFilter: newCriticalFilter,
      ));
    }
  }

  List<Location> intersecLocationLists(
      {required List<Location> list1, required List<Location> list2}) {
    Set<Location> set1 = list1.toSet();
    Set<Location> set2 = list2.toSet();
    final result = set1.intersection(set2);
    return result.toList();
  }

  List<Asset> intersecAssetLists(
      {required List<Asset> list1, required List<Asset> list2}) {
    Set<Asset> set1 = list1.toSet();
    Set<Asset> set2 = list2.toSet();
    final result = set1.intersection(set2);
    return result.toList();
  }

  Map<String, List<TreeNode>>? textFilter({
    required String text,
    required List<Location> locations,
    required List<Asset> assets,
  }) {
    if (state is AssetsLoaded && text.isNotEmpty) {
      List<Location> newLocations = [];
      List<Asset> newAssets = [];

      newLocations.addAll(locations);
      newAssets.addAll(assets);

      List<Location> matchedLocations = [];
      List<Asset> matchedAssets = [];

      for (var location in newLocations) {
        // Verificando se possui o texto no nome da localização e se não existe no array
        if (location.name!.toLowerCase().contains(text.toLowerCase()) &&
            !matchedLocations.any((l) => l.id == location.id)) {
          // Adicionando localização no array
          matchedLocations.add(location);
          // Definindo variável auxiliar com o valor id do pai
          String? aux = location.parentId;
          // Percorrendo a ascendencia da localização
          while (aux != null) {
            // Verificando se existe localização com o id pai no array
            if (!matchedLocations.any((l) => l.id == aux)) {
              // Em caso de não possuir, adiciona a localização no array
              matchedLocations.add(locations.firstWhere((l) => l.id == aux));
              // Atribui à variável auxiliar o parentId da última localização adicionada ao array
              aux = matchedLocations.last.parentId;
            } else {
              // Caso a localização exista no array, significa que toda sua família também está, portanto é encerrado o while atribuindo null à variável aux
              aux = null;
            }
          }
        }
      }

      for (var asset in newAssets) {
        // Verificando se possui o texto no nome do ativo e se não existe no array
        if (asset.name!.toLowerCase().contains(text.toLowerCase()) &&
            !matchedAssets.any((a) => a.id == asset.id)) {
          // Adicionando ativo no array
          matchedAssets.add(asset);
          // Definindo variável auxiliar com o valor id do pai
          String? aux = asset.parentId;
          // Percorrendo a ascendencia do ativo
          while (aux != null) {
            // Verificando se existe ativo com o id pai no array
            if (!matchedAssets.any((a) => a.id == aux)) {
              // Em caso de não possuir, adiciona o ativo no array
              matchedAssets.add(newAssets.firstWhere((a) => a.id == aux));
              // Atribui à variável auxiliar o parentId do último ativo adicionado ao array
              aux = matchedAssets.last.parentId;
            } else {
              // Caso o ativo exista no array, significa que toda sua família também está, portanto é encerrado o while atribuindo null à variável aux
              aux = null;
            }
          }
        }
      }

      // Garantindo que todas as localizações dos ativos estejam no array
      for (var asset in newAssets) {
        // Definindo variável auxiliar com o valor id da localização relacionada
        String? aux = asset.locationId;
        // Percorrendo a ascendencia da localização
        while (aux != null) {
          // Verificando se existe localização com o id pai no array
          if (!matchedLocations.any((l) => l.id == aux)) {
            // Em caso de não possuir, adiciona a localização no array
            matchedLocations.add(newLocations.firstWhere((l) => l.id == aux));
            // Atribui à variável auxiliar o parentId da última localização adicionada ao array
            aux = matchedLocations.last.parentId;
          } else {
            // Caso a localização exista no array, significa que toda sua família também está, portanto é encerrado o while atribuindo null à variável aux
            aux = null;
          }
        }
      }

      newLocations
          .removeWhere((location) => !matchedLocations.contains(location));
      print(newLocations);

      newAssets.removeWhere((asset) => !matchedAssets.contains(asset));
      print(newAssets);

      return {
        "locations": newLocations,
        "assets": newAssets,
      };
    }
    return null;
  }

  Map<String, List<TreeNode>>? energyFilter({
    required List<Location> locations,
    required List<Asset> assets,
  }) {
    if (state is AssetsLoaded) {
      List<Location>? newLocations = [];
      newLocations.addAll(locations);
      List<Asset>? newAssets = [];
      newAssets.addAll(assets);

      List<Location> matchedLocations = [];
      List<Asset> matchedAssets = [];
      for (var asset in newAssets) {
        // Verificando se possui o texto no nome e se não existe no array
        if (asset.sensorType == "energy" &&
            !matchedAssets.any((a) => a.id == asset.id)) {
          // Adicionando ativo no array
          matchedAssets.add(asset);
          // Definindo variável auxiliar com o valor id do pai
          String? aux = asset.parentId;
          // Percorrendo a ascendencia do array
          while (aux != null) {
            // Verificando se existe ativo com o id pai nos ativos do array
            if (!matchedAssets.any((a) => a.id == aux)) {
              // Em caso de não possuir, adiciona o ativo no array
              matchedAssets.add(newAssets.firstWhere((a) => a.id == aux));
              // Atribui à variável auxiliar o parentId do último ativo adicionado ao array
              aux = matchedAssets.last.parentId;
            } else {
              // Caso o ativo exista no array, significa que toda sua família também está, portanto é encerrado o while atribuindo null à variável aux
              aux = null;
            }
          }
        }
      }

      // Garantindo que todas as localizações dos ativos estejam no array
      for (var asset in matchedAssets) {
        // Definindo variável auxiliar com o valor id da localização relacionada
        String? aux = asset.locationId;
        // Percorrendo a ascendencia da localização
        while (aux != null) {
          // Verificando se existe localização com o id pai nas localizações do array
          if (!matchedLocations.any((l) => l.id == aux)) {
            // Em caso de não possuir, adiciona a localização no array
            matchedLocations.add(newLocations.firstWhere((l) => l.id == aux));
            // Atribui à variável auxiliar o parentId da última localização adicionada ao array
            aux = matchedLocations.last.parentId;
          } else {
            // Caso a localização exista no array, significa que toda sua família também está, portanto é encerrado o while atribuindo null à variável aux
            aux = null;
          }
        }
      }

      newLocations
          .removeWhere((location) => !matchedLocations.contains(location));

      newAssets.removeWhere((asset) => !matchedAssets.contains(asset));

      return {
        "locations": newLocations,
        "assets": newAssets,
      };
    }
    return null;
  }

  Map<String, List<TreeNode>>? criticalFilter({
    required List<Location> locations,
    required List<Asset> assets,
  }) {
    if (state is AssetsLoaded) {
      List<Location> newLocations = [];
      newLocations.addAll(locations);
      List<Asset> newAssets = [];
      newAssets.addAll(assets);

      List<Location> matchedLocations = [];
      List<Asset> matchedAssets = [];
      for (var asset in newAssets) {
        // Verificando se possui o texto no nome e se não existe no array
        if (asset.status == "alert" &&
            !matchedAssets.any((a) => a.id == asset.id)) {
          // Adicionando ativo no array
          matchedAssets.add(asset);
          // Definindo variável auxiliar com o valor id do pai
          String? aux = asset.parentId;
          // Percorrendo a ascendencia do ativo
          while (aux != null) {
            // Verificando se existe ativo com o id pai no array
            if (!matchedAssets.any((a) => a.id == aux)) {
              // Em caso de não possuir, adiciona o ativo no array
              matchedAssets.add(newAssets.firstWhere((a) => a.id == aux));
              // Atribui à variável auxiliar o parentId do último ativo adicionado ao array
              aux = matchedAssets.last.parentId;
            } else {
              // Caso o ativo exista no array, significa que toda sua família também está, portanto é encerrado o while atribuindo null à variável aux
              aux = null;
            }
          }
        }
      }

      // Garantindo que todas as localizações dos ativos estejam no array
      for (var asset in matchedAssets) {
        // Definindo variável auxiliar com o valor id da localização relacionada
        String? aux = asset.locationId;
        // Percorrendo a ascendencia da localização
        while (aux != null) {
          // Verificando se existe localização com o id pai nas localizações do array
          if (!matchedLocations.any((l) => l.id == aux)) {
            // Em caso de não possuir, adiciona a localização no array
            matchedLocations.add(newLocations.firstWhere((l) => l.id == aux));
            // Atribui à variável auxiliar o parentId da última localização adicionada ao array
            aux = matchedLocations.last.parentId;
          } else {
            // Caso a localização exista no array, significa que toda sua família também está, portanto é encerrado o while atribuindo null à variável aux
            aux = null;
          }
        }
      }

      newLocations
          .removeWhere((location) => !matchedLocations.contains(location));
      print(newLocations);

      newAssets.removeWhere((asset) => !matchedAssets.contains(asset));
      print(newAssets);

      return {
        "locations": newLocations,
        "assets": newAssets,
      };
    }
    return null;
  }
}
