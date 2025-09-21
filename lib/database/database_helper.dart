import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/expense.dart';
import '../models/expense_type.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'miney.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE expense_types(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        color TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE expenses(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        description TEXT NOT NULL,
        amount REAL NOT NULL,
        date INTEGER NOT NULL,
        expenseTypeId INTEGER NOT NULL,
        FOREIGN KEY (expenseTypeId) REFERENCES expense_types (id)
      )
    ''');

    await _insertDefaultExpenseTypes(db);
  }

  Future<void> _insertDefaultExpenseTypes(Database db) async {
    final defaultTypes = [
      {'name': 'Food', 'color': 'FF4CAF50'},
      {'name': 'Transportation', 'color': 'FF2196F3'},
      {'name': 'Entertainment', 'color': 'FFFF9800'},
      {'name': 'Shopping', 'color': 'FFE91E63'},
      {'name': 'Bills', 'color': 'FF9C27B0'},
    ];

    for (var type in defaultTypes) {
      await db.insert('expense_types', type);
    }
  }

  Future<int> insertExpenseType(ExpenseType expenseType) async {
    final db = await database;
    return await db.insert('expense_types', expenseType.toMap());
  }

  Future<List<ExpenseType>> getExpenseTypes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('expense_types');
    return List.generate(maps.length, (i) {
      return ExpenseType.fromMap(maps[i]);
    });
  }

  Future<int> insertExpense(Expense expense) async {
    final db = await database;
    return await db.insert('expenses', expense.toMap());
  }

  Future<List<Expense>> getExpenses() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'expenses',
      orderBy: 'date DESC',
    );
    return List.generate(maps.length, (i) {
      return Expense.fromMap(maps[i]);
    });
  }

  Future<List<Map<String, dynamic>>> getExpensesByType() async {
    final db = await database;
    return await db.rawQuery('''
      SELECT et.name as typeName, et.color, SUM(e.amount) as totalAmount
      FROM expenses e
      INNER JOIN expense_types et ON e.expenseTypeId = et.id
      GROUP BY e.expenseTypeId, et.name, et.color
      ORDER BY totalAmount DESC
    ''');
  }

  Future<List<Map<String, dynamic>>> getExpensesByMonth() async {
    final db = await database;
    return await db.rawQuery('''
      SELECT 
        strftime('%Y-%m', date/1000, 'unixepoch') as month,
        et.name as typeName,
        et.color,
        SUM(e.amount) as totalAmount
      FROM expenses e
      INNER JOIN expense_types et ON e.expenseTypeId = et.id
      GROUP BY month, e.expenseTypeId, et.name, et.color
      ORDER BY month DESC, totalAmount DESC
    ''');
  }

  Future<int> deleteExpense(int id) async {
    final db = await database;
    return await db.delete('expenses', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteExpenseType(int id) async {
    final db = await database;
    return await db.delete('expense_types', where: 'id = ?', whereArgs: [id]);
  }
}