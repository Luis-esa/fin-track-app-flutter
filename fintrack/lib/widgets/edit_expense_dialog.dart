import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../models/category_manager.dart';
import '../utils/constants.dart';

class EditExpenseDialog extends StatefulWidget {
  final Expense expense;

  const EditExpenseDialog({super.key, required this.expense});

  @override
  State<EditExpenseDialog> createState() => _EditExpenseDialogState();
}

class _EditExpenseDialogState extends State<EditExpenseDialog> {
  late final TextEditingController _titleController;
  late final TextEditingController _valueController;
  final _formKey = GlobalKey<FormState>();
  late String _selectedCategory;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.expense.title);
    _valueController = TextEditingController(
      text: widget.expense.value.toStringAsFixed(2).replaceAll('.', ','),
    );
    _selectedCategory = widget.expense.category;
    _selectedDate = widget.expense.date;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _valueController.dispose();
    super.dispose();
  }
Future<void> _pickDate() async {
  final picked = await showDatePicker(
    context: context,
    initialDate: _selectedDate,
    firstDate: DateTime(2000),
    lastDate: DateTime.now(),
  );
  if (picked != null) setState(() => _selectedDate = picked);
}
  void _save() {
    if (_formKey.currentState!.validate()) {
      final valueText = _valueController.text.replaceAll(',', '.');
      final value = double.tryParse(valueText) ?? 0.0;

      if (value <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Insira um valor válido maior que zero.')),
        );
        return;
      }

      final edited = Expense(
        id: widget.expense.id,       
        title: _titleController.text.trim(),
        value: value,
        date: _selectedDate,   
        category: _selectedCategory,
      );

      Navigator.pop(context, edited);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Editar Despesa'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Título',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                ),
                validator: (value) =>
                    (value == null || value.trim().isEmpty) ? 'Informe um título' : null,
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
                validator: (value) =>
                    (value == null || value.trim().isEmpty) ? 'Informe um valor' : null,
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
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Categoria',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
                items: CategoryManager.categories.map((cat) {
                  return DropdownMenuItem(value: cat, child: Text(cat));
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedCategory = val);
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppConstants.primaryColor,
            foregroundColor: Colors.white,
          ),
          onPressed: _save,
          child: const Text('Salvar'),
        ),
      ],
    );
  }
}