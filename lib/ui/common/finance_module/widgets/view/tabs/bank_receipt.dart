import 'package:flutter/material.dart';
import 'package:suraj_approval/core/widgets/no_data_found.dart';

class BankReceipt extends StatelessWidget {
  const BankReceipt({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: NoDataFound(),
    );
  }
}
