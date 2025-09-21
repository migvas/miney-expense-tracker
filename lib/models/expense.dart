class Expense {
  final int? id;
  final String description;
  final double amount;
  final DateTime date;
  final int expenseTypeId;

  Expense({
    this.id,
    required this.description,
    required this.amount,
    required this.date,
    required this.expenseTypeId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'amount': amount,
      'date': date.millisecondsSinceEpoch,
      'expenseTypeId': expenseTypeId,
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      description: map['description'],
      amount: map['amount'],
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      expenseTypeId: map['expenseTypeId'],
    );
  }
}