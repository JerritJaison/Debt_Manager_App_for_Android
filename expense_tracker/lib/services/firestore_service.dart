import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/debt.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> debtsRef(String uid) =>
      _firestore.collection('users').doc(uid).collection('debts');

  Stream<List<Debt>> debtsStream(String uid) {
    return debtsRef(uid)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Debt.fromMap(doc.id, doc.data())).toList());
  }

  Future<void> addDebt(String uid, Debt debt) async {
    await debtsRef(uid).add(debt.toMap());
  }

  Future<void> updateDebt(String uid, Debt debt) async {
    if (debt.id.isEmpty) {
      throw Exception('Debt ID is required for update');
    }
    await debtsRef(uid).doc(debt.id).update(debt.toMap());
  }

  Future<void> deleteDebt(String uid, String debtId) async {
    await debtsRef(uid).doc(debtId).delete();
  }
}
