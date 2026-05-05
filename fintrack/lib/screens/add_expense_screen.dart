import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../models/category_manager.dart';
import '../utils/constants.dart';
import '../widgets/custom_text.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _titleController = TextEditingController();
  final _valueController = TextEditingController();
  final _newCategoryController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String _selectedCategory = CategoryManager.categories.first;
  DateTime _selectedDate = DateTime.now();

Future<void> _pickDate() async {
  final picked = await showDatePicker(
    context: context,
    initialDate: _selectedDate,
    firstDate: DateTime(2010),
    lastDate: DateTime(2040),
  );
  if (picked != null) setState(() => _selectedDate = picked);
}
  void _saveExpense() {
    if (_formKey.currentState!.validate()) {
      final title = _titleController.text;
      final valueText = _valueController.text.replaceAll(',', '.');
      final value = double.tryParse(valueText) ?? 0.0;

      if (value <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor, insira um valor válido maior que zero.')),
        );
        return;
      }

      final newExpense = Expense(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        value: value,
        date: _selectedDate,
        category: _selectedCategory,
      );

      Navigator.pop(context, newExpense);
    }
  }

  void _showAddCategoryDialog() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Nova Categoria'),
          content: TextField(
            controller: _newCategoryController,
            decoration: const InputDecoration(labelText: 'Nome da Categoria'),
            textCapitalization: TextCapitalization.words,
          ),
          actions: [
            TextButton(
              onPressed: () {
                _newCategoryController.clear();
                Navigator.pop(ctx);
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                final success = CategoryManager.addCategory(_newCategoryController.text);
                if (success) {
                  setState(() {
                    _selectedCategory = CategoryManager.categories.last;
                  });
                  _newCategoryController.clear();
                  Navigator.pop(ctx);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Categoria inválida ou já existente.')),
                  );
                }
              },
              child: const Text('Adicionar'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _valueController.dispose();
    _newCategoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova Despesa'),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Título da Despesa',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Informe um título';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppConstants.paddingMedium),
              TextFormField(
                controller: _valueController,
                decoration: const InputDecoration(
                  labelText: 'Valor (R\$)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Informe um valor';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppConstants.paddingMedium),
              
                GestureDetector(
                  onTap: _pickDate,
                  child: InputDecorator(
                  decoration: const InputDecoration(
                  labelText: 'Data',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_today),
      ),
                  child: Text(
                  '${_selectedDate.day.toString().padLeft(2, '0')}/${_selectedDate.month.toString().padLeft(2, '0')}/${_selectedDate.year}',
    ),
            
  ),
),
              const SizedBox(height: AppConstants.paddingMedium),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: _selectedCategory,
                      decoration: const InputDecoration(
                        labelText: 'Categoria',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.category),
                      ),
                      items: CategoryManager.categories.map((String category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedCategory = newValue;
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  IconButton(
                    icon: const Icon(Icons.add_circle, color: AppConstants.primaryColor, size: 36),
                    onPressed: _showAddCategoryDialog,
                    tooltip: 'Adicionar Categoria',
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.paddingLarge),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstants.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                  ),
                ),
                onPressed: _saveExpense,
                child: const CustomText(
                  'Salvar Despesa',
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
