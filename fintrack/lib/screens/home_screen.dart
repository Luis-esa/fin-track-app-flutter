import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../services/filter_service.dart';
import '../utils/constants.dart';
import '../widgets/custom_text.dart';
import '../widgets/expense_item.dart';
import '../widgets/summary_card.dart';
import '../widgets/filter_section.dart';
import '../widgets/chart_pie.dart';
import '../widgets/chart_bar.dart';
import 'add_expense_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Expense> _expenses = [];

  int? _selectedMonth;
  int? _selectedYear = DateTime.now().year; // Default to current year for bar chart
  String? _selectedCategory;

  List<Expense> get _filteredExpenses {
    return FilterService.filterExpenses(
      expenses: _expenses,
      month: _selectedMonth,
      year: _selectedYear,
      category: _selectedCategory,
    );
  }

  double get _filteredTotal {
    return FilterService.getTotal(_filteredExpenses);
  }

  void _removeExpense(String id) {
    setState(() {
      _expenses.removeWhere((expense) => expense.id == id);
    });
  }

  Future<void> _navigateAndAddExpense(BuildContext context) async {
    final newExpense = await Navigator.push<Expense>(
      context,
      MaterialPageRoute(builder: (context) => const AddExpenseScreen()),
    );

    if (newExpense != null) {
      setState(() {
        _expenses.add(newExpense);
      });
    }
  }

  String _getMonthName(int month) {
    const months = ['Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho', 'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'];
    return months[month - 1];
  }

  String get _reportSummaryText {
    final monthName = _selectedMonth != null ? _getMonthName(_selectedMonth!) : 'Todos os meses';
    final yearName = _selectedYear != null ? _selectedYear.toString() : 'Todos os anos';
    final catName = _selectedCategory != null && _selectedCategory != 'Todas' ? _selectedCategory : 'Todas as Categorias';
    
    if (_selectedMonth != null && _selectedYear != null) {
      return 'Total em $monthName $_selectedYear ($catName)';
    }
    return 'Total em $monthName/$yearName ($catName)';
  }

  @override
  Widget build(BuildContext context) {
    final pieData = FilterService.getExpensesGroupedByCategory(_filteredExpenses);
    final barData = FilterService.getExpensesGroupedByMonth(_expenses, _selectedYear ?? DateTime.now().year);

    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              backgroundColor: AppConstants.backgroundColor,
              elevation: 0,
              floating: true,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomText.title('FinTrack'),
                  CustomText.subtitle('Controle financeiro', fontSize: 14),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.paddingMedium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SummaryCard(
                      total: _filteredTotal,
                      subtitle: _reportSummaryText,
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    FilterSection(
                      selectedMonth: _selectedMonth,
                      selectedYear: _selectedYear,
                      selectedCategory: _selectedCategory,
                      onMonthChanged: (val) => setState(() => _selectedMonth = val),
                      onYearChanged: (val) => setState(() => _selectedYear = val),
                      onCategoryChanged: (val) => setState(() => _selectedCategory = val),
                    ),
                    if (_filteredExpenses.isNotEmpty) ...[
                      const SizedBox(height: AppConstants.paddingMedium),
                      ChartPie(data: pieData),
                      const SizedBox(height: AppConstants.paddingMedium),
                      if (_selectedYear != null) ChartBar(data: barData, year: _selectedYear!),
                    ],
                    const SizedBox(height: AppConstants.paddingLarge),
                    const CustomText.title('Transações', fontSize: 20),
                    const SizedBox(height: AppConstants.paddingSmall),
                  ],
                ),
              ),
            ),
            if (_filteredExpenses.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.account_balance_wallet, size: 64, color: Colors.grey.shade400),
                      const SizedBox(height: 16),
                      const CustomText.subtitle('Nenhuma despesa encontrada.'),
                    ],
                  ),
                ),
              )
            else
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final expense = _filteredExpenses[index];
                    return ExpenseItem(
                      expense: expense,
                      onDelete: () => _removeExpense(expense.id),
                    );
                  },
                  childCount: _filteredExpenses.length,
                ),
              ),
            const SliverToBoxAdapter(child: SizedBox(height: 80)), // Padding for FAB
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
        onPressed: () => _navigateAndAddExpense(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
