import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../models/category_manager.dart';
import '../services/filter_service.dart';
import '../utils/constants.dart';
import '../widgets/custom_text.dart';
import '../widgets/expense_item.dart';
import 'add_expense_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Expense> _expenses = [];

  int? _selectedMonth;
  int? _selectedYear;
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
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: const Text('FinTrack'),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppConstants.paddingLarge),
            decoration: const BoxDecoration(
              color: AppConstants.primaryColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24.0),
                bottomRight: Radius.circular(24.0),
              ),
            ),
            child: Column(
              children: [
                CustomText(
                  _reportSummaryText,
                  color: Colors.white70,
                  fontSize: 14.0,
                ),
                const SizedBox(height: 8.0),
                CustomText(
                  'R\$ ${_filteredTotal.toStringAsFixed(2).replaceAll('.', ',')}',
                  color: Colors.white,
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
          ),
          
          // Filters Area
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButton<int?>(
                    isExpanded: true,
                    value: _selectedMonth,
                    hint: const Text('Mês'),
                    items: [
                      const DropdownMenuItem(value: null, child: Text('Todos')),
                      ...List.generate(12, (index) => DropdownMenuItem(
                            value: index + 1,
                            child: Text((index + 1).toString().padLeft(2, '0')),
                          )),
                    ],
                    onChanged: (val) => setState(() => _selectedMonth = val),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButton<int?>(
                    isExpanded: true,
                    value: _selectedYear,
                    hint: const Text('Ano'),
                    items: [
                      const DropdownMenuItem(value: null, child: Text('Todos')),
                      ...List.generate(10, (index) => DropdownMenuItem(
                            value: 2024 + index,
                            child: Text('${2024 + index}'),
                          )),
                    ],
                    onChanged: (val) => setState(() => _selectedYear = val),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: DropdownButton<String?>(
                    isExpanded: true,
                    value: _selectedCategory,
                    hint: const Text('Categoria'),
                    items: [
                      const DropdownMenuItem(value: null, child: Text('Todas')),
                      ...CategoryManager.categories.map((c) => DropdownMenuItem(
                            value: c,
                            child: Text(c),
                          )),
                    ],
                    onChanged: (val) => setState(() => _selectedCategory = val),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: _filteredExpenses.isEmpty
                ? const Center(
                    child: CustomText(
                      'Nenhuma despesa encontrada.',
                      fontSize: 18.0,
                      color: Colors.grey,
                    ),
                  )
                : ListView.builder(
                    itemCount: _filteredExpenses.length,
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    itemBuilder: (context, index) {
                      final expense = _filteredExpenses[index];
                      return ExpenseItem(
                        expense: expense,
                        onDelete: () => _removeExpense(expense.id),
                      );
                    },
                  ),
          ),
        ],
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
