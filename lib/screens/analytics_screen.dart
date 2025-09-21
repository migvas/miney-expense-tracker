import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../database/database_helper.dart';

class AnalyticsScreen extends StatefulWidget {
  @override
  _AnalyticsScreenState createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> _expensesByType = [];
  List<Map<String, dynamic>> _expensesByMonth = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAnalyticsData();
  }

  void _loadAnalyticsData() async {
    final expensesByType = await _dbHelper.getExpensesByType();
    final expensesByMonth = await _dbHelper.getExpensesByMonth();
    
    setState(() {
      _expensesByType = expensesByType;
      _expensesByMonth = expensesByMonth;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Analytics'),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Analytics'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Expenses by Category',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            _buildPieChart(),
            SizedBox(height: 32),
            Text(
              'Monthly Trends',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            _buildBarChart(),
            SizedBox(height: 32),
            Text(
              'Category Breakdown',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            _buildCategoryList(),
          ],
        ),
      ),
    );
  }

  Widget _buildPieChart() {
    if (_expensesByType.isEmpty) {
      return Container(
        height: 200,
        child: Center(
          child: Text(
            'No data available',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return Container(
      height: 300,
      child: PieChart(
        PieChartData(
          sections: _expensesByType.map((data) {
            return PieChartSectionData(
              color: Color(int.parse('0x${data['color']}')),
              value: data['totalAmount'],
              title: '\$${data['totalAmount'].toStringAsFixed(0)}',
              radius: 100,
              titleStyle: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            );
          }).toList(),
          sectionsSpace: 2,
          centerSpaceRadius: 0,
        ),
      ),
    );
  }

  Widget _buildBarChart() {
    if (_expensesByMonth.isEmpty) {
      return Container(
        height: 200,
        child: Center(
          child: Text(
            'No data available',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    Map<String, double> monthlyTotals = {};
    for (var data in _expensesByMonth) {
      String month = data['month'];
      double amount = data['totalAmount'];
      monthlyTotals[month] = (monthlyTotals[month] ?? 0) + amount;
    }

    List<String> months = monthlyTotals.keys.toList()..sort();
    months = months.take(6).toList();

    return Container(
      height: 300,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: monthlyTotals.values.isNotEmpty 
              ? monthlyTotals.values.reduce((a, b) => a > b ? a : b) * 1.2
              : 100,
          barTouchData: BarTouchData(enabled: false),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (double value, TitleMeta meta) {
                  int index = value.toInt();
                  if (index >= 0 && index < months.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        months[index].substring(5),
                        style: TextStyle(fontSize: 12),
                      ),
                    );
                  }
                  return Text('');
                },
                reservedSize: 30,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (double value, TitleMeta meta) {
                  return Text(
                    '\$${value.toInt()}',
                    style: TextStyle(fontSize: 10),
                  );
                },
                reservedSize: 40,
              ),
            ),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          barGroups: months.asMap().entries.map((entry) {
            int index = entry.key;
            String month = entry.value;
            double amount = monthlyTotals[month] ?? 0;
            
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: amount,
                  color: Colors.blue,
                  width: 20,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildCategoryList() {
    if (_expensesByType.isEmpty) {
      return Container(
        height: 100,
        child: Center(
          child: Text(
            'No data available',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    double total = _expensesByType.fold(0.0, (sum, data) => sum + data['totalAmount']);

    return Column(
      children: _expensesByType.map((data) {
        double percentage = (data['totalAmount'] / total) * 100;
        return Card(
          child: ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Color(int.parse('0x${data['color']}')),
                shape: BoxShape.circle,
              ),
            ),
            title: Text(data['typeName']),
            subtitle: Text('${percentage.toStringAsFixed(1)}% of total'),
            trailing: Text(
              '\$${data['totalAmount'].toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}