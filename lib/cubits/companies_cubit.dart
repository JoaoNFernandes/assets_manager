import 'package:flutter_bloc/flutter_bloc.dart';

import '../services/api_service.dart';
import 'states/companies_state.dart';

class CompaniesCubit extends Cubit<CompaniesState> {
  final ApiService apiService;

  CompaniesCubit({required this.apiService}) : super(const CompaniesInitial());

  Future<void> fetchCompanies() async {
    try {
      emit(const CompaniesLoading());
      final companies = await apiService.getCompanies();
      emit(CompaniesLoaded(companies));
    } catch (e) {
      emit(CompaniesError(e.toString()));
    }
  }
}
