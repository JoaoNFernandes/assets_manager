import 'package:assets_manager/models/company.dart';
import 'package:flutter/material.dart';

import '../pages/assets_page.dart';

class CompanyCard extends StatelessWidget {
  final Company company;
  const CompanyCard({super.key, required this.company});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(
          Icons.apartment,
          color: Color.fromARGB(255, 33, 136, 255),
        ),
        title: Text(company.name!),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AssetsPage(company: company),
            ),
          );
        },
      ),
    );
  }
}
