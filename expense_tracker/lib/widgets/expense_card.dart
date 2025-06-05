import 'package:flutter/material.dart';
import '../models/expense.dart';
import 'glassmorphic_container.dart';

class ExpenseCard extends StatelessWidget {
  final Expense expense;

  const ExpenseCard({super.key, required this.expense});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GlassMorphicCard(
        child: ListTile(
          leading: Icon(Icons.money, color: Colors.greenAccent),
          title: Text(expense.title, style: TextStyle(color: Colors.white)),
          subtitle: Text('${expense.date.toLocal()}'.split(' ')[0], style: TextStyle(color: Colors.white54)),
          trailing: Text('\$${expense.amount.toStringAsFixed(2)}', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
