import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../utils/constants.dart';
import 'custom_text.dart';
import 'delete_button.dart';

class ExpenseItem extends StatelessWidget {
  final Expense expense;
  final VoidCallback onDelete;

  const ExpenseItem({
    super.key,
    required this.expense,
    required this.onDelete,
  });

  String get _formattedValue {
    return 'R\$ ${expense.value.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  String get _formattedDate {
    return '${expense.date.day.toString().padLeft(2, '0')}/${expense.date.month.toString().padLeft(2, '0')}/${expense.date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingMedium,
        vertical: AppConstants.paddingSmall,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(AppConstants.paddingMedium),
        leading: CircleAvatar(
          backgroundColor: AppConstants.primaryColor.withValues(alpha: 0.1),
          child: const Icon(Icons.receipt_long, color: AppConstants.primaryColor),
        ),
        title: CustomText(
          expense.title,
          fontWeight: FontWeight.bold,
          fontSize: 18.0,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4.0),
            CustomText(
              expense.category,
              fontSize: 14.0,
              color: AppConstants.primaryColor,
              fontWeight: FontWeight.w500,
            ),
            const SizedBox(height: 2.0),
            CustomText(
              _formattedDate,
              fontSize: 12.0,
              color: Colors.grey.shade600,
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomText(
              _formattedValue,
              fontWeight: FontWeight.bold,
              color: Colors.green.shade700,
            ),
            const SizedBox(width: 8.0),
            DeleteButton(onPressed: onDelete),
          ],
        ),
      ),
    );
  }
}
