import 'package:flutter/material.dart';
import '../models/debt.dart';
import '../services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/debt_card.dart';
import '../utils/csv_exporter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../common/color_extension.dart'; // assuming this contains TColor definitions

class DebtListScreen extends StatelessWidget {
  const DebtListScreen({super.key});

  Future<void> _exportToCsv(BuildContext context, List<Debt> debts) async {
    if (debts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No debts to export')),
      );
      return;
    }

    final csv = CsvExporter.exportDebtsToCsv(debts);
    final directory = await getTemporaryDirectory();
    final path = '${directory.path}/debts.csv';
    final file = File(path);
    await file.writeAsString(csv);

    await Share.shareXFiles([XFile(path)], text: 'Exported Debt Data');
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final FirestoreService firestore = FirestoreService();

    return Scaffold(
      backgroundColor: TColor.gray,
      appBar: AppBar(
        title: Text('Your Debts',
            style: TextStyle(
              color: TColor.white,
              fontWeight: FontWeight.w600,
            )),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: TColor.white),
      ),
      body: StreamBuilder<List<Debt>>(
        stream: firestore.debtsStream(uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final debts = snapshot.data ?? [];

          if (debts.isEmpty) {
            return Center(
              child: Text(
                'No debts found',
                style: TextStyle(color: TColor.gray40, fontSize: 16),
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: debts.length,
                  itemBuilder: (context, index) {
                    final debt = debts[index];
                    return DebtCard(debt: debt); // Ensure this card also matches theme
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.download),
                  label: const Text("Export CSV"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffFF7966),
                    foregroundColor: TColor.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    textStyle: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => _exportToCsv(context, debts),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
