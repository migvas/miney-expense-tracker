import 'package:flutter/material.dart';
import '../models/expense_type.dart';
import '../database/database_helper.dart';

class ManageTypesScreen extends StatefulWidget {
  @override
  _ManageTypesScreenState createState() => _ManageTypesScreenState();
}

class _ManageTypesScreenState extends State<ManageTypesScreen> {
  List<ExpenseType> _expenseTypes = [];
  final DatabaseHelper _dbHelper = DatabaseHelper();

  final List<Color> _availableColors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.orange,
    Colors.purple,
    Colors.pink,
    Colors.teal,
    Colors.indigo,
    Colors.amber,
    Colors.brown,
  ];

  @override
  void initState() {
    super.initState();
    _loadExpenseTypes();
  }

  void _loadExpenseTypes() async {
    final types = await _dbHelper.getExpenseTypes();
    setState(() {
      _expenseTypes = types;
    });
  }

  void _showAddTypeDialog() {
    showDialog(
      context: context,
      builder: (context) => AddTypeDialog(
        availableColors: _availableColors,
        onTypeAdded: (ExpenseType type) async {
          await _dbHelper.insertExpenseType(type);
          _loadExpenseTypes();
        },
      ),
    );
  }

  void _deleteType(ExpenseType type) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Category'),
        content: Text('Are you sure you want to delete "${type.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await _dbHelper.deleteExpenseType(type.id!);
              _loadExpenseTypes();
              Navigator.pop(context);
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Categories'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _showAddTypeDialog,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _expenseTypes.length,
        itemBuilder: (context, index) {
          final type = _expenseTypes[index];
          return ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Color(int.parse('0x${type.color}')),
                shape: BoxShape.circle,
              ),
            ),
            title: Text(type.name),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deleteType(type),
            ),
          );
        },
      ),
    );
  }
}

class AddTypeDialog extends StatefulWidget {
  final List<Color> availableColors;
  final Function(ExpenseType) onTypeAdded;

  AddTypeDialog({
    required this.availableColors,
    required this.onTypeAdded,
  });

  @override
  _AddTypeDialogState createState() => _AddTypeDialogState();
}

class _AddTypeDialogState extends State<AddTypeDialog> {
  final _nameController = TextEditingController();
  Color _selectedColor = Colors.blue;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add New Category'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Category Name',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16),
          Text('Select Color:'),
          SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: widget.availableColors.map((color) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedColor = color;
                  });
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: _selectedColor == color
                        ? Border.all(color: Colors.black, width: 3)
                        : null,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (_nameController.text.isNotEmpty) {
              final type = ExpenseType(
                name: _nameController.text,
                color: _selectedColor.value.toRadixString(16).toUpperCase(),
              );
              widget.onTypeAdded(type);
              Navigator.pop(context);
            }
          },
          child: Text('Add'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}