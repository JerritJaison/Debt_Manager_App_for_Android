import 'package:flutter/material.dart';
import '../services/gemini_service.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  String? _suggestedCategory;

  void _handleAddExpense() async {
    final title = _titleController.text;

    // 🧠 Use Gemini API to suggest category
    final category = await GeminiService().suggestCategory(title);

    setState(() {
      _suggestedCategory = category;
    });

    // Now you can use `category` when creating your Expense object
    print("Suggested category: $_suggestedCategory");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Expense')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _handleAddExpense,
              child: const Text('Add'),
            ),
            if (_suggestedCategory != null) ...[
              const SizedBox(height: 20),
              Text('Suggested Category: $_suggestedCategory'),
            ]
          ],
        ),
      ),
    );
  }
}
