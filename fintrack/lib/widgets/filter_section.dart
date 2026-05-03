import 'package:flutter/material.dart';
import '../models/category_manager.dart';
import '../utils/constants.dart';

class FilterSection extends StatelessWidget {
  final int? selectedMonth;
  final int? selectedYear;
  final String? selectedCategory;
  final ValueChanged<int?> onMonthChanged;
  final ValueChanged<int?> onYearChanged;
  final ValueChanged<String?> onCategoryChanged;

  const FilterSection({
    super.key,
    required this.selectedMonth,
    required this.selectedYear,
    required this.selectedCategory,
    required this.onMonthChanged,
    required this.onYearChanged,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingMedium, vertical: 8.0),
      decoration: BoxDecoration(
        color: AppConstants.cardColor,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int?>(
                isExpanded: true,
                value: selectedMonth,
                hint: const Text('Mês', style: TextStyle(fontSize: 14)),
                items: [
                  const DropdownMenuItem(value: null, child: Text('Todos', style: TextStyle(fontSize: 14))),
                  ...List.generate(12, (index) => DropdownMenuItem(
                        value: index + 1,
                        child: Text((index + 1).toString().padLeft(2, '0'), style: const TextStyle(fontSize: 14)),
                      )),
                ],
                onChanged: onMonthChanged,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(width: 1, height: 24, color: Colors.grey.shade300),
          const SizedBox(width: 8),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int?>(
                isExpanded: true,
                value: selectedYear,
                hint: const Text('Ano', style: TextStyle(fontSize: 14)),
                items: [
                  const DropdownMenuItem(value: null, child: Text('Todos', style: TextStyle(fontSize: 14))),
                  ...List.generate(10, (index) => DropdownMenuItem(
                        value: 2024 + index,
                        child: Text('${2024 + index}', style: const TextStyle(fontSize: 14)),
                      )),
                ],
                onChanged: onYearChanged,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(width: 1, height: 24, color: Colors.grey.shade300),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String?>(
                isExpanded: true,
                value: selectedCategory,
                hint: const Text('Categoria', style: TextStyle(fontSize: 14)),
                items: [
                  const DropdownMenuItem(value: null, child: Text('Todas', style: TextStyle(fontSize: 14))),
                  ...CategoryManager.categories.map((c) => DropdownMenuItem(
                        value: c,
                        child: Text(c, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 14)),
                      )),
                ],
                onChanged: onCategoryChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
