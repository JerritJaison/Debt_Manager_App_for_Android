import 'package:csv/csv.dart';
import '../models/debt.dart';

class CsvExporter {
  static String exportDebtsToCsv(List<Debt> debts) {
    List<List<dynamic>> rows = [
      ['Title', 'Person', 'Total Amount', 'Remaining Amount', 'Category', 'Date', 'Deadline']
    ];

    for (var debt in debts) {
      rows.add([
        debt.title,
        debt.person,
        debt.totalAmount,
        debt.remainingAmount,  // calculated getter for remaining balance
        debt.category,
        debt.date.toIso8601String(),
        debt.deadline.toIso8601String(),
      ]);
    }

    return const ListToCsvConverter().convert(rows);
  }
}
