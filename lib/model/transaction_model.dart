// lib/models/transaction_model.dart
class Transaction {
  final String id;
  final String name;
  final String amount;

  Transaction({required this.id, required this.name, required this.amount});

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      name: json['name'],
      amount: json['amount'],
    );
  }
}
