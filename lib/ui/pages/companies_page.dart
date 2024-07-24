import 'package:assets_manager/ui/widgets/company_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubits/companies_cubit.dart';
import '../../cubits/states/companies_state.dart';

class CompaniesPage extends StatelessWidget {
  const CompaniesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Companies'),
      ),
      body: BlocBuilder<CompaniesCubit, CompaniesState>(
        builder: (context, state) {
          if (state is CompaniesInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is CompaniesLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is CompaniesLoaded) {
            if (state.companies.isNotEmpty) {
              return ListView.builder(
                itemCount: state.companies.length,
                itemBuilder: (context, index) {
                  final company = state.companies[index];
                  return CompanyCard(company: company);
                },
              );
            }
            return const Center(
              child: Text('No companies registred!'),
            );
          }
          if (state is CompaniesError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return Container();
        },
      ),
    );
  }
}
