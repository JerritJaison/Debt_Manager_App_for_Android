class Debt {
  final String id;
  final String ownerId;
  final String title;
  final String person;
  final double totalAmount;
  final String category;
  final DateTime date;
  final DateTime deadline;
  final List<Map<String, dynamic>> partialPayments;
  final String imageUrl; // Non-nullable

  Debt({
    required this.id,
    required this.ownerId,
    required this.title,
    required this.person,
    required this.totalAmount,
    required this.category,
    required this.date,
    required this.deadline,
    this.partialPayments = const [],
    this.imageUrl = '', // default empty string
  });

  double get remainingAmount {
    double paid =
        partialPayments.fold(0.0, (sum, p) => sum + (p['amount'] ?? 0));
    return totalAmount - paid;
  }

  Map<String, dynamic> toMap() {
    return {
      'ownerId': ownerId,
      'title': title,
      'person': person,
      'totalAmount': totalAmount,
      'category': category,
      'date': date.toIso8601String(),
      'deadline': deadline.toIso8601String(),
      'partialPayments': partialPayments,
      'imageUrl': imageUrl, // include this in map
    };
  }

  static Debt fromMap(String id, Map<String, dynamic> map) {
    return Debt(
      id: id,
      ownerId: map['ownerId'] ?? '',
      title: map['title'] ?? '',
      person: map['person'] ?? '',
      totalAmount: (map['totalAmount'] as num).toDouble(),
      category: map['category'] ?? '',
      date: DateTime.parse(map['date']),
      deadline: DateTime.parse(map['deadline']),
      partialPayments:
          List<Map<String, dynamic>>.from(map['partialPayments'] ?? []),
      imageUrl: map['imageUrl'] ?? '', // handle missing imageURL gracefully
    );
  }
}
