import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/debt.dart';
import '../services/firestore_service.dart';
import '../services/notification_service.dart';
import '../common/color_extension.dart'; // Your TColor

class EditDebtScreen extends StatefulWidget {
  final Debt debt;
  const EditDebtScreen({super.key, required this.debt});

  @override
  State<EditDebtScreen> createState() => _EditDebtScreenState();
}

class _EditDebtScreenState extends State<EditDebtScreen> {
  final _amountController = TextEditingController();
  final _firestoreService = FirestoreService();
  final _auth = FirebaseAuth.instance;

  List<Map<String, dynamic>> get payments => widget.debt.partialPayments;

  Future<void> _addPayment() async {
  final amount = double.tryParse(_amountController.text.trim());
  if (amount == null || amount <= 0) return;

  final newPayment = {
    'amount': amount,
    'date': DateTime.now().toIso8601String(),
  };

  final updatedPayments = List<Map<String, dynamic>>.from(payments)..add(newPayment);

  // Calculate remaining amount after this payment
  final totalPaidAfter = updatedPayments.fold<double>(0, (sum, p) => sum + (p['amount'] ?? 0));
  final remainingAfter = widget.debt.totalAmount - totalPaidAfter;

  final uid = _auth.currentUser?.uid;
  if (uid == null) return;

  if (remainingAfter <= 0) {
    // Debt fully paid, delete from database
    await _firestoreService.deleteDebt(uid, widget.debt.id);
     // Show local notification
    await NotificationService.showNotification(
      id: 1,
      title: 'Debt Paid',
      body: 'Congratulations! Your debt "${widget.debt.title}" with "${widget.debt.person}" has been fully paid 🎉.',
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
  content: Row(
    children: const [
      Icon(Icons.check_circle, color: Colors.white),
      SizedBox(width: 8),
      Text("Debt fully paid!✅"),
    ],
  ),
  backgroundColor: Colors.green,
)
,
    );
    Navigator.of(context).pop();
  } else {
    // Still remaining, update the debt
    final updatedDebt = Debt(
      id: widget.debt.id,
      title: widget.debt.title,
      person: widget.debt.person,
      totalAmount: widget.debt.totalAmount,
      category: widget.debt.category,
      date: widget.debt.date,
      deadline: widget.debt.deadline,
      partialPayments: updatedPayments,
      ownerId: widget.debt.ownerId,
    );

    await _firestoreService.updateDebt(uid, updatedDebt);
    if (!mounted) return;
    Navigator.of(context).pop();
  }
}


  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totalPaid = payments.fold<double>(0, (sum, p) => sum + (p['amount'] ?? 0));
    final remainingAmount = widget.debt.totalAmount - totalPaid;

    return Scaffold(
      backgroundColor: TColor.gray,
      appBar: AppBar(
        title: const Text("Edit Debt"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: TColor.primaryText),
        titleTextStyle: TextStyle(
          color: TColor.primaryText,
          fontWeight: FontWeight.w600,
          fontSize: 20,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Total: ₹${widget.debt.totalAmount.toStringAsFixed(2)}",
                style: TextStyle(color: TColor.primaryText, fontSize: 16)),
            Text("Remaining: ₹${remainingAmount.toStringAsFixed(2)}",
                style: TextStyle(color: TColor.gray40, fontSize: 14)),
            const SizedBox(height: 20),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              style: TextStyle(color: TColor.primaryText),
              decoration: InputDecoration(
                labelText: 'Add Payment',
                labelStyle: TextStyle(color: TColor.gray40),
                filled: true,
                fillColor: TColor.gray80,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: TColor.gray50),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: TColor.primary),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _addPayment,
              style: ElevatedButton.styleFrom(
                backgroundColor: TColor.primary,
                foregroundColor: TColor.primaryText,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                textStyle:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text("Submit"),
            ),
            const SizedBox(height: 20),
            Text("Payments Made:",
                style: TextStyle(color: TColor.primaryText, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Expanded(
              child: payments.isEmpty
                  ? Center(
                      child: Text("No payments made yet",
                          style: TextStyle(color: TColor.gray40)))
                  : ListView.builder(
                      itemCount: payments.length,
                      itemBuilder: (context, index) {
                        final p = payments[index];
                        final date = DateTime.tryParse(p['date'] ?? '') ?? DateTime.now();
                        final amount = p['amount'] ?? 0.0;

                        return ListTile(
                          title: Text("₹${(amount as double).toStringAsFixed(2)}",
                              style: TextStyle(color: TColor.primaryText)),
                          subtitle: Text(date.toLocal().toString().split(' ')[0],
                              style: TextStyle(color: TColor.gray40)),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
