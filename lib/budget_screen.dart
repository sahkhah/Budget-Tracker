import 'package:budget_tracker_app/spending_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'budget_repository.dart';
import 'failure_model.dart';
import 'item_model.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  late Future<List<Item>> _futureItems;

  @override
  void initState() {
    _futureItems = BudgetRepository().getItem();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Budget Tracker')),
      body: RefreshIndicator(
        onRefresh: () async {
          _futureItems = BudgetRepository().getItem();
          setState(() {
            
          });
        },
        child: FutureBuilder<List<Item>>(
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              //show pie chart
              final items = snapshot.data!;
              return ListView.builder(
                itemBuilder: (context, index) {
                  if (index == 0) return SpendingChart(items: items);
                  final item = items[index - 1];
                  return Container(
                    margin: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                            width: 2.0, color: getCategoryColor(item.category)),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            offset: Offset(0, 2),
                            blurRadius: 6.0,
                          ),
                        ]),
                    child: ListTile(
                      title: Text(item.name),
                      subtitle: Text(
                          '${item.category} - ${DateFormat.yMd().format(item.date)}'),
                      trailing: Text('-\$${item.price.toStringAsFixed(2)}'),
                    ),
                  );
                },
                itemCount: items.length + 1,
              );
            } else if (snapshot.hasError) {
              final failure = snapshot.error as Failure;
              return Center(
                child: Text(failure.message),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
          future: _futureItems,
        ),
      ),
    );
  }

  Color getCategoryColor(String category) {
    switch (category) {
      case 'Entertainment':
        return Colors.red[400]!;
      case 'Personal':
        return Colors.green[400]!;
      case 'Transportation':
        return Colors.blue[400]!;
      case 'Food':
        return Colors.purple[400]!;
      default:
        return Colors.orange[400]!;
    }
  }
}
