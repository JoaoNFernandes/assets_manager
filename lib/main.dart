import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubits/assets_cubit.dart';
import '../../cubits/companies_cubit.dart';
import '../../services/api_service.dart';
import 'ui/pages/companies_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final apiService = ApiService(
        dio: Dio(BaseOptions(baseUrl: 'https://fake-api.tractian.com')));
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              CompaniesCubit(apiService: apiService)..fetchCompanies(),
        ),
        BlocProvider(
          create: (context) => AssetsCubit(apiService: apiService),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Assets Manager',
        home: const CompaniesPage(),
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 33, 136, 255),
          ),
          useMaterial3: true,
        ),
      ),
    );
  }
}
