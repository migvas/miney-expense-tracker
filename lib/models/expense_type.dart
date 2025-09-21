class ExpenseType {
  final int? id;
  final String name;
  final String color;

  ExpenseType({
    this.id,
    required this.name,
    required this.color,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'color': color,
    };
  }

  factory ExpenseType.fromMap(Map<String, dynamic> map) {
    return ExpenseType(
      id: map['id'],
      name: map['name'],
      color: map['color'],
    );
  }
}