import 'package:flutter/material.dart';
import '../models/debt.dart';
import '../screens/edit_debt_screen.dart';

class DebtCard extends StatelessWidget {
  final Debt debt;

  const DebtCard({super.key, required this.debt});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF1F2235),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              debt.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'From: ${debt.person}',
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 2),
            Text(
              'Total: ₹${debt.totalAmount.toStringAsFixed(2)}',
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
            Text(
              'Remaining: ₹${debt.remainingAmount.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Colors.orangeAccent,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditDebtScreen(debt: debt),
                    ),
                  );
                },
                icon: const Icon(Icons.edit, size: 18),
                label: const Text("Edit"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
