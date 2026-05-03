import 'package:flutter/material.dart';
import '../utils/constants.dart';
import 'custom_text.dart';

class SummaryCard extends StatelessWidget {
  final double total;
  final String subtitle;

  const SummaryCard({
    super.key,
    required this.total,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final formattedTotal = 'R\$ ${total.toStringAsFixed(2).replaceAll('.', ',')}';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      decoration: BoxDecoration(
        color: AppConstants.primaryColor,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        boxShadow: [
          BoxShadow(
            color: AppConstants.primaryColor.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            subtitle,
            color: Colors.white70,
            fontSize: 14.0,
          ),
          const SizedBox(height: 8.0),
          CustomText(
            formattedTotal,
            color: Colors.white,
            fontSize: 36.0,
            fontWeight: FontWeight.bold,
          ),
        ],
      ),
    );
  }
}
