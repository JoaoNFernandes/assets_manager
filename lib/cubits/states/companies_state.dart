import '../../models/company.dart';

sealed class CompaniesState {}

class CompaniesInitial implements CompaniesState {
  const CompaniesInitial();
}

class CompaniesLoading implements CompaniesState {
  const CompaniesLoading();
}

class CompaniesLoaded implements CompaniesState {
  final List<Company> companies;
  const CompaniesLoaded(this.companies);
}

class CompaniesError implements CompaniesState {
  final String message;
  const CompaniesError(this.message);
}
