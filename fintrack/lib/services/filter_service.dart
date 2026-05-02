import '../models/expense.dart';

class FilterService {
  static List<Expense> filterExpenses({
    required List<Expense> expenses,
    int? month,
    int? year,
    String? category,
  }) {
    return expenses.where((expense) {
      final matchMonth = month == null || expense.date.month == month;
      final matchYear = year == null || expense.date.year == year;
      final matchCategory = category == null || category == 'Todas' || expense.category == category;
      return matchMonth && matchYear && matchCategory;
    }).toList();
  }

  static double getTotal(List<Expense> expenses) {
    return expenses.fold(0.0, (sum, item) => sum + item.value);
  }

  static List<Expense> getExpensesByMonth(List<Expense> expenses, int month, int year) {
    return filterExpenses(expenses: expenses, month: month, year: year);
  }

  static List<Expense> getExpensesByCategory(List<Expense> expenses, String category) {
    return filterExpenses(expenses: expenses, category: category);
  }

  static double getTotalByFilter(List<Expense> expenses, {int? month, int? year, String? category}) {
    final filtered = filterExpenses(expenses: expenses, month: month, year: year, category: category);
    return getTotal(filtered);
  }
}
